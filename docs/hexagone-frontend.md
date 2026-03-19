# Hexagone Frontend Documentation

## Vue d'ensemble

Le skill **hexagone-frontend** donne aux agents IA un accès à la documentation de la bibliothèque `@his/hexa-components` utilisée dans les applications web Hexagone. Il couvre les composants Vue.js, les patterns d'utilisation, les classes CSS utilitaires et les modules du store Vuex -- sans cloner le dépôt.

## Ce qu'il fait

- **Consulte à la demande** la documentation optimisée LLM (Large Language Model) depuis le dépôt GitLab (`docs/llm/`)
- **Explique** les composants Hexagone : props, events, slots et exemples
- **Liste** les 36 composants par catégorie (formulaires, navigation, affichage, feedback)
- **Documente** les patterns (API, Store Vuex) et références (directives, événements, validation)
- **Rappelle** les conventions critiques (balises custom, beta-scss, vuex-pathify)

## Quand l'utiliser

Utilisez ce skill quand vous avez besoin de :

- Connaître les props et events d'un composant Hexagone (`<btn>`, `<multiselect>`, `<data-table>`, etc.)
- Construire un formulaire Hexagone avec les bons composants
- Utiliser les classes CSS utilitaires beta-scss (`flex:6/12`, `p:1`, `m:1`, etc.)
- Accéder aux modules du store Vuex partagé (user, session, environment, etc.)
- Appeler des web services avec `Api()` ou `StandardApi()`
- Utiliser les directives custom (`v-focus`, `v-uppercase`)
- Appliquer les règles de validation de formulaires

## Prérequis

- Accès au réseau interne Dedalus (pour atteindre le dépôt GitLab)

## Démarrage rapide

```bash
npx skills add Dedalus-ERP-PAS/foundation-skills --skill hexagone-frontend -g -y
```

## Fonctionnement

Le skill utilise **WebFetch** pour consulter les fichiers Markdown directement depuis le dépôt GitLab :

1. **Identification du composant/pattern** : à partir de la question, le skill identifie le fichier concerné grâce à un catalogue intégré.

2. **Récupération du fichier** : appel WebFetch sur l'URL brute du fichier dans le dépôt GitLab.

3. **Extraction et présentation** : extraction des props, events et exemples pertinents, puis présentation structurée.

## Composants disponibles

### Formulaires et saisie (16 composants)

| Composant | Balise | Description |
|-----------|--------|-------------|
| Input | `<input>` + wrapper | Champ de texte |
| Textarea | `<textarea>` + wrapper | Zone de texte multiligne |
| Number | `<number>` | Champ numérique |
| Currency | `<currency>` | Champ monétaire |
| Select | `<multiselect>` | Sélecteur simple ou multiple |
| Autocomplete | `<autocomplete>` | Champ avec autocomplétion |
| Checkbox | `<checkbox>` | Case à cocher |
| Radio | `<radio>` | Boutons radio |
| ButtonSwitch | `<btn-switch>` | Bouton basculeur on/off |
| Datepicker | `<datepicker>` | Sélecteur de date |
| Timepicker | `<timepicker>` | Sélecteur d'heure |
| Colorpicker | `<colorpicker>` | Sélecteur de couleur |
| File | `<file>` | Upload de fichier |
| Iban | `<iban>` | Champ IBAN |
| Bic | `<bic>` | Champ BIC |
| Radical | `<radical>` | Champ avec préfixe |

### Navigation et actions (8 composants)

| Composant | Balise | Description |
|-----------|--------|-------------|
| Button | `<btn>` | Bouton interactif |
| ButtonGroup | `<btn-group>` | Groupe de boutons |
| FloatingButton | `<floating-btn>` | Bouton flottant avec menu |
| Action | `<action>` | Composant d'action |
| Link | `<link>` | Lien de navigation |
| Bookmark | `<bookmark>` | Signet de page |
| Tabs | `<tabs>` | Système d'onglets |
| Steps | `<steps>` | Étapes de progression |

### Affichage de données (4 composants)

| Composant | Balise | Description |
|-----------|--------|-------------|
| DataTable | `<data-table>` | Tableau avec pagination et tri |
| SimpleTable | `<simple-table>` | Tableau simple avec sélection |
| Card | `<card>` | Conteneur de carte |
| ProgressBar | `<progress-bar>` | Barre de progression |

### Retour utilisateur (7 composants)

| Composant | Balise | Description |
|-----------|--------|-------------|
| Alert | `<alert>` | Alerte avec états |
| Modal | `<modal>` | Fenêtre modale |
| Notification | `$notification()` | Notification programmatique |
| Question | `<question>` | Dialogue de confirmation |
| Tooltips | `<tooltips>` | Info-bulle au survol |
| PostIt | `<post-it>` | Note type post-it |
| Spinner | `<spinner>` | Indicateur de chargement |

## Source

- **Site de documentation** : `https://erp-pas.gitlab-pages-erp-pas.dedalus.lan/hexagone/frontend/hexagone-documentation`
- **Dépôt GitLab** : `https://gitlab-erp-pas.dedalus.lan/erp-pas/hexagone/frontend/hexagone-documentation`
- **Fichiers LLM** : `docs/llm/` dans le dépôt (composants, patterns, références)
- **Maintenance** : équipe Hexagone Frontend, Dedalus ERP-PAS

## Skills complémentaires

| Skill | Relation |
|-------|----------|
| [hexagone-swdoc](hexagone-swdoc.md) | Documentation des web services SOAP pour le backend Hexagone |
| [vue-best-practices](vue-best-practices.md) | Best practices Vue.js générales (le frontend Hexagone utilise Vue.js 2) |
| [hpk-parser](hpk-parser.md) | Parsing des messages HPK échangés via les web services |
| [uniface-procscript](uniface-procscript.md) | Référence ProcScript pour le code Uniface backend |
