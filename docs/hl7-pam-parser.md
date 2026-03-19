# hl7-pam-parser

Parsing et explication des messages HL7 v2.5 IHE PAM (Patient Administration Management). Standard d'interoperabilite pour l'administration des patients.

## Quand utiliser ce skill

- Comprendre le contenu d'un message HL7 ADT
- Deboguer des problemes d'interoperabilite HL7
- Valider un message selon IHE PAM 2.10
- Documenter des exemples de messages HL7

## Ce que fait le skill

- **Parse** les messages HL7 ADT et identifie le type
- **Extrait** les segments (MSH, EVN, PID, PV1, PV2) avec libelles
- **Valide** la structure selon IHE PAM 2.10
- **Explique** le message en langage comprehensible
- **Documente** les regles metier et la conformite

## Types de messages supportes

### Messages ADT (Admission, Transfert, Sortie)

| Code | Description |
|------|-------------|
| **ADT^A01** | Admission (entree du patient) |
| **ADT^A02** | Transfert (changement d'unite/chambre) |
| **ADT^A03** | Sortie d'hospitalisation |
| **ADT^A04** | Pre-admission / ambulatoire |
| **ADT^A05** | Pre-admission d'un patient |
| **ADT^A06** | Passage ambulatoire vers hospitalisation |
| **ADT^A07** | Passage hospitalisation vers ambulatoire |
| **ADT^A08** | Mise a jour des informations patient |
| **ADT^A11** | Annulation d'admission |
| **ADT^A12** | Annulation de transfert |
| **ADT^A13** | Annulation de sortie |
| **ADT^A21** | Permission de sortie (absence temporaire) |
| **ADT^A22** | Retour de permission de sortie |

## Exemple d'utilisation

**Message en entree** :
```
MSH|^~\&|HEXAFLUX|CHU_PARIS|TARGET|DEST|20260122140000||ADT^A01^ADT_A01|MSG001|P|2.5
EVN|A01|20260122140000|||USER001
PID|1||PAT12345^^^CHU_PARIS^PI||DUPONT^JEAN^^M.||19750315|M|||15 RUE DE LA PAIX^^PARIS^^75001^FRA||(33)612345678
PV1|1|I|CHU_PARIS^CARDIO^LIT_001^CHU_PARIS||||PR_MARTIN^MARTIN^SOPHIE|||CARDIO||||||||||VIS20260122001|||||||||||||||||||||||||20260122140000
```

**Resultat** :
```
Type : ADT^A01 (Notification d'admission)
Evenement : A01 -- Admission en hospitalisation
Patient : JEAN DUPONT, ne le 15/03/1975, Masculin (ID : PAT12345)
Sejour : VIS20260122001
Admission : 22/01/2026 14:00:00
Localisation : CHU_PARIS, Cardiologie, Lit LIT_001
Medecin : Dr. MARTIN SOPHIE
Classe patient : Hospitalise
```

## Structure d'un message HL7

Delimiteurs HL7 v2.5 :

| Caractere | Role |
|-----------|------|
| `\|` | Separateur de champs |
| `^` | Separateur de composants |
| `~` | Separateur de repetitions |
| `\` | Caractere d'echappement |
| `&` | Separateur de sous-composants |

## Segments principaux

| Segment | Role | Obligatoire |
|---------|------|-------------|
| **MSH** | En-tete du message (routage, metadonnees) | Oui |
| **EVN** | Type d'evenement (code, horodatage) | Oui |
| **PID** | Identification patient (identite, demographie) | Oui |
| **PV1** | Visite patient (classe, localisation, medecin) | Oui |
| **PV2** | Informations complementaires de visite | Non |

## Conformite IHE PAM 2.10

Le parser valide les champs obligatoires :

- **MSH** : application emettrice, etablissement, date, type, ID controle, version
- **EVN** : code evenement, date d'enregistrement
- **PID** : ID patient, nom, date de naissance, sexe
- **PV1** : classe patient, localisation, numero de sejour

## References

- [Specification IHE PAM 2.10](https://github.com/Interop-Sante/ihe.iti.pam.fr) (francais)
- [Profil IHE PAM](https://profiles.ihe.net/ITI/TF/Volume1/ch-14.html) (international)
- [Standard HL7 v2.5](http://www.hl7.eu/HL7v2x/v25/std25/ch02.html)
- [SKILL.md](../skills/hl7-pam-parser/SKILL.md) -- structures detaillees des segments

## Skills connexes

- **hpk-parser** -- messages HPK (format proprietaire francais mappe vers HL7)
- **hexagone-swdoc** -- web services Hexagone
