# Ubiquitous Language — Glossaire métier DDD

## Description

Le skill **ubiquitous-language** extrait et formalise la terminologie métier à partir d'une conversation. Il suit l'approche du **DDD** (Domain-Driven Design) et produit un glossaire structuré dans un fichier `UBIQUITOUS_LANGUAGE.md`.

Adapté du skill [ubiquitous-language de Damien Battistella](https://github.com/DamienBattistella/skills). Enrichi pour le contexte santé et le bilinguisme français/anglais.

## Cas d'usage

- **Harmonisation du vocabulaire** : établir un langage commun entre développeurs, experts métier et PO
- **Domaine santé** : clarifier les termes HL7, FHIR, HPK, IHE entre standards
- **Détection d'ambiguïtés** : identifier quand un même mot désigne des concepts différents
- **Élimination des synonymes** : choisir un terme canonique et lister les alternatives à éviter
- **Support bilingue** : cartographier les termes français et anglais côte à côte

## Déclenchement

Ce skill s'active quand l'utilisateur :
- Souhaite définir des termes métier ou construire un glossaire
- Mentionne **"ubiquitous language"**, **"langage ubiquitaire"**, **"glossaire"**, **"DDD"** ou **"domain model"**
- Veut durcir la terminologie d'un projet

## Fonctionnement

L'agent va :
1. Scanner la conversation pour identifier noms, verbes et concepts liés au domaine
2. Détecter les problèmes terminologiques :
   - **Ambiguïtés** : un même mot utilisé pour des concepts différents
   - **Synonymes** : des mots différents pour un même concept
   - **Termes vagues** : mots trop génériques ou surchargés
3. Proposer un glossaire canonique avec des choix tranchés
4. Écrire le fichier `UBIQUITOUS_LANGUAGE.md` avec des tables groupées par sous-domaine
5. Afficher un résumé dans la conversation

## Format de sortie

Le fichier `UBIQUITOUS_LANGUAGE.md` contient :
- **Tables groupées** par sous-domaine avec colonnes : Term | Terme français | Definition | Aliases to avoid
- **Relations** entre termes avec cardinalités
- **Dialogue d'exemple** montrant l'usage précis des termes
- **Ambiguïtés signalées** avec recommandations

## Spécificités santé

Ce skill est adapté au contexte santé, où la terminologie varie entre standards :
- Un même concept peut s'appeler différemment en HL7v2, FHIR, HPK ou IHE
- Un malentendu terminologique est coûteux et potentiellement dangereux en milieu clinique
- Le glossaire ancre le vocabulaire de l'équipe sur des définitions partagées

## Support bilingue

- Le terme **canonique** est choisi selon la langue la plus naturelle pour l'équipe
- Une colonne **Terme français** accompagne chaque définition
- Quand un standard impose un terme anglais (ex : "Encounter", "Observation"), celui-ci est préféré comme canonique

## Mise à jour incrémentale

Lorsque le skill est invoqué à nouveau dans la même conversation :
- Les termes existants sont conservés et mis à jour si nécessaire
- Les entrées modifiées sont marquées **(updated)**
- Les nouvelles entrées sont marquées **(new)**
- Les nouvelles ambiguïtés sont signalées
- Le dialogue d'exemple est rafraîchi

## Exemples

**English:**
```text
User: "Let's build a ubiquitous language for our patient management module."

Agent: [Scans conversation, extracts terms, writes UBIQUITOUS_LANGUAGE.md]
- Identifies key terms: Encounter, Admission, Patient, Prescription...
- Flags ambiguities: "séjour" used for both Encounter and Hospitalization
- Groups terms by subdomain: Patient lifecycle, Clinical concepts...
- Writes example dialogue showing precise term usage
```

**Français :**
```text
Utilisateur : "Construisons un glossaire pour notre module de gestion des patients."

Agent: [Scanne la conversation, extrait les termes, écrit UBIQUITOUS_LANGUAGE.md]
- Identifie les termes clés : Encounter, Admission, Patient, Prescription...
- Signale les ambiguïtés : "séjour" utilisé à la fois pour Encounter et Hospitalization
- Groupe les termes par sous-domaine : Cycle de vie patient, Concepts cliniques...
- Écrit un dialogue d'exemple montrant l'usage précis des termes
```

## Installation

```bash
npx skills add Dedalus-ERP-PAS/foundation-skills --skill ubiquitous-language -g -y
```

## Version

1.0.0
