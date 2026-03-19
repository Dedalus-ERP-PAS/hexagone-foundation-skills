---
name: hexagone-frontend
description: "Navigue et interroge la documentation des composants frontend Hexagone (@his/hexa-components). À utiliser quand l'utilisateur pose des questions sur les composants Vue.js Hexagone, les patrons UI, les classes CSS beta-scss, les modules de store Vuex, les directives personnalisées, les règles de validation de formulaires ou le design system frontend Hexagone. Récupère la documentation optimisée LLM depuis le dépôt GitLab."
version: 1.0.0
license: Proprietary
metadata:
  author: dedalus-erp-pas
  source-repo: erp-pas/hexagone/frontend/hexagone-documentation
  source-url: https://gitlab-erp-pas.dedalus.lan/erp-pas/hexagone/frontend/hexagone-documentation
  pages-url: https://erp-pas.gitlab-pages-erp-pas.dedalus.lan/hexagone/frontend/hexagone-documentation
allowed-tools: WebFetch
---

# Hexagone Frontend Documentation -- Navigation Skill

This skill gives you access to the **Hexagone frontend component documentation** (`@his/hexa-components`) published as GitLab Pages. Your role is to **fetch and read the relevant documentation files** when answering questions about Hexagone frontend components, patterns, and conventions.

## What is Hexagone frontend documentation

The Hexagone frontend is built with **Vue.js 2** using a custom component library (`@his/hexa-components`) with **beta-scss** utility classes and **Vuex with vuex-pathify** for state management. The documentation site is published at:

```
https://erp-pas.gitlab-pages-erp-pas.dedalus.lan/hexagone/frontend/hexagone-documentation
```

The site is a single-page application (SPA) and cannot be fetched directly. Instead, use the **raw markdown files** from the GitLab repository, which are specifically optimized for LLM consumption.

**When to use this skill:**
- The user asks about a Hexagone UI component (`<btn>`, `<multiselect>`, `<data-table>`, etc.)
- The user needs props, events, or usage examples for a Hexagone component
- The user asks about beta-scss CSS utility classes (`flex:6/12`, `p:1`, `m:1`, etc.)
- The user asks about the Vuex store modules (user, session, environment, navigation, etc.)
- The user asks about the API utility (`Api()`, `StandardApi()`)
- The user asks about custom directives (`v-focus`, `v-uppercase`)
- The user asks about form validation rules or form patterns in Hexagone
- The user is building or modifying a Hexagone Web frontend view/space
- Any question mentioning "Hexagone" combined with "component", "composant", "frontend", "Vue", "template", "formulaire", or "interface"

## Critical conventions

> **IMPORTANT**: Hexagone uses custom tag names. NEVER use standard HTML tags for these components.

| Standard HTML | Hexagone equivalent | Doc file |
|---------------|---------------------|----------|
| `<button>` | `<btn>` | `components/button.md` |
| `<select>` | `<multiselect>` | `components/select.md` |
| `<table>` | `<data-table>` | `components/datatable.md` |
| `<input type="checkbox">` | `<checkbox>` | `components/checkbox.md` |

**Key rules:**
- All components are **globally registered** -- no import needed in templates
- Form fields must be wrapped in `<div class="input-field"><label for="id">Label</label><!-- component --></div>`
- Use **beta-scss** utility classes: `flex`, `flex:wrap`, `flex:6/12`, `p:1`, `m:1`, etc.
- Store access via **vuex-pathify**: `this.$store.get('module/path')` and `this.$store.set('module/path', value)`
- Library: `@his/hexa-components`, Framework: Vue.js 2

## Documentation catalog

The raw files are available at:

```
BASE_RAW_URL = https://gitlab-erp-pas.dedalus.lan/erp-pas/hexagone/frontend/hexagone-documentation/-/raw/master/docs/llm/
```

### Components (36 components)

#### Forms and input

| Component | Tag | File path |
|-----------|-----|-----------|
| Input | `<input>` + wrapper | `components/input.md` |
| Textarea | `<textarea>` + wrapper | `components/textarea.md` |
| Number | `<number>` | `components/number.md` |
| Currency | `<currency>` | `components/currency.md` |
| Select | `<multiselect>` | `components/select.md` |
| Autocomplete | `<autocomplete>` | `components/autocomplete.md` |
| Checkbox | `<checkbox>` | `components/checkbox.md` |
| Radio | `<radio>` | `components/radio.md` |
| ButtonSwitch | `<btn-switch>` | `components/button-switch.md` |
| Datepicker | `<datepicker>` | `components/datepicker.md` |
| Timepicker | `<timepicker>` | `components/timepicker.md` |
| Colorpicker | `<colorpicker>` | `components/colorpicker.md` |
| File | `<file>` | `components/file.md` |
| Iban | `<iban>` | `components/iban.md` |
| Bic | `<bic>` | `components/bic.md` |
| Radical | `<radical>` | `components/radical.md` |

#### Navigation and actions

