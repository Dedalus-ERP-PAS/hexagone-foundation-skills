# Guide des parsers healthcare

Guide pour utiliser les skills **hpk-parser** et **hl7-pam-parser** afin de parser les messages de santé.

## Vue d'ensemble

Ces deux skills parsent et expliquent les messages utilisés dans les SIH (Systèmes d'Information Hospitaliers) français :

- **hpk-parser** : format propriétaire HPK (Healthcare Protocol Kernel), délimiteur pipe (`|`)
- **hl7-pam-parser** : standard international HL7 v2.5 IHE PAM (Patient Administration Management)

### Quel skill utiliser ?

| Situation | Skill |
|-----------|-------|
| Message avec délimiteurs `|` et champs fixes | `hpk-parser` |
| Message commençant par `MSH|^~\&` | `hl7-pam-parser` |
| Format propriétaire français (HPK/GEF) | `hpk-parser` |
| Standard HL7 v2.5 international | `hl7-pam-parser` |
| Message inconnu | Les deux (l'agent choisira) |

## HPK Parser

### Types de messages supportés

#### Identité (ID|*)

| Code | Description |
|------|-------------|
| **ID\|M1** | Identité patient (démographie) |
| **ID\|MT** | Médecin traitant |
| **ID\|CE** | Consentement éclairé |

#### Mouvements (MV|*)

| Code | Description |
|------|-------------|
| **MV\|M2** | Admission hospitalière |
| **MV\|M3** | Changement de statut |
| **MV\|M6** | Transfert inter-unités |
| **MV\|M8** | Sortie d'unité |
| **MV\|M9** | Sortie d'hospitalisation |
| **MV\|B1** | Mouvement box urgences |
| **MV\|MT** | Mouvement temporaire |

#### Couverture (CV|*)

| Code | Description |
|------|-------------|
| **CV\|M1** | Couverture sociale/mutuelle |

### Exemple : parser un message patient

```
Prompt : "Parse ce message HPK :
ID|M1|C|HEXAGONE|20260122120000|USER001|PAT12345|DUPONT|JEAN|19750315|M|..."
```

Le skill retourne le type de message, les champs extraits et le contexte métier.

## HL7 PAM Parser

### Types de messages supportés (ADT)

| Code | Description |
|------|-------------|
| **ADT^A01** | Admission |
| **ADT^A02** | Transfert patient |
| **ADT^A03** | Sortie d'hospitalisation |
| **ADT^A04** | Pré-admission |
| **ADT^A08** | Mise à jour démographie |
| **ADT^A11** | Annulation admission |
| **ADT^A12** | Annulation transfert |
| **ADT^A13** | Annulation sortie |

### Exemple : parser une admission HL7

```
Prompt : "Parse ce message HL7 d'admission :
MSH|^~\&|HEXAFLUX|CHU_PARIS|TARGET|DEST|20260122140000||ADT^A01^ADT_A01|MSG001|P|2.5
EVN|A01|20260122140000|||USER001
PID|1||PAT12345^^^CHU_PARIS^PI||DUPONT^JEAN||19750315|M
PV1|1|I|CHU_PARIS^CARDIO^LIT_001||||PR_MARTIN^MARTIN^SOPHIE"
```

Le skill retourne les segments MSH, EVN, PID, PV1 détaillés et la conformité IHE PAM 2.10.

## Cas d'usage courants

### Comprendre un message inconnu

```
J'ai reçu ce message, peux-tu m'expliquer ce que c'est ?
ID|M1|C|HEXAGONE|20260122120000|...
```

L'agent identifie automatiquement le format et utilise le bon skill.

### Déboguer un problème d'intégration

```
Notre interface reçoit ce message HL7 mais l'admission échoue.
Peux-tu identifier le problème ?
MSH|^~\&|APP|FAC|...
```

L'agent parse, valide contre IHE PAM 2.10, et suggère les corrections.

### Transformation HPK vers HL7

```
J'ai ce message HPK d'admission :
MV|M2|C|HEXAGONE|20260122140000|USER001|PAT12345|VIS001|...

Génère le message HL7 IHE PAM équivalent (ADT^A01)
```

L'agent mappe les champs HPK vers les segments HL7.

## Bonnes pratiques

- **Spécifier le skill** : "Utilise hpk-parser pour ce message HPK"
- **Fournir le message complet** : ne pas tronquer les champs
- **Demander la validation** : "Parse et valide contre IHE PAM 2.10"
- **Documenter le contexte** : préciser le système source et l'objectif

## Dépannage

| Problème | Solution |
|----------|----------|
| Message non reconnu | Spécifier le skill explicitement dans le prompt |
| Parsing incomplet | Demander une analyse champ par champ |
| Validation échouée à tort | Demander les références IHE PAM 2.10 exactes |
| Dates incorrectes | HPK : `YYYYMMDDHHmmss` (14 car.), HL7 : `YYYYMMDDHHmmss` ou `YYYYMMDD` |
| Délimiteurs mal interprétés | HPK : `|` uniquement. HL7 : `|` (champs), `^` (composants), `~` (répétitions) |

## Références

- [hpk-parser](hpk-parser.md) -- Documentation du skill HPK
- [hl7-pam-parser](hl7-pam-parser.md) -- Documentation du skill HL7 PAM
- [IHE PAM 2.10](https://github.com/Interop-Sante/ihe.iti.pam.fr) -- Spécification officielle
- [HL7 v2.5](http://www.hl7.eu/HL7v2x/v25/std25/ch02.html) -- Standard HL7
