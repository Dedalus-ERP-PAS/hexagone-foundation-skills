# hpk-parser

Parsing et explication des messages HPK (Healthcare Protocol Kernel). Format propriétaire pipe-delimited utilisé dans les SIH français (Hexagone).

## Quand utiliser ce skill

- Comprendre le contenu d'un message HPK
- Déboguer des problèmes de données ou d'intégration
- Valider la structure et les champs d'un message
- Documenter des exemples de messages HPK

## Ce que fait le skill

- **Parse** les messages HPK et identifie le type
- **Extrait** tous les champs avec leurs libellés
- **Valide** la structure et les formats attendus
- **Explique** le message en langage compréhensible
- **Documente** les correspondances HPK vers HL7

## Types de messages supportés

### Identité (ID|*)

| Code | Description |
|------|-------------|
| **ID\|M1** | Données démographiques patient |
| **ID\|MT** | Affectation du médecin traitant |
| **ID\|CE** | Consentement éclairé |

### Mouvements (MV|*)

| Code | Description |
|------|-------------|
| **MV\|M2** | Admission hospitalière |
| **MV\|M3** | Changement de statut |
| **MV\|M6** | Transfert d'unité/service |
| **MV\|M8** | Sortie d'unité |
| **MV\|M9** | Sortie d'hospitalisation |
| **MV\|B1** | Mouvement box d'urgence |
| **MV\|MT** | Mouvement temporaire (examen, acte) |

### Couverture (CV|*)

| Code | Description |
|------|-------------|
| **CV\|M1** | Couverture assurance |

### Autres types

Approvisionnement (PR, FO, MA, CO, LI, RO, FA), inventaire (SO, IM), structure (ST, UT), finances (RD, DD).

## Exemple d'utilisation

**Message en entrée** :
```
ID|M1|C|HEXAGONE|20260122120000|USER001|PAT12345|DUPONT|JEAN|19750315|M|15 RUE DE LA PAIX|75001|PARIS|FRA|0612345678||||||||||||||||||||||||||||||
```

**Résultat** :
```
Type : Identité Patient (Données démographiques)
Opération : Création (nouvel enregistrement)
Patient : JEAN DUPONT, né le 15/03/1975, Masculin
Contact : 06 12 34 56 78
Adresse : 15 RUE DE LA PAIX, 75001 PARIS, France
```

## Structure d'un message HPK

Tous les messages HPK suivent cette structure de base :

```
Type|Message|Mode|Émetteur|Date|User|[champs supplémentaires...]
```

| Champ | Description | Valeurs possibles |
|-------|-------------|-------------------|
| **Type** | Catégorie de message | ID, MV, CV, PR, FO, MA, CO, LI, RO, FA, SO, IM, ST, UT, RD, DD |
| **Message** | Code du message | M1, M2, M6, M9, MT, CE, B1, etc. |
| **Mode** | Type d'opération | C (Création), M (Modification), D (Suppression) |
| **Émetteur** | Système source | Nom de l'application émettrice |
| **Date** | Horodatage | Format `YYYYMMDDHHmmss` |
| **User** | Identifiant utilisateur | ID de l'opérateur |

## Correspondances HPK vers HL7

Le format HPK est souvent mappé vers **HL7 v2.5** / **IHE PAM 2.10** :

| HPK | HL7 | Description |
|-----|-----|-------------|
| MV\|M2 | ADT^A01 | Admission |
| MV\|M6 | ADT^A02 | Transfert |
| MV\|M9 | ADT^A03 | Sortie |
| ID\|M1 | ADT^A08 | Mise à jour identité |

## Références

- [Spécification HPK ADT](./hpk-adt-message.md)
- [Guide des parsers healthcare](./healthcare-parsers-guide.md)
- [SKILL.md](../skills/hpk-parser/SKILL.md) -- structures détaillées des champs

## Skills connexes

- **hl7-pam-parser** -- messages HL7 v2.5 IHE PAM (standard international)
- **hexagone-frontend** -- composants frontend Hexagone
- **hexagone-swdoc** -- web services Hexagone