| Component | Tag | File path |
|-----------|-----|-----------|
| Button | `<btn>` | `components/button.md` |
| ButtonGroup | `<btn-group>` | `components/button-group.md` |
| FloatingButton | `<floating-btn>` | `components/floating-button.md` |
| Action | `<action>` | `components/action.md` |
| Link | `<link>` | `components/link.md` |
| Bookmark | `<bookmark>` | `components/bookmark.md` |
| Tabs | `<tabs>` | `components/tabs.md` |
| Steps | `<steps>` | `components/steps.md` |

#### Data display

| Component | Tag | File path |
|-----------|-----|-----------|
| DataTable | `<data-table>` | `components/datatable.md` |
| SimpleTable | `<simple-table>` | `components/simple-table.md` |
| Card | `<card>` | `components/card.md` |
| ProgressBar | `<progress-bar>` | `components/progress-bar.md` |

#### User feedback

| Component | Tag | File path |
|-----------|-----|-----------|
| Alert | `<alert>` | `components/alert.md` |
| Modal | `<modal>` | `components/modal.md` |
| Notification | `$notification()` | `components/notification.md` |
| Question | `<question>` | `components/question.md` |
| Tooltips | `<tooltips>` | `components/tooltips.md` |
| PostIt | `<post-it>` | `components/post-it.md` |
| Spinner | `<spinner>` | `components/spinner.md` |

#### Layout

| Component | Tag | File path |
|-----------|-----|-----------|
| Collapsible | `<collapsible>` | `components/collapsible.md` |

### Patterns

| Topic | File path | Description |
|-------|-----------|-------------|
| API utility | `patterns/api.md` | `Api(url, options)` and `StandardApi(USP)` for web service calls |
| Store (Vuex) | `patterns/store.md` | Vuex store with vuex-pathify, shared modules (user, session, etc.) |

### Reference

| Topic | File path | Description |
|-------|-----------|-------------|
| Directives | `reference/directives.md` | `v-uppercase`, `v-focus` custom directives |
| Events | `reference/events.md` | Mouse and keyboard event handling |
| Form rules | `reference/form-rules.md` | Validation rules, required fields, `@is-valid` pattern |

### Tag-to-file quick lookup

Use this table to quickly find which file to fetch when the user mentions a component tag:

| Tag pattern | File |
|-------------|------|
| `<btn>`, `button` | `components/button.md` |
| `<btn-group>` | `components/button-group.md` |
| `<btn-switch>` | `components/button-switch.md` |
| `<floating-btn>` | `components/floating-button.md` |
| `<multiselect>`, `select` | `components/select.md` |
| `<data-table>`, `datatable`, `table` | `components/datatable.md` |
| `<simple-table>` | `components/simple-table.md` |
| `<datepicker>`, `date` | `components/datepicker.md` |
| `<timepicker>`, `time`, `heure` | `components/timepicker.md` |
| `<checkbox>` | `components/checkbox.md` |
| `<radio>` | `components/radio.md` |
| `<autocomplete>` | `components/autocomplete.md` |
| `<modal>`, `modale` | `components/modal.md` |
| `<alert>`, `alerte` | `components/alert.md` |
| `<notification>`, `$notification` | `components/notification.md` |
| `<question>` | `components/question.md` |
| `<card>`, `carte` | `components/card.md` |
| `<collapsible>` | `components/collapsible.md` |
| `<tabs>`, `onglets` | `components/tabs.md` |
| `<steps>`, `etapes` | `components/steps.md` |
| `<spinner>`, `loading` | `components/spinner.md` |
| `<currency>`, `montant` | `components/currency.md` |
| `<iban>` | `components/iban.md` |
| `<bic>` | `components/bic.md` |
| `<number>`, `nombre` | `components/number.md` |
| `<input>`, `champ texte` | `components/input.md` |
| `<textarea>` | `components/textarea.md` |
| `<file>`, `upload` | `components/file.md` |
| `<radical>` | `components/radical.md` |
| `<colorpicker>`, `couleur` | `components/colorpicker.md` |
| `<action>` | `components/action.md` |
| `<link>`, `lien` | `components/link.md` |
| `<bookmark>`, `signet` | `components/bookmark.md` |
| `<post-it>` | `components/post-it.md` |
| `<progress-bar>` | `components/progress-bar.md` |
| `<tooltips>`, `infobulle` | `components/tooltips.md` |

## CSS utility classes (beta-scss)

These classes are available without any fetch -- use them directly:

| Class | Description |
|-------|-------------|
| `flex` | Display flex |
| `flex:wrap` | Flex wrap |
| `flex:col` | Flex direction column |
| `flex:X/12` | Fractional width (e.g., `flex:6/12` = 50%) |
| `p:1` | Padding 1rem |
| `m:1` | Margin 1rem |
| `pt:1`, `pr:1`, `pb:1`, `pl:1` | Directional padding |
| `mt:1`, `mr:1`, `mb:1`, `ml:1` | Directional margin |
| `text:bold` | Font-weight bold |
| `text:center` | Text-align center |
| `bg:grey-light` | Light grey background |
| `border` | Standard border |
| `rounded:1/2` | Border-radius |
| `w:full` | Width 100% |

