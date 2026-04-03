# Design Compliance

Audit automatique de conformit au design system Hexagone pour les micro-frontends Vue.js 3.

## Description

Ce skill analyse le code source et l'interface rendue d'une page ou d'un composant de l'application Hexagone Web, d detecte les violations du design system (PrimeVue 4, Tailwind CSS 4, tokens Hexagone), corrige automatiquement toutes les violations et produit un rapport structur.

## Utilisation

```bash
# Par URL
/design-compliance http://localhost:5173/hexagone-etab/vue/patients

# Par nom de composant
/design-compliance PatientDashboard

# Par nom de page (route)
/design-compliance Patients

# Sans argument (demande quoi analyser)
/design-compliance
```

## Standard unique enforc

| Rgle | Valeur |
|-------|---------|
| Script | Composition API `<script setup lang="ts">` |
| CSS | Tailwind CSS 4 |
| State | Pinia |
| Composants UI | PrimeVue 4 natif (pas de hexa-compat) |
| Tokens visuels | `dt` (jamais `pt` pour le style visuel) |
| Textes | i18n obligatoire (`t('key')`) |

## Catgories de violations dtectes

1. **Mauvais composant** -- HTML brut ou hexa-compat au lieu de PrimeVue natif
2. **Mauvaise couche de tokens** -- couleurs en dur, classes beta-scss, tokens `--hexa-*` hors shell
3. **Mauvais usage de `pt`** -- styling visuel via `pt` au lieu de `dt`
4. **Imports incorrects** -- imports PrimeVue en majuscules ou noms v3
5. **Violations dark mode** -- `:global(.p-dark)` dans `<style scoped>`, absence de support dark
6. **Violations i18n** -- textes en dur dans les templates
7. **Accessibilit** -- labels manquants, interactions hover-only, menus contextuels
8. **Conventions framework** -- Options API, Vuex, styles inline

## Fonctionnement

1. **Dcouverte des rgles** -- lecture de `CLAUDE.md`, `design-rules.md`, `hexagone-preset.js`
2. **Rsolution des fichiers** -- glob ou recherche dans le routeur, puis parcours rcursif de l'arbre de composants
3. **Analyse statique du code** -- vrification des 8 catgories de violations
4. **Inspection visuelle** -- si un serveur de dev tourne : screenshot light + dark mode, analyse des styles calculs
5. **Correction automatique** -- toutes les violations sont corriges dans les fichiers (sans commit)
6. **Rapport terminal** -- tableau structur par fichier et par catgorie

## Inspection visuelle

L'inspection visuelle est effectue uniquement si un serveur de dveloppement est dtect (ports 5173, 5174, 3000, 8080). Elle inclut :

- Capture d'cran en mode clair
- Bascule en dark mode (`.p-dark`)
- Capture d'cran en mode sombre
- Analyse des styles calculs vs tokens attendus
- Dtection d'incohrence visuelles (espacement, alignement, dbordements)

Authentification automatique avec `apvhn`/`apvhn` si ncessaire.

## Comportement

- **Autonome** -- aucune question pendant l'excution (sauf si pas d'argument fourni)
- **Correctif** -- toutes les violations sont corriges automatiquement dans les fichiers
- **Pas de commit** -- les modifications restent unstaged pour revue par le dveloppeur
- **Rapport terminal** -- le rapport est affich dans la conversation uniquement

## Remplace

Ce skill remplace les skills suivants :
- `frontend` -- rgles de dveloppement frontend natif
- `create-design-system-rules` -- gnration de rgles de design system
- `web-design-guidelines` -- audit UI/UX gnrique
