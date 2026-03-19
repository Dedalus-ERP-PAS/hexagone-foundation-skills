# Hexagone Web Services Documentation

## Vue d'ensemble

Le skill **hexagone-swdoc** donne aux agents IA un accès à la documentation des web services Hexagone ("Référence Appels Externes"), publiée sur GitLab Pages. Il permet de consulter les spécifications SOAP (Simple Object Access Protocol), les formats XML, les codes d'erreur et les règles métier -- sans cloner le dépôt.

## Ce qu'il fait

- **Consulte à la demande** la documentation publiée sur GitLab Pages
- **Explique** les méthodes SOAP, paramètres et formats de requête/réponse XML
- **Liste** les web services disponibles par domaine fonctionnel
- **Aide au débogage** en comparant les appels réels avec les spécifications
- **Référence croisée** avec les skills HPK et HL7 PAM (interopérabilité)

## Quand l'utiliser

Utilisez ce skill quand vous avez besoin de :

- Connaître les méthodes et paramètres d'un web service Hexagone (EWPT0001 à EWPT0014)
- Comprendre le format XML / DTD (Document Type Definition) d'une méthode SOAP
- Lister les web services disponibles pour un domaine fonctionnel
- Déboguer une intégration avec un web service Hexagone
- Comprendre les règles métier associées à un service
- Vérifier la configuration requise par application (CODEGEST, PSACC, etc.)

## Prérequis

- Accès au réseau interne Dedalus (pour atteindre les GitLab Pages)

## Démarrage rapide

```bash
npx skills add Dedalus-ERP-PAS/foundation-skills --skill hexagone-swdoc -g -y
```

## Fonctionnement

Le skill utilise **WebFetch** pour consulter les pages publiées sur GitLab Pages :

1. **Identification du service** : à partir de la question, le skill identifie le service EWPT concerné grâce à un catalogue intégré.

2. **Récupération de la page** : appel WebFetch sur l'URL du service concerné.

3. **Extraction et présentation** : extraction de la section pertinente (méthode, DTD, codes d'erreur) et présentation structurée.

## Services disponibles

| Service | Domaine | Méthodes principales |
|---------|---------|---------------------|
| EWPT0001 | Gestion des patients | READ/FIND/NEW/UPDATE_PATIENT, READ_COVERAGES, READ_KINS, etc. |
| EWPT0002 | Gestion des urgences | READ/NEW/UPDATE/DELETE_EMERGENCY, TO_OUTPATIENT, TO_INPATIENT |
| EWPT0003 | Consultations externes | NEW/READ/UPDATE/DELETE_OUTPATIENT |
| EWPT0004 | Dossiers d'hospitalisation | READ/NEW/UPDATE/DELETE_INPATIENT, READ/NEW/UPDATE/DELETE_MOVEMENT |
| EWPT0005 | Lecture des occupations | UF_OCC, AVAILABLE_BEDS, IN_HOSPITAL, etc. |
| EWPT0007 | Gestion des séjours | PATIENT_CASES, CASE_MVTS, CHG_CASE_TYPE, etc. |
| EWPT0008 | Produits | PRODUCT_CREATION, PRODUCT_VERIFICATION, GET_*, etc. |
| EWPT0009 | Gestion du DMP (Dossier Médical Partagé) | NEW/UPDATE_REJECTION, ACCESS_CODE, INFO_VITALE, etc. |
| EWPT0010 | Gestion des praticiens | FIND/NEW/UPDATE_PRACT |
| EWPT0012 | Intégration d'actes | INTEGR_CCAM |
| EWPT0013 | Régénération identités/mouvements | REGEN_IDMVT |
| EWPT0014 | Structures physiques | FIND/READ/NEW/UPDATE/DELETE pour BUILDING, FLOOR, BEDROOM, BED, LOCALIZATION |

## Source

- **GitLab Pages** : `https://erp-pas.gitlab-pages-erp-pas.dedalus.lan/hexagone/swdoc/`
- **Dépôt GitLab** : `https://gitlab-erp-pas.dedalus.lan/erp-pas/hexagone/swdoc`
- **Format** : fichiers Markdown publiés en site statique
- **Maintenance** : équipe Hexagone, Dedalus ERP-PAS

## Skills complémentaires

| Skill | Relation |
|-------|----------|
| [hpk-parser](hpk-parser.md) | Parsing des messages HPK échangés via les web services |
| [hl7-pam-parser](hl7-pam-parser.md) | Parsing des messages HL7 PAM d'administration des patients |
| [hexagone-frontend](hexagone-frontend.md) | Documentation des composants frontend Hexagone (@his/hexa-components) |
| [backend-patterns](backend-patterns.md) | Patterns d'architecture pour implémenter des clients de web services |
| [uniface-procscript](uniface-procscript.md) | Référence ProcScript pour le code Uniface appelant les web services |
