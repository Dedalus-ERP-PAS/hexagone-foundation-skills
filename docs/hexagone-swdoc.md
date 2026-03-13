# Hexagone Web Services Documentation

## Vue d'ensemble

Le skill Hexagone swdoc donne aux agents IA un acces a la documentation complete des web services Hexagone ("Reference Appels Externes"), publiee en tant que GitLab Pages. Il permet de consulter les specifications des services SOAP, les formats XML (DTDs), les codes d'erreur et les regles metier associees -- sans avoir a cloner le depot.

## Ce qu'il fait

- **Consulte a la demande** la documentation publiee sur GitLab Pages (aucun clone de depot necessaire)
- **Explique** les methodes SOAP, parametres, interfaces et formats de requete/reponse XML
- **Liste** les web services disponibles par domaine (patients, urgences, hospitalisations, sejours, produits, etc.)
- **Aide au debogage** en comparant les appels reels avec les specifications documentees
- **Reference croisee** avec les skills HPK et HL7 PAM pour les aspects interoperabilite

## Quand l'utiliser

Utilisez ce skill quand vous avez besoin de :

- Connaitre les methodes et parametres d'un web service Hexagone (EWPT0001 a EWPT0014)
- Comprendre le format XML (DTD) de requete ou de reponse d'une methode SOAP
- Lister les web services disponibles pour un domaine fonctionnel
- Deboguer une integration avec un web service Hexagone (codes retour, statuts)
- Comprendre les regles metier associees a un service
- Verifier la configuration requise par application (CODEGEST, PSACC, etc.)

## Prerequis

- Acces au reseau interne Dedalus (pour atteindre les GitLab Pages)

## Demarrage rapide

```bash
npx skills add Dedalus-ERP-PAS/foundation-skills --skill hexagone-swdoc -g -y
```

## Fonctionnement

Le skill utilise **WebFetch** pour consulter directement les pages de documentation publiees sur GitLab Pages :

1. **Identification du service** : a partir de la question de l'utilisateur, le skill identifie le service EWPT concerne grace a un catalogue integre de tous les services et methodes.

2. **Recuperation de la page** : il appelle WebFetch sur l'URL de la page du service concerne (ex: `https://erp-pas.gitlab-pages-erp-pas.dedalus.lan/hexagone/swdoc/01-ewpt0001-gestion-des-patients/`).

3. **Extraction et presentation** : il extrait la section pertinente (methode, DTD, codes d'erreur) et la presente de maniere structuree.

## Services disponibles

| Service | Domaine | Methodes principales |
|---------|---------|---------------------|
| EWPT0001 | Gestion des patients | READ/FIND/NEW/UPDATE_PATIENT, READ_COVERAGES, READ_KINS, etc. |
| EWPT0002 | Gestion des urgences | READ/NEW/UPDATE/DELETE_EMERGENCY, TO_OUTPATIENT, TO_INPATIENT |
| EWPT0003 | Consultations externes | NEW/READ/UPDATE/DELETE_OUTPATIENT |
| EWPT0004 | Dossiers d'hospitalisation | READ/NEW/UPDATE/DELETE_INPATIENT, READ/NEW/UPDATE/DELETE_MOVEMENT |
| EWPT0005 | Lecture des occupations | UF_OCC, AVAILABLE_BEDS, IN_HOSPITAL, etc. |
| EWPT0007 | Gestion des sejours | PATIENT_CASES, CASE_MVTS, CHG_CASE_TYPE, etc. |
| EWPT0008 | Produits | PRODUCT_CREATION, PRODUCT_VERIFICATION, GET_*, etc. |
| EWPT0009 | Gestion du DMP | NEW/UPDATE_REJECTION, ACCESS_CODE, INFO_VITALE, etc. |
| EWPT0010 | Gestion des praticiens | FIND/NEW/UPDATE_PRACT |
| EWPT0012 | Integration d'actes | INTEGR_CCAM |
| EWPT0013 | Re-generation Identites/mouvements | REGEN_IDMVT |
| EWPT0014 | Structures physiques | FIND/READ/NEW/UPDATE/DELETE pour BUILDING, FLOOR, BEDROOM, BED, LOCALIZATION |

## Source

- **GitLab Pages** : `https://erp-pas.gitlab-pages-erp-pas.dedalus.lan/hexagone/swdoc/`
- **Depot GitLab** : `https://gitlab-erp-pas.dedalus.lan/erp-pas/hexagone/swdoc`
- **Format** : fichiers Markdown publies en site statique
- **Maintenance** : equipe Hexagone, Dedalus ERP-PAS

## Skills complémentaires

| Skill | Relation |
|-------|----------|
| [hpk-parser](hpk-parser.md) | Parsing des messages HPK échangés via les web services |
| [hl7-pam-parser](hl7-pam-parser.md) | Parsing des messages HL7 PAM d'administration des patients |
| [hexagone-frontend](hexagone-frontend.md) | Documentation des composants frontend Hexagone (@his/hexa-components) |
| [backend-patterns](backend-patterns.md) | Patterns d'architecture pour implémenter des clients de web services |
| [uniface-procscript](uniface-procscript.md) | Référence ProcScript pour le code Uniface appelant les web services |
