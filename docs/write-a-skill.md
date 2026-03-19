# Write a Skill — Créer un nouveau skill

## Description

Le skill **write-a-skill** guide l'agent IA dans la création d'un nouveau skill pour le dépôt foundation-skills. Il garantit le respect de toutes les conventions : structure de fichiers, frontmatter YAML, versioning et documentation.

Adapté du skill original de [Damien Battistella](https://github.com/DamienBattistella/skills).

## Cas d'usage

- **Création de skill** : scaffolder un nouveau skill complet (SKILL.md + documentation)
- **Respect des conventions** : s'assurer que chaque skill respecte le format du dépôt
- **Onboarding** : aider un nouveau contributeur à créer son premier skill

## Déclenchement

Ce skill s'active quand l'utilisateur :
- Demande à créer un nouveau skill
- Veut ajouter un skill au dépôt
- Utilise les phrases : **"write a skill"** / **"create a skill"** / **"new skill"** / **"scaffold a skill"**

## Fonctionnement

L'agent va :
1. Recueillir les besoins auprès de l'utilisateur (domaine, cas d'usage, déclencheurs)
2. Choisir un nom en kebab-case et vérifier qu'il n'existe pas déjà
3. Créer `skills/<nom>/SKILL.md` avec le frontmatter obligatoire (`name`, `description`, `version`)
4. Créer les fichiers de référence dans `reference/` si le contenu dépasse 100 lignes
5. Créer `docs/<nom>.md` en français
6. Vérifier le respect de toutes les conventions via une checklist de revue

## Conventions appliquées

| Règle | Détail |
|-------|--------|
| **Frontmatter** | `name`, `description`, `version` obligatoires, au niveau racine |
| **Description** | Max 1024 caractères, inclut les déclencheurs ("Use when...") |
| **SKILL.md** | Moins de 100 lignes, en anglais |
| **Documentation** | `docs/<nom>.md`, en français |
| **Version** | Démarre à `1.0.0`, suit les règles semver (patch/minor/major) |
| **Structure** | Un répertoire par skill sous `skills/`, matériaux de référence dans `reference/` |

## Exemples

**English:**
```text
User: "I want to create a new skill for generating changelogs"

Agent: [Activates write-a-skill]
- What specific use cases should this skill handle?
- What triggers should activate it?
- Any reference materials?
-> Creates skills/changelog-generator/SKILL.md
-> Creates docs/changelog-generator.md
-> Runs review checklist
```

**Français :**
```text
Utilisateur : "Je veux créer un nouveau skill pour la revue de code"

Agent : [Active le skill write-a-skill]
- Quels cas d'usage ce skill doit-il couvrir ?
- Quels déclencheurs doivent l'activer ?
- Des matériaux de référence ?
-> Crée skills/code-review/SKILL.md
-> Crée docs/code-review.md
-> Exécute la checklist de revue
```

## Installation

```bash
npx skills add Dedalus-ERP-PAS/foundation-skills --skill write-a-skill -g -y
```

## Version

1.0.0