## Icons

Use the `<icon>` component with the icon name:

```html
<icon>checked</icon>
<icon>close</icon>
<icon>search</icon>
<icon>edit</icon>
```

Icons come from `@his/fonts-icons`.

## How to answer questions

### Step 1: Identify the relevant file

Map the user's question to one or more documentation files using the tables above:

- **Specific component tag** (e.g., `<btn>`, `<multiselect>`) --> use the tag-to-file lookup
- **Component name** (e.g., "datatable", "datepicker") --> match to the component catalog
- **Store / state management** --> fetch `patterns/store.md`
- **API / web service calls** --> fetch `patterns/api.md`
- **Directives** (`v-focus`, `v-uppercase`) --> fetch `reference/directives.md`
- **Form validation / required fields** --> fetch `reference/form-rules.md`
- **Events** (click, keyboard) --> fetch `reference/events.md`
- **CSS classes** --> use the CSS utility table above (no fetch needed)
- **Icons** --> use the icons section above (no fetch needed)
- **General "list all components"** --> use the catalog above (no fetch needed)

### Step 2: Fetch the file

Use WebFetch to retrieve the raw markdown file from GitLab:

```
WebFetch: url="${BASE_RAW_URL}<file-path>" prompt="Return the full content of this markdown file"
```

For example:
- Button component: `WebFetch: url="https://gitlab-erp-pas.dedalus.lan/erp-pas/hexagone/frontend/hexagone-documentation/-/raw/master/docs/llm/components/button.md" prompt="Return the full content"`
- Store pattern: `WebFetch: url="https://gitlab-erp-pas.dedalus.lan/erp-pas/hexagone/frontend/hexagone-documentation/-/raw/master/docs/llm/patterns/store.md" prompt="Return the full content"`

**Fetch only the file(s) you need.** Do not fetch all files at once.

**If WebFetch fails** (network error, timeout), inform the user that the GitLab instance is unreachable and suggest they:
1. Access the documentation site directly: `https://erp-pas.gitlab-pages-erp-pas.dedalus.lan/hexagone/frontend/hexagone-documentation`
2. Browse the source repo: `https://gitlab-erp-pas.dedalus.lan/erp-pas/hexagone/frontend/hexagone-documentation/-/tree/master/docs/llm`

### Step 3: Extract and present the answer

After fetching, extract the relevant information:

1. **For a specific component:** present the props table, events table, and usage examples
2. **For a pattern:** present the API/function signature, options, and examples
3. **For a reference topic:** present the relevant rules, tables, or directives

Present the information clearly, preserving the original structure (prop tables, event tables, code examples).

### Step 4: Cross-reference if needed

If the user's question spans multiple topics (e.g., "how do I build a form with datepicker and validation?"), fetch multiple files and compose a coherent answer showing how to combine the components.

## Response guidelines

When presenting component documentation, use this structure:

```markdown
## <ComponentName> (`<tag-name>`)

**Library:** @his/hexa-components
**Source:** [file URL]

### Props
| Prop | Type | Default | Description |
|------|------|---------|-------------|

### Events
| Event | Description |
|-------|-------------|

### Example
[Code example from the documentation]
```

## Important rules

1. **Always fetch from the GitLab repository** -- never answer from memory or general knowledge about Vue.js components. Hexagone has specific conventions (custom tags, beta-scss, vuex-pathify) that differ from standard Vue.js patterns.

2. **Quote the source file** when presenting information: always mention which documentation file the information comes from.

3. **Do not invent props, events, or component behavior** -- if the information is not found in the fetched file, say so explicitly. Do not guess or extrapolate.

4. **Respect Hexagone conventions:**
   - Use `<btn>` not `<button>`, `<multiselect>` not `<select>`, `<data-table>` not `<table>`
   - Wrap form fields in `<div class="input-field">`
   - Use beta-scss utility classes, not custom CSS
   - Use `this.$store.get()` / `this.$store.set()` for store access

5. **Handle missing documentation gracefully** -- if a component is not documented, inform the user and suggest they check the hexagone-documentation site or open an issue in the repository at `https://gitlab-erp-pas.dedalus.lan/erp-pas/hexagone/frontend/hexagone-documentation`.

6. **Cross-reference with hexagone-swdoc** -- if the question involves calling Hexagone backend web services from a frontend view, suggest using the `hexagone-swdoc` skill for the API contract details and the `Api()` / `StandardApi()` utility from this skill for the frontend call pattern.

7. **Form field pattern to always follow:**
   ```html
   <div class="input-field">
     <label for="myField">My Label</label>
     <!-- component here -->
   </div>
   ```

8. **Use `<btn-group>` instead of `<multiselect>` when options are fewer than 6** -- this avoids an extra click and shows all options directly.
