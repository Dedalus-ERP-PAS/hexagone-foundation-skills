# create-design-system-rules

Génère des règles de design system personnalisées pour les workflows Figma-to-code.

## Quand utiliser ce skill

Utilisez ce skill pour :
- Générer des règles de design system adaptées à votre projet
- Configurer l'intégration entre Figma et votre codebase
- Standardiser les composants, tokens et conventions de styling

## Démarrage rapide

```bash
npx skills add Dedalus-ERP-PAS/foundation-skills --skill create-design-system-rules -g -y
```

## Prérequis

Serveur MCP (Model Context Protocol) Figma connecté. Ce protocole permet la communication entre l'agent IA et Figma.

## Utilisation

```
Crée des règles de design system pour mon projet React
Configure les règles Figma pour mon application Vue
Génère les guidelines de design system pour notre monorepo
```

## Workflow

1. **Exécution** — Appel de l'outil `create_design_system_rules` via le serveur MCP Figma
2. **Analyse** — Scan de la codebase (composants, styling, tokens)
3. **Génération** — Création des règles personnalisées
4. **Sauvegarde** — Écriture dans `CLAUDE.md` à la racine du projet
5. **Validation** — Itération et ajustement si nécessaire

## Ce que le skill génère

- Règles d'organisation des composants
- Règles de styling et tokens
- Règles d'intégration Figma via MCP
- Règles de gestion des assets
- Conventions spécifiques au projet

## Ressources

- [Skill source](https://github.com/Dedalus-ERP-PAS/foundation-skills/tree/main/skills/create-design-system-rules)
- [SKILL.md complet](../skills/create-design-system-rules/SKILL.md) — Guide détaillé avec toutes les règles
