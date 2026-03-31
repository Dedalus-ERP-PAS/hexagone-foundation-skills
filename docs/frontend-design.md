# frontend-design

Création d'interfaces web distinctives et professionnelles. Le skill détecte automatiquement le design system et le framework du projet pour s'y conformer en priorité, puis exprime la créativité dans la composition, le layout et le motion. En mode greenfield, il applique une direction esthétique audacieuse.

## Quand utiliser ce skill

Utilisez ce skill pour :
- Créer une landing page, un dashboard ou un composant UI
- Obtenir un design distinctif tout en respectant le design system existant
- Appliquer une direction esthétique spécifique (minimaliste, brutalist, art déco...)
- Générer du code frontend de qualité production
- Créer des interfaces créatives dans un projet Vue + PrimeVue, React + shadcn/ui, ou tout autre stack

## Démarrage rapide

```bash
npx skills add Dedalus-ERP-PAS/foundation-skills --skill frontend-design -g -y
```

## Fonctionnement en 2 phases

### Phase 1 : Détection du contexte (automatique)

Le skill scanne le codebase avant toute décision de design :
- **Framework** — React, Vue, Angular, Svelte, Next, Nuxt...
- **Bibliothèque de composants** — PrimeVue, shadcn/ui, MUI, Vuetify, Ant Design...
- **Framework CSS** — Tailwind, CSS Modules, styled-components, SCSS...
- **Design tokens** — Variables CSS, thème Tailwind, variables SCSS
- **Typographie et palette** — Polices et couleurs déjà définies

### Phase 2 : Design adaptatif (3 niveaux)

| Niveau | Condition | Comportement |
|--------|-----------|-------------|
| **Tier 1 : Greenfield** | Aucun framework, aucun design system | Liberté créative totale — esthétique audacieuse et distinctive |
| **Tier 2 : Framework présent** | Framework détecté, pas de design system complet | Utilise les idiomes du framework, créativité via le theming et la composition |
| **Tier 3 : Design system présent** | Bibliothèque de composants + tokens + patterns établis | Adhérence stricte au système existant ; créativité via composition, motion et micro-interactions |

## Ce que le skill applique automatiquement

### Avec un design system existant (Tier 2 & 3)
- **Respect strict** des tokens, composants et conventions du projet
- **Composition créative** — layouts inattendus avec les composants existants
- **Motion et micro-interactions** — animations de qualité (le levier créatif principal)
- **Hiérarchie de contenu** — contrastes de taille, espacement intentionnel
- **Stratégie d'accents** — utilisation intentionnelle de la palette existante

### Sans design system (Tier 1 — Greenfield)
- **Typographie distinctive** — polices uniques et mémorables
- **Palettes de couleurs audacieuses** — dominant + accents forts
- **Textures et effets visuels** — gradients, noise, overlays
- **Compositions spatiales créatives** — asymétrie, chevauchement, flow diagonal

## Directions esthétiques (Tier 1 uniquement)

| Direction | Style |
|-----------|-------|
| Brutalement minimal | Espace blanc, typographie forte |
| Maximalist chaos | Couleurs vives, superpositions |
| Retro-futuristic | Néons, grilles, cyber-esthétique |
| Luxury / refined | Élégance, matériaux nobles |
| Playful / toy-like | Couleurs pastels, formes arrondies |
| Editorial / magazine | Grilles asymétriques, grands titres |
| Art deco / geometric | Motifs géométriques, dorures |
| Et d'autres... | Le skill adapte la direction à la demande |

## Anti-patterns évités

### Tous les niveaux
- Layouts sans rythme visuel
- Composants identiques empilés sans variation
- Animations sans intention

### Avec un design system (Tier 2 & 3)
- Surcharger les design tokens avec des valeurs en dur
- Importer des polices absentes du projet
- Créer des composants qui dupliquent la bibliothèque existante
- Utiliser une méthodologie CSS différente de celle du projet

### Sans design system (Tier 1)
- Polices génériques (Arial, Inter, Roboto, system fonts)
- Palettes bleu/gris génériques
- Gradients violets sur fond blanc

## Exemples d'utilisation

```
# Projet avec design system existant
@workspace avec frontend-design, crée un dashboard pour le suivi des patients

# Projet greenfield
@workspace avec frontend-design, crée une landing page minimaliste pour [produit]

# Direction esthétique spécifique
@workspace avec frontend-design, design un composant de pricing avec un style luxury
```

## Skills complémentaires

- **create-design-system-rules** — Génère des règles de design system que frontend-design consomme automatiquement
- **react-best-practices** / **vue-best-practices** — Patterns de code pour les frameworks
- **web-design-guidelines** — Audit et revue d'interfaces existantes

## Ressources

- [Skill source](https://github.com/Dedalus-ERP-PAS/foundation-skills/tree/main/skills/frontend-design)
- [SKILL.md complet](../skills/frontend-design/SKILL.md) — Guide détaillé avec standards d'implémentation
