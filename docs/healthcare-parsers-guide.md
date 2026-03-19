# Guide des parsers healthcare

Guide pour utiliser les skills **hpk-parser** et **hl7-pam-parser** afin de parser les messages de sante.

## Vue d'ensemble

Ces deux skills parsent et expliquent les messages utilises dans les SIH (Systemes d'Information Hospitaliers) francais :

- **hpk-parser** : format proprietaire HPK (Healthcare Protocol Kernel), delimiteur pipe (`|`)
- **hl7-pam-parser** : standard international HL7 v2.5 IHE PAM (Patient Administration Management)

### Quel skill utiliser ?

| Situation | Skill |
|-----------|-------|
| Message avec delimiteurs `|` et champs fixes | `hpk-parser` |
| Message commencant par `MSH|^~\&` | `hl7-pam-parser` |
| Format proprietaire francais (HPK/GEF) | `hpk-parser` |
| Standard HL7 v2.5 international | `hl7-pam-parser` |
| Message inconnu | Les deux (l'agent choisira) |

## HPK Parser

### Types de messages supportes

#### Identite (ID|*)

| Code | Description |
|------|-------------|
| **ID\|M1** | Identite patient (demographie) |
| **ID\|MT** | Medecin traitant |
| **ID\|CE** | Consentement eclaire |

#### Mouvements (MV|*)

| Code | Description |
|------|-------------|
| **MV\|M2** | Admission hospitaliere |
| **MV\|M3** | Changement de statut |
| **MV\|M6** | Transfert inter-unites |
| **MV\|M8** | Sortie d'unite |
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

Le skill retourne le type de message, les champs extraits et le contexte metier.

## HL7 PAM Parser

### Types de messages supportes (ADT)

| Code | Description |
|------|-------------|
| **ADT^A01** | Admission |
| **ADT^A02** | Transfert patient |
| **ADT^A03** | Sortie d'hospitalisation |
| **ADT^A04** | Pre-admission |
| **ADT^A08** | Mise a jour demographie |
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

Le skill retourne les segments MSH, EVN, PID, PV1 detailles et la conformite IHE PAM 2.10.

## Cas d'usage courants

### Comprendre un message inconnu

```
J'ai recu ce message, peux-tu m'expliquer ce que c'est ?
ID|M1|C|HEXAGONE|20260122120000|...
```

L'agent identifie automatiquement le format et utilise le bon skill.

### Deboguer un probleme d'integration

```
Notre interface recoit ce message HL7 mais l'admission echoue.
Peux-tu identifier le probleme ?
MSH|^~\&|APP|FAC|...
```

L'agent parse, valide contre IHE PAM 2.10, et suggere les corrections.

### Transformation HPK vers HL7

```
J'ai ce message HPK d'admission :
MV|M2|C|HEXAGONE|20260122140000|USER001|PAT12345|VIS001|...

Genere le message HL7 IHE PAM equivalent (ADT^A01)
```

L'agent mappe les champs HPK vers les segments HL7.

## Bonnes pratiques

- **Specifier le skill** : "Utilise hpk-parser pour ce message HPK"
- **Fournir le message complet** : ne pas tronquer les champs
- **Demander la validation** : "Parse et valide contre IHE PAM 2.10"
- **Documenter le contexte** : preciser le systeme source et l'objectif

## Depannage

| Probleme | Solution |
|----------|----------|
| Message non reconnu | Specifier le skill explicitement dans le prompt |
| Parsing incomplet | Demander une analyse champ par champ |
| Validation echouee a tort | Demander les references IHE PAM 2.10 exactes |
| Dates incorrectes | HPK : `YYYYMMDDHHmmss` (14 car.), HL7 : `YYYYMMDDHHmmss` ou `YYYYMMDD` |
| Delimiteurs mal interpretes | HPK : `|` uniquement. HL7 : `|` (champs), `^` (composants), `~` (repetitions) |

## References

- [hpk-parser](hpk-parser.md) -- Documentation du skill HPK
- [hl7-pam-parser](hl7-pam-parser.md) -- Documentation du skill HL7 PAM
- [IHE PAM 2.10](https://github.com/Interop-Sante/ihe.iti.pam.fr) -- Specification officielle
- [HL7 v2.5](http://www.hl7.eu/HL7v2x/v25/std25/ch02.html) -- Standard HL7
