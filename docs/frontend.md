# frontend

Garantit un développement frontend qui respecte nativement le framework et le design system du projet. Pas de surcharges, pas de contournements : utiliser la bibliothèque de composants comme prévu, Tailwind CSS selon les bonnes pratiques, et le système de thème du framework pour toute personnalisation.

## Quand utiliser ce skill

Utilisez ce skill pour :
- Tout changement sur des pages ou composants frontend
- S'assurer que PrimeVue, MUI, Vuetify ou toute autre bibliothèque est utilisée nativement
- Appliquer les bonnes pratiques Tailwind CSS systématiquement
- Empêcher les surcharges de style (`pt`, `!important`, CSS sur les classes internes)
- Maintenir la cohérence du design system dans le temps

## Principe fondamental

> **Ne pas combattre le framework. L'utiliser tel qu'il a été conçu.**

Chaque framework frontend et bibliothèque de composants a une manière prévue d'être utilisé. Ce skill garantit que chaque ligne de code frontend respecte cette intention.

## Démarrage rapide

```bash
npx skills add Dedalus-ERP-PAS/foundation-skills --skill frontend -g -y
```

## Fonctionnement

### Phase 1 : Détection du contexte (automatique)

Le skill scanne le codebase avant tout changement :
- **Framework** — React, Vue, Angular, Svelte, Next, Nuxt...
- **Bibliothèque de composants** — PrimeVue, shadcn/ui, MUI, Vuetify...
- **Framework CSS** — Tailwind, SCSS, CSS Modules...
- **Configuration du thème** — presets, design tokens, variables CSS

### Phase 2 : Application des règles

Le skill applique des règles strictes selon le contexte détecté.

## Règles de la bibliothèque de composants

### TOUJOURS
- Utiliser les composants de la librairie directement avec leurs props documentées
- Personnaliser l'apparence via le **système de thème** (design tokens, presets)
- Utiliser les variants intégrés (`severity`, `size`, `outlined`, `rounded`, etc.)
- Utiliser les slots pour personnaliser le contenu

### JAMAIS
- Surcharger les internals avec du CSS ciblant les classes internes
- Créer des wrappers qui re-stylisent les composants de la librairie
- Utiliser `!important` pour surcharger les styles de la librairie
- Dupliquer des fonctionnalités qui existent déjà dans la librairie

## Règles PrimeVue spécifiques

| Interdit                                         | Raison                                 | Alternative                           |
| ------------------------------------------------ | -------------------------------------- | ------------------------------------- |
| API PassThrough (`pt`)                           | Contourne le système de thème          | `definePreset()` avec design tokens   |
| Mode `unstyled`                                  | Reconstruit PrimeVue from scratch      | Utiliser un preset (Aura, Lara, Nora) |
| Wrappers avec surcharges `pt`                    | Abstraction inutile, casse aux updates | Utiliser les composants directement   |
| CSS sur `.p-button-label`, `.p-datatable-header` | Fragile, casse aux updates             | Personnaliser via design tokens       |
| Classes Tailwind sur composants PrimeVue         | Deux systèmes en conflit               | Laisser PrimeVue gérer ses composants |

## Règles Tailwind CSS

### Checklist appliquée à chaque changement frontend

- Mobile-first : styles de base pour mobile, breakpoints pour le reste
- Pas de valeurs arbitraires si un token Tailwind existe
- Pas de `@apply` excessif — préférer les composants Vue
- Pas de concaténation de classes (`bg-${color}-500`)
- Ordre de classes cohérent (plugin Prettier)
- Dark mode avec `dark:` utilisé systématiquement
- Focus styles visibles pour l'accessibilité
- Design tokens du `tailwind.config` utilisés, pas de valeurs hardcodées

### Coexistence Tailwind + PrimeVue

| Responsabilité                              | Propriétaire |
| ------------------------------------------- | ------------ |
| Layout de page, espacement entre composants | **Tailwind** |
| Éléments custom (non-librairie)             | **Tailwind** |
| Apparence des composants, variants, états   | **PrimeVue** |
| Espacement interne des composants           | **PrimeVue** |

## Exemples d'utilisation

```
# S'assurer que le code respecte le framework
@workspace avec frontend, ajoute une page de liste d'utilisateurs

# Revue d'un composant existant
@workspace avec frontend, vérifie que ce composant respecte les bonnes pratiques

# Intégration d'un nouveau formulaire
@workspace avec frontend, crée un formulaire d'inscription patient
```

## Skills complémentaires

- **vue-best-practices** / **react-best-practices** — Patrons spécifiques au framework
- **create-design-system-rules** — Pour les projets sans design system établi
- **web-design-guidelines** — Pour auditer l'accessibilité et la qualité UI
- **react-best-practices** / **vue-best-practices** — Patterns de code pour les frameworks
- **web-design-guidelines** — Audit et revue d'interfaces existantes

## Ressources

- [Skill source](https://github.com/Dedalus-ERP-PAS/foundation-skills/tree/main/skills/frontend)
- [SKILL.md complet](../skills/frontend/SKILL.md) — Guide détaillé avec standards d'implémentation
