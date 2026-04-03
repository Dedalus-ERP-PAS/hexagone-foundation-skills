---
name: design-compliance
description: "Audit automatique de conformité au design system Hexagone (PrimeVue 4 + Tailwind CSS 4 + tokens Hexagone). Analyse le code source et l'UI rendue d'une page ou d'un composant, détecte les violations, corrige automatiquement et produit un rapport — le tout sans intervention de l'utilisateur."
version: 1.0.0
license: MIT
metadata:
  author: Foundation Skills
  argument-hint: <url-or-component-or-page-name>
---

# Design Compliance

Run a fully autonomous design system compliance audit on a page or component of the Hexagone Web application. The skill discovers source files, recursively analyzes the full component tree, visually inspects the rendered page (light + dark mode), detects all violations against the Hexagone design system rules, auto-fixes every violation in place, and prints a structured report — all without asking the user for confirmation.

## When to Use This Skill

Activate when the user:
- Says "design-compliance" followed by a URL, component name, or page name
- Asks to audit or check design system compliance on a page or component
- Wants to enforce PrimeVue / Tailwind / Hexagone token conventions on existing code
- Says "check the design", "audit the UI", "design review" on Hexagone code

## Core Principles

### 1. Full Autonomy
- The entire pipeline runs without asking questions during execution
- If no argument is provided, ask the user what to review — then run autonomously
- Files are edited in place without confirmation
- Changes are NOT committed — the developer reviews the diff

### 2. Single Standard (No Per-MF Exceptions)
- **Composition API** with `<script setup lang="ts">` — always
- **Tailwind CSS 4** — always
- **Pinia** for state management — always
- **PrimeVue 4 native** components — always (no hexa-compat in new/modified code)
- **`dt`** for scoped token overrides — always (never `pt` for visual styling)

### 3. Hexagone-Specific
This skill is tailored to the Hexagone Web monorepo stack:
- PrimeVue 4.3 with `hexagone-preset.js` (extends Aura)
- Tailwind CSS 4
- 3-layer token system: `--p-*` (PrimeVue), `--hexa-*` (shell only), beta-scss (legacy, forbidden)
- Vue.js 3.5 with TypeScript

### 4. Fix Everything
The skill auto-fixes ALL violations — mechanical (import renames, class swaps) AND structural (component replacements, template rewrites). No report-only mode. No asking before editing.

## Source of Truth (Priority Order)

The skill builds its ruleset from these sources, checked in order:

1. **Explicit rules files** (override everything if present):
   - `design-system.md` or `docs/design-system/design-rules.md`
   - `CLAUDE.md` (root and per-MF)
   - `.github/copilot-instructions.md` or `.github/instructions/*.md`

2. **Framework configuration**:
   - `hexagone-preset.js` — PrimeVue preset (tokens, color scheme)
   - `shell-tokens.scss` — Shell chrome tokens (`--hexa-*`)
   - `tailwind.config.*` — Tailwind configuration
   - `package.json` — PrimeVue version, dependencies

3. **Codebase patterns**:
   - Existing "good" components as implicit conventions
   - Router configuration for route-to-component mapping

## Input Modes

The skill accepts three types of input, all converging to the same pipeline:

### URL Mode
```
/design-compliance http://localhost:5173/hexagone-etab/vue/patients
```
1. Use the URL directly for visual inspection
2. Reverse-map the URL path to a route in the router config
3. Find the component file for that route
4. Recursively resolve all local imports

### Component Name Mode
```
/design-compliance PatientDashboard
```
1. Glob for matching files: `**/PatientDashboard.vue`, `**/patient-dashboard.vue`, `**/PatientDashboard/**`
2. If multiple matches, review all of them
3. For each matched component, resolve the route it belongs to (if any) for visual inspection
4. Recursively resolve all local imports

### Page Name Mode
```
/design-compliance Patients
```
1. Search the router configuration files for a route named "Patients" or with path `/patients`
2. Find the component assigned to that route
3. Construct the URL for visual inspection
4. Recursively resolve all local imports

### No Argument
```
/design-compliance
```
Ask the user what to review. Do not assume.

## Workflow

### Step 1: Discover Source of Truth

1. **Read explicit rules files** (if they exist in the project):
   - Glob for `**/CLAUDE.md`, `**/design-system.md`, `**/design-rules.md`
   - Glob for `.github/copilot-instructions.md`, `.github/instructions/*.md`
   - Extract design system rules, anti-patterns, token conventions

2. **Read framework configuration**:
   - Find and read the PrimeVue preset file (usually `**/hexagone-preset.js` or `**/theme/*.js`)
   - Find and read shell tokens (usually `**/shell-tokens.scss`)
   - Read `package.json` to confirm PrimeVue version and dependencies
   - Read Tailwind config if present

