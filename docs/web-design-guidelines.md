# web-design-guidelines

Inspection visuelle et revue de code pour la conformité aux Web Interface Guidelines. Supporte l'analyse statique et l'inspection via navigateur avec correction automatique.

## Quand utiliser ce skill

Utilisez ce skill pour :
- Auditer l'accessibilité et l'UX d'une interface web
- Détecter les problèmes de layout, responsive et cohérence visuelle
- Corriger automatiquement les non-conformités identifiées
- Valider la conformité WCAG (Web Content Accessibility Guidelines)

## Démarrage rapide

```bash
npx skills add Dedalus-ERP-PAS/foundation-skills --skill web-design-guidelines -g -y
```

## Utilisation

### Analyse statique (code uniquement)

```
Revois mon UI dans src/components/
Vérifie l'accessibilité de ma page
Analyse l'UX de mon formulaire d'inscription
```

### Inspection visuelle (navigateur)

```
Revois le design à http://localhost:3000
Vérifie l'UI sur http://localhost:5173/dashboard
Trouve les problèmes de layout sur mon site
```

### Revue complète (recommandé)

```
Revois mon UI à localhost:3000 et corrige les problèmes dans src/
Audite le design et corrige les problèmes responsive
```

## Ce que le skill vérifie

### Analyse statique
- **Accessibilité** — conformité WCAG (contraste, focus, alt text)
- **Cohérence visuelle** — fonts, couleurs, espacements
- **Patterns UX** standards
- **Performance perçue**
- **Responsive design**

### Inspection visuelle
- Problèmes de layout (overflow, overlap, alignement)
- Rendu responsive (mobile, tablet, desktop, wide)
- Accessibilité (contraste, focus, alt text)
- Cohérence visuelle (fonts, couleurs, espacements)

## Workflow

1. **Collecte d'informations** — Détection framework et méthode CSS
2. **Fetch guidelines** — Récupération des règles Vercel
3. **Analyse statique** — Revue du code source
4. **Inspection visuelle** — Screenshots et DOM (si URL fournie)
5. **Correction** — Fixes automatiques priorisés (P1, P2, P3)
6. **Re-vérification** — Validation des corrections (boucle si nécessaire)

## Prérequis

- **Inspection visuelle** : site web accessible (localhost ou remote)
- **Corrections** : accès au code source dans le workspace

Les guidelines sont récupérées automatiquement depuis le repo officiel Vercel.

## Ressources

- [Skill source](https://github.com/Dedalus-ERP-PAS/foundation-skills/tree/main/skills/web-design-guidelines)
- [SKILL.md complet](../skills/web-design-guidelines/SKILL.md) — Guide détaillé avec toutes les règles
