# Hexagone Frontend Documentation

## Vue d'ensemble

Le skill Hexagone frontend donne aux agents IA un acces a la documentation complete de la bibliotheque de composants `@his/hexa-components` utilisee dans les applications web Hexagone. Il permet de consulter les specifications des composants Vue.js, les patterns d'utilisation, les classes CSS utilitaires et les modules du store Vuex -- sans avoir a cloner le depot.

## Ce qu'il fait

- **Consulte a la demande** la documentation LLM-optimisee depuis le depot GitLab (fichiers `docs/llm/`)
- **Explique** les composants Hexagone : props, events, slots et exemples d'utilisation
- **Liste** les 36 composants disponibles par categorie (formulaires, navigation, affichage, feedback)
- **Documente** les patterns (API, Store Vuex) et references (directives, evenements, regles de validation)
- **Rappelle** les conventions critiques (balises custom, beta-scss, vuex-pathify)

## Quand l'utiliser

Utilisez ce skill quand vous avez besoin de :

- Connaitre les props et events d'un composant Hexagone (`<btn>`, `<multiselect>`, `<data-table>`, etc.)
- Construire un formulaire Hexagone avec les bons composants et la bonne structure
- Utiliser les classes CSS utilitaires beta-scss (`flex:6/12`, `p:1`, `m:1`, etc.)
- Acceder aux modules du store Vuex partage (user, session, environment, navigation, establishment)
- Appeler des web services depuis le frontend avec `Api()` ou `StandardApi()`
- Utiliser les directives custom (`v-focus`, `v-uppercase`)
- Appliquer les regles de validation de formulaires Hexagone

## Prerequis

- Acces au reseau interne Dedalus (pour atteindre le depot GitLab)

## Demarrage rapide

```bash
npx skills add Dedalus-ERP-PAS/foundation-skills --skill hexagone-frontend -g -y
```

## Fonctionnement

Le skill utilise **WebFetch** pour consulter les fichiers markdown optimises LLM directement depuis le depot GitLab :

1. **Identification du composant/pattern** : a partir de la question de l'utilisateur, le skill identifie le fichier de documentation concerne grace a un catalogue integre de tous les composants, patterns et references.

2. **Recuperation du fichier** : il appelle WebFetch sur l'URL brute du fichier dans le depot GitLab (ex: `https://gitlab-erp-pas.dedalus.lan/.../docs/llm/components/button.md`).

3. **Extraction et presentation** : il extrait les props, events et exemples pertinents et les presente de maniere structuree.

## Composants disponibles

### Formulaires et saisie (16 composants)

| Composant | Balise | Description |
|-----------|--------|-------------|
| Input | `<input>` + wrapper | Champ de texte |
| Textarea | `<textarea>` + wrapper | Zone de texte multiligne |
| Number | `<number>` | Champ numerique |
| Currency | `<currency>` | Champ monetaire |
| Select | `<multiselect>` | Selecteur simple ou multiple |
| Autocomplete | `<autocomplete>` | Champ avec autocompletion |
| Checkbox | `<checkbox>` | Case a cocher |
| Radio | `<radio>` | Boutons radio |
| ButtonSwitch | `<btn-switch>` | Bouton basculeur on/off |
| Datepicker | `<datepicker>` | Selecteur de date |
| Timepicker | `<timepicker>` | Selecteur d'heure |
| Colorpicker | `<colorpicker>` | Selecteur de couleur |
| File | `<file>` | Upload de fichier |
| Iban | `<iban>` | Champ IBAN |
| Bic | `<bic>` | Champ BIC |
| Radical | `<radical>` | Champ avec prefixe |

### Navigation et actions (8 composants)

| Composant | Balise | Description |
|-----------|--------|-------------|
| Button | `<btn>` | Bouton interactif |
| ButtonGroup | `<btn-group>` | Groupe de boutons |
| FloatingButton | `<floating-btn>` | Bouton flottant avec menu |
| Action | `<action>` | Composant d'action |
| Link | `<link>` | Lien de navigation |
| Bookmark | `<bookmark>` | Signet de page |
| Tabs | `<tabs>` | Systeme d'onglets |
| Steps | `<steps>` | Etapes de progression |

### Affichage de donnees (4 composants)

| Composant | Balise | Description |
|-----------|--------|-------------|
| DataTable | `<data-table>` | Tableau avec pagination et tri |
| SimpleTable | `<simple-table>` | Tableau simple avec selection |
| Card | `<card>` | Conteneur de carte |
| ProgressBar | `<progress-bar>` | Barre de progression |

### Retour utilisateur (7 composants)

| Composant | Balise | Description |
|-----------|--------|-------------|
| Alert | `<alert>` | Alerte avec etats |
| Modal | `<modal>` | Fenetre modale |
| Notification | `$notification()` | Notifications programmatiques |
| Question | `<question>` | Dialogue de question |
| Tooltips | `<tooltips>` | Infobulle au survol |
| PostIt | `<post-it>` | Note type post-it |
| Spinner | `<spinner>` | Indicateur de chargement |

## Source

- **Site de documentation** : `https://erp-pas.gitlab-pages-erp-pas.dedalus.lan/hexagone/frontend/hexagone-documentation`
- **Depot GitLab** : `https://gitlab-erp-pas.dedalus.lan/erp-pas/hexagone/frontend/hexagone-documentation`
- **Fichiers LLM** : `docs/llm/` dans le depot (composants, patterns, references)
- **Maintenance** : equipe Hexagone Frontend, Dedalus ERP-PAS

## Skills complementaires

| Skill | Relation |
|-------|----------|
| [hexagone-swdoc](hexagone-swdoc.md) | Documentation des web services SOAP pour le backend Hexagone |
| [vue-best-practices](vue-best-practices.md) | Best practices Vue.js generales (le frontend Hexagone utilise Vue.js 2) |
| [hpk-parser](hpk-parser.md) | Parsing des messages HPK echanges via les web services |
| [uniface-procscript](uniface-procscript.md) | Reference ProcScript pour le code Uniface backend |