3. **Build the merged ruleset** — combine all sources into a single checklist of rules to enforce

### Step 2: Resolve Target Files

Based on the input mode:

1. **Parse the user's input** to determine the mode (URL, component name, or page name)

2. **Find the entry-point file(s)**:
   - URL → parse the path, search router files (`**/router/**/*.{js,ts}`, `**/router.{js,ts}`) for matching route, get the component
   - Component name → glob for `**/<name>.vue`, `**/<name-kebab>.vue`, `**/<Name>/**`
   - Page name → search router config for route name or path match

3. **Recursively resolve the component tree**:
   - Read each `.vue` file
   - Extract all local imports (skip `primevue/*`, `vue`, `vue-router`, `pinia`, `node_modules`)
   - Follow each import to its file, repeat until no new local components are found
   - Build the full file list to review

4. **Report the discovered tree** to the user:
   ```
   Found 12 files in component tree for PatientDashboard:
   - frontend/gap-mf/src/views/PatientDashboard.vue (entry)
   - frontend/gap-mf/src/components/PatientHeader.vue
   - frontend/gap-mf/src/components/PatientTimeline.vue
   - ...
   ```

### Step 3: Static Code Analysis

For each file in the component tree, check ALL violation categories:

#### Category 1: Wrong Component
- Raw `<button>`, `<input>`, `<select>`, `<textarea>`, `<table>` when PrimeVue equivalents exist
- `<btn>`, `<alert>`, `<card>`, `<action>`, `<spinner>` (hexa-compat) — should be PrimeVue native
- Any hexa-components (`<datepicker>`, `<data-table>`, `<modal>`, etc.) — should be PrimeVue native
- **Fix:** replace with the correct PrimeVue component, update imports, adapt props/slots

#### Category 2: Wrong Token Layer
- Hardcoded colors: `#xxx`, `rgb(...)`, `hsl(...)` in `<style>` or inline styles
- beta-scss classes: `text:teal`, `bg:grey-lightest`, `flex:6/12`, etc. in templates
- `--hexa-*` tokens used outside shell components (Header, Sidebar, Navigation)
- Arbitrary Tailwind values: `text-[#ff0000]`, `bg-[rgb(...)]`, `p-[17px]`
- **Fix:** replace with `var(--p-*)` tokens, Tailwind theme classes, or `dt()` overrides

#### Category 3: `pt` Misuse
- `pt` prop used for visual styling: `border`, `shadow`, `padding`, `margin`, `background`, `color`, `font-size`, `border-radius`
- **Fix:** move visual overrides to `dt` prop or `<style scoped>` with tokens

#### Category 4: Import Violations
- Uppercase PrimeVue imports: `primevue/InputText` → `primevue/inputtext`
- v3 component names: `Dropdown` → `Select`, `Calendar` → `DatePicker`, `InputSwitch` → `ToggleSwitch`, `OverlayPanel` → `Popover`, `TabView`/`TabPanel` → `Tabs`/`TabList`/`Tab`/`TabPanels`/`TabPanel`, `Chips` → `InputChips`
- Named imports from `primevue` barrel: `import { InputText } from "primevue"` → default import
- **Fix:** rewrite the import statement, update component registration and template usage

#### Category 5: Dark Mode Violations
- `:global(.p-dark)` nested inside `<style scoped>` — must use a separate unscoped `<style>` block
- Hardcoded light-only colors without dark mode variant
- **Fix:** move dark mode styles to a separate `<style>` block, use tokens that auto-switch

#### Category 6: i18n Violations
- Hardcoded text strings in templates (labels, placeholders, titles, messages, error text)
- Exceptions: single characters (`/`, `|`, `:`, `-`), numbers, CSS class names, prop values that are not user-visible
- **Fix:** extract to locale file, replace with `t('key')` (Composition API) or `$t('key')` (Options API)

#### Category 7: Accessibility
- `<button>` or PrimeVue `Button` with only an icon and no `aria-label`
- Form fields without associated `<label>` (no `for`/`id` pair, no `FloatLabel` wrapper)
- Context menus (right-click handlers) — app must work on tablets
- Hover-only interactions (`@mouseenter`/`@mouseleave` without click alternative)
- Missing `alt` on `<img>` tags
- **Fix:** add `aria-label`, wrap in `FloatLabel`, replace hover with click, add `alt` text

#### Category 8: Framework Conventions
- Options API (`export default { data(), methods, computed }`) instead of `<script setup lang="ts">`
- Missing `lang="ts"` on `<script setup>`
- Vuex/pathify usage instead of Pinia
- `this.$store` / `mapState` / `mapGetters` / `mapActions` instead of Pinia `useXxxStore()`
- Inline styles (`style="..."`) instead of Tailwind classes or scoped CSS with tokens
- `!important` in new code (acceptable only to counter beta-scss legacy conflicts)
- **Fix:** rewrite to Composition API with `<script setup lang="ts">`, migrate state to Pinia, replace inline styles

### Step 4: Visual Inspection

**Prerequisite:** Check if a dev server is running by probing common ports (5173, 5174, 3000, 8080).

If **no dev server is detected**, skip visual inspection entirely and proceed to Step 5 with code-only results.

If a **dev server is running**:

#### 4a. Navigate to the Page

1. Determine the URL:
   - If the user provided a URL, use it directly
   - If a component/page name was provided, construct the URL from the route config
   - If the route cannot be determined, skip visual inspection

2. Open the page in a headless browser (Playwright)

3. **Handle authentication:**
   - If a login page is detected (look for login form, `/login` redirect), authenticate:
     - Username: `apvhn`
     - Password: `apvhn`
   - After login, navigate to the target page

#### 4b. Light Mode Inspection

1. Take a full-page screenshot
2. Analyze computed styles on key elements:
   - Check for hardcoded colors not matching `--p-*` token values
   - Check for non-standard spacing (values that don't align with the Tailwind spacing scale)
   - Check for inconsistent border-radius across sibling elements
3. Visual heuristics:
   - Misaligned elements (inconsistent padding/margins between siblings)
   - Broken or inconsistent responsive behavior
   - Elements overflowing their containers
   - Inconsistent font sizes within the same context

#### 4c. Dark Mode Inspection

1. Toggle dark mode: execute `document.documentElement.classList.add('p-dark')` in the browser
2. Take a second full-page screenshot
3. Check for:
   - Elements with hardcoded light colors that don't adapt (white backgrounds, dark text on dark bg)
   - `--hexa-*` tokens not switching correctly
   - Contrast issues (text unreadable against background)
   - Visual artifacts from non-token-based styling

#### 4d. Capture Results

Compile all visual issues with:
- Element selector or description
- Issue description
- Severity (P1: broken/unreadable, P2: inconsistent, P3: minor polish)

### Step 5: Auto-Fix All Violations

For every violation found (code + visual):

1. **Prioritize fixes:** P1 (broken) → P2 (inconsistent) → P3 (polish)
2. **Edit files in place** using the Edit tool
3. **Respect existing patterns:** when fixing, match the style of surrounding code
4. **Handle cascading fixes:** if replacing a component changes its API (props, slots, events), update all usages in the template
5. **Update imports:** add new PrimeVue imports, remove unused ones
6. **Do NOT commit** — leave changes unstaged for the developer to review

### Step 6: Generate Report

Print a structured report to the terminal:

```markdown
## Design Compliance Report

**Target:** [component/page name or URL]
**Files analyzed:** [count]
**Violations found:** [count]
**Violations fixed:** [count]
**Visual inspection:** [performed (light + dark) / skipped (no dev server)]

### Files in Component Tree
| # | File | Violations |
|---|------|------------|
| 1 | `frontend/gap-mf/src/views/PatientDashboard.vue` | 5 |
| 2 | `frontend/gap-mf/src/components/PatientHeader.vue` | 2 |
| ... | ... | ... |

### Violations Fixed

#### Category 1: Wrong Component ([count])
| File | Line | Before | After |
|------|------|--------|-------|
| `PatientDashboard.vue` | 42 | `<button @click="save">` | `<Button @click="save" label="..." />` |

#### Category 2: Wrong Token Layer ([count])
| File | Line | Before | After |
|------|------|--------|-------|
| `PatientHeader.vue` | 15 | `color: #006875` | `color: var(--p-primary-500)` |

#### Category 3: pt Misuse ([count])
...

#### Category 4: Import Violations ([count])
...

#### Category 5: Dark Mode Violations ([count])
...

#### Category 6: i18n Violations ([count])
...

#### Category 7: Accessibility ([count])
...

#### Category 8: Framework Conventions ([count])
...

### Visual Inspection Results
[If performed]

#### Light Mode
- [Issue 1: description — severity]
- [Issue 2: description — severity]

#### Dark Mode
- [Issue 1: description — severity]
- [Issue 2: description — severity]

### Summary
- **Total violations:** [count]
- **Auto-fixed:** [count]
- **Remaining (manual review needed):** [count, if any]
```

## Violation Reference

### PrimeVue v3 → v4 Renamed Components

| v3 (FORBIDDEN) | v4 (CORRECT) | Import Path |
|----------------|--------------|-------------|
| `Dropdown` | `Select` | `primevue/select` |
| `Calendar` | `DatePicker` | `primevue/datepicker` |
| `InputSwitch` | `ToggleSwitch` | `primevue/toggleswitch` |
| `OverlayPanel` | `Popover` | `primevue/popover` |
| `TabView` / `TabPanel` | `Tabs` / `TabList` / `Tab` / `TabPanels` / `TabPanel` | `primevue/tabs`, etc. |
| `Chips` | `InputChips` | `primevue/inputchips` |

### HTML → PrimeVue Mapping

| Raw HTML | PrimeVue Replacement |
|----------|---------------------|
| `<button>` | `<Button>` from `primevue/button` |
| `<input type="text">` | `<InputText>` from `primevue/inputtext` |
| `<input type="checkbox">` | `<Checkbox :binary="true">` from `primevue/checkbox` |
| `<input type="radio">` | `<RadioButton>` from `primevue/radiobutton` |
| `<select>` | `<Select>` from `primevue/select` |
| `<textarea>` | `<Textarea>` from `primevue/textarea` |
| `<table>` | `<DataTable>` + `<Column>` from `primevue/datatable`, `primevue/column` |
| `<dialog>` | `<Dialog>` from `primevue/dialog` |
| `<progress>` | `<ProgressBar>` from `primevue/progressbar` |

### hexa-compat → PrimeVue Mapping

| hexa-compat | PrimeVue Native |
|-------------|----------------|
| `<btn severity="...">` | `<Button severity="...">` from `primevue/button` |
| `<alert color="red">` | `<Message severity="error">` from `primevue/message` |
| `<card>` | `<Card>` from `primevue/card` |
| `<action @click>` | `<Button link @click>` from `primevue/button` |
| `<spinner>` | `<ProgressSpinner>` from `primevue/progressspinner` |
| `<modal>` | `<Dialog>` from `primevue/dialog` |

### Token Layer Rules

| Context | Allowed | Forbidden |
|---------|---------|-----------|
| Business pages (views, components) | `var(--p-*)`, Tailwind classes, `dt()` | `var(--hexa-*)`, beta-scss classes, hardcoded colors |
| Shell components (Header, Sidebar, Nav) | `var(--hexa-*)`, `var(--p-*)` | beta-scss classes, hardcoded colors |
| New code (any) | Tailwind CSS 4 classes, `var(--p-*)` tokens | beta-scss classes, inline styles, `!important` |

### beta-scss → Modern Equivalents

| beta-scss Class | Tailwind / Token Replacement |
|-----------------|------------------------------|
| `text:teal` | `text-primary-500` or `var(--p-primary-500)` |
| `bg:grey-lightest` | `bg-surface-50` or `var(--p-surface-50)` |
| `bg:teal-dark` | `var(--hexa-chrome-bg-accent)` (shell only) |
| `bg:orange` | `var(--hexa-nav-bg)` (shell only) |
| `flex:X/12` | Tailwind grid or `w-{fraction}` |
| `p:1`, `m:1`, `pt:1` | Tailwind `p-4`, `m-4`, `pt-4` |
| `text:bold` | `font-bold` |
| `text:center` | `text-center` |
| `border` | `border` |
| `rounded:1/2` | `rounded-md` or `var(--p-content-border-radius)` |
| `w:full` | `w-full` |

## Edge Cases

### No Files Found
If the glob/search finds no matching files:
- Tell the user: "No files found matching '[input]'. Try a URL, a .vue component name, or a route path."
- Stop

### Dev Server Not Running
- Skip visual inspection entirely
- Run code-only analysis and auto-fixes
- Note in the report: "Visual inspection skipped — no dev server detected on ports 5173, 5174, 3000, 8080"

### Authentication Fails
- If login with `apvhn`/`apvhn` fails, skip visual inspection
- Note in the report: "Visual inspection skipped — authentication failed"
- Continue with code-only analysis

### Large Component Tree (20+ files)
- Process all files — do not skip or sample
- Organize the report by file for readability
- Use parallel sub-agents if the tree exceeds 10 files (one sub-agent per batch of 5 files)

### Mixed MF Files
If the component tree spans multiple micro-frontends (e.g., shared package imports):
- Apply the same single standard to all files
- Note in the report which MF each file belongs to

### File Already Compliant
If a file has zero violations:
- Include it in the file list with "0 violations"
- Do not edit it

## Important Notes

- **This skill modifies files.** It edits `.vue` files in place to fix violations. Changes are NOT committed.
- **The developer reviews the diff.** After the skill runs, the developer should `git diff` to verify all changes.
- **i18n keys:** when extracting hardcoded text, use descriptive dot-notation keys matching the component name and context (e.g., `patientDashboard.title`, `patientHeader.saveButton`)
- **PrimeVue docs:** for component API details, fetch `https://primevue.org/<component>.md`
- **Recursive resolution stops at:** `primevue/*`, `vue`, `vue-router`, `pinia`, `@vueuse/*`, `node_modules`, `@hexagone/shared` (treat shared package as a library boundary)
- **Shell components** (Header, Sidebar, Navigation, Breadcrumbs) are allowed to use `--hexa-*` tokens — do not flag these
