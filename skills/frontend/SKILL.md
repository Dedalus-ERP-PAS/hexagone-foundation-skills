---
name: frontend
description: "Enforces framework-native frontend development. Use the component library and CSS framework as intended — no overrides, no fighting the framework. Respects the design system, uses Tailwind best practices, and leverages the component library's built-in theming instead of bypassing it."
version: 3.0.0
license: Complete terms in LICENSE.txt
---

# Frontend Design Skill

This skill enforces a single principle: **work WITH the framework, never against it.** Use the component library natively. Use the CSS framework idiomatically. Let the design system do its job.

The user provides frontend requirements: a component, page, or interface to build or modify.

## Core Philosophy

> Don't fight the framework. Use it as it was designed to be used.

Every frontend framework and component library has an intended way to be used. The job of this skill is to ensure that every line of frontend code respects that intent. Customization happens through the channels the framework provides — not by bypassing them.

## Step 1: Codebase Context Discovery (MANDATORY)

**Before writing any code, scan the codebase.** This step is non-negotiable.

### What to Detect

1. **Frontend framework** — Check `package.json` for: `react`, `vue`, `angular`, `svelte`, `next`, `nuxt`, `astro`, `solid-js`
2. **Component library** — Check dependencies for: PrimeVue, shadcn/ui, Vuetify, MUI, Chakra UI, Ant Design, Radix, Mantine, Quasar, Element Plus, Headless UI
3. **CSS framework** — Check for: Tailwind (`tailwind.config.*`, `@tailwind` directives), SCSS, CSS Modules, etc.
4. **Theme configuration** — Find the theming mechanism:
   - PrimeVue: theme preset in `main.ts` (Aura, Lara, Nora), design token overrides
   - Vuetify: `vuetify.ts` theme config
   - MUI: `createTheme()` config
   - Tailwind: `tailwind.config.*` or `@theme` block (v4)
5. **Existing component patterns** — Examine 2-3 existing components to understand how the library is used in practice

**State your findings before proceeding.** Example: "Detected: Vue 3 + PrimeVue (Aura preset) + Tailwind CSS. I will use PrimeVue components natively with Tailwind for layout only."

## Step 2: Framework-Native Implementation

### The Golden Rule

**Use every component, utility, and API the way the framework documentation shows it.** If the framework has a built-in way to do something, use it. Do not invent alternatives.

### Component Library Rules

These rules apply regardless of which component library the project uses (PrimeVue, MUI, Vuetify, shadcn/ui, etc.):

**ALWAYS:**
- Use the library's components directly with their documented props and API
- Customize appearance through the library's **theming system** (design tokens, theme presets, theme config)
- Use the library's built-in variants, severities, and sizes (`severity="success"`, `size="small"`, etc.)
- Use the library's slot system when you need to customize content areas
- Follow the library's documented patterns for forms, dialogs, tables, etc.
- Use the library's icons and icon integration as documented

**NEVER:**
- Override component internals with CSS targeting internal class names or DOM structure
- Create wrapper components that re-style library components from the outside
- Use `!important` to override library styles
- Duplicate functionality that already exists in the library (if it has a Tooltip, use it)
- Mix components from multiple UI libraries in the same project

### PrimeVue-Specific Rules

PrimeVue v4 uses a design token system with presets (Aura, Lara, Nora). This is the ONLY supported customization path.

**NEVER do this:**
- Use the PassThrough (`pt`) API to restyle components with Tailwind classes
- Use `unstyled` mode to strip PrimeVue's styles and rebuild from scratch
- Use `usePassThrough()` utility to override preset styling
- Create wrapper components that apply `pt` overrides globally
- Target PrimeVue's internal CSS classes (`.p-button-label`, `.p-datatable-header`, etc.) in your stylesheets
- Add Tailwind utility classes to PrimeVue component root elements to override their appearance

**DO this instead:**
- Pick a theme preset (Aura, Lara, Nora) and use it
- Customize through PrimeVue's design token system in `main.ts` or theme config:
  ```typescript
  app.use(PrimeVue, {
    theme: {
      preset: Aura,
      options: {
        prefix: 'p',
        darkModeSelector: '.dark-mode',
        cssLayer: { name: 'primevue', order: 'tailwind-base, primevue, tailwind-utilities' }
      }
    }
  })
  ```
- Override design tokens at the theme level when you need different colors or spacing:
  ```typescript
  import { definePreset } from '@primevue/themes'
  import Aura from '@primevue/themes/aura'

  const MyPreset = definePreset(Aura, {
    semantic: {
      primary: {
        50: '{indigo.50}',
        // ...
        950: '{indigo.950}'
      }
    }
  })
  ```
- Use component props as documented: `severity`, `size`, `outlined`, `rounded`, `raised`, `text`, etc.
- Use PrimeVue's built-in CSS layer ordering to ensure Tailwind and PrimeVue coexist cleanly

**Why no `pt`?** The PassThrough API fights the framework. It bypasses the theming system, creates maintenance burden when PrimeVue updates internal DOM structure, and produces code that is neither idiomatic PrimeVue nor idiomatic Tailwind. The design token system exists precisely so you don't need `pt`.

### CSS Framework Rules (Tailwind)

When the project uses Tailwind CSS, follow these rules on **every** frontend change:

**ALWAYS:**
- Use Tailwind utility classes directly in templates — this is the primary styling mechanism
- Follow mobile-first responsive design: base styles first, then `sm:`, `md:`, `lg:`, `xl:`
- Use consistent class ordering: layout > positioning > box model > typography > visual > interactive
- Use the project's Tailwind config tokens (`text-primary-500`, not `text-[#3b82f6]`)
- Use complete class strings — never concatenate (`bg-${color}-500` breaks the compiler)
- Use computed properties or lookup objects for dynamic classes
- Use `prettier-plugin-tailwindcss` for automatic class sorting if available
- Use Tailwind for layout, spacing, and typography on YOUR elements (not library components)

**NEVER:**
- Write custom CSS when a Tailwind utility exists for it
- Use `@apply` excessively — prefer Vue components for abstraction instead of CSS classes
- Use arbitrary values (`text-[14px]`) when a Tailwind scale value exists (`text-sm`)
- Concatenate class names dynamically (breaks purging in production)
- Mix CSS methodologies — if the project uses Tailwind, don't add CSS Modules or styled-components
- Use Tailwind utilities to override component library styles

**Tailwind + Component Library coexistence:**
- Tailwind handles: page layout, spacing between components, custom elements, typography on non-library elements
- Component library handles: component appearance, component spacing internals, interactive states
- They do NOT overlap: don't use Tailwind to restyle library components, don't use library classes for page layout

### Tailwind Best Practices Checklist

Apply this checklist on every frontend change:

- [ ] Mobile-first: base styles are mobile, breakpoints add complexity
- [ ] No arbitrary values when a scale value exists
- [ ] No `@apply` — use Vue components for repeated patterns
- [ ] No class concatenation — use lookup objects for dynamic classes
- [ ] Consistent class ordering (use Prettier plugin)
- [ ] Dark mode uses `dark:` prefix consistently
- [ ] Interactive states use `hover:`, `focus:`, `active:`, `disabled:` variants
- [ ] Focus styles are visible for accessibility (`focus:ring-2`, `focus:outline-none`)
- [ ] Design tokens from `tailwind.config` are used, not hardcoded values
- [ ] No conflicting utilities on the same element

## Step 3: What This Skill is NOT

This skill does NOT cover:
- **Aesthetic direction or creative design** — it enforces framework discipline, not visual creativity
- **Framework-specific API patterns** — defer to `vue-best-practices`, `react-best-practices` for those
- **Greenfield design system creation** — use `create-design-system-rules` for that

## What to AVOID — Summary

| Anti-pattern | Why it's wrong | What to do instead |
|-------------|----------------|-------------------|
| `pt` API on PrimeVue components | Fights the framework's theming system | Use design tokens and `definePreset()` |
| `unstyled` mode + Tailwind rebuild | Re-implements PrimeVue from scratch | Use a theme preset |
| Wrapper components with style overrides | Unnecessary abstraction, breaks on updates | Use components directly with props |
| `!important` overrides | Specificity wars, unmaintainable | Fix the root cause through theme config |
| Tailwind classes on library components | Two systems fighting for control | Let the library own its components |
| Custom CSS for things Tailwind does | Mixed methodologies | Use Tailwind utilities |
| `@apply` everywhere | Defeats utility-first purpose | Extract Vue components instead |
| Arbitrary values (`text-[14px]`) | Bypasses design token system | Use scale values (`text-sm`) |
| Class concatenation (`bg-${x}-500`) | Breaks Tailwind compiler purging | Use lookup objects |
| Targeting internal library classes | Breaks on library updates | Use library's theming API |

## Complementary Skills

- **vue-best-practices** / **react-best-practices** — Framework-specific API patterns and component architecture
- **create-design-system-rules** — For projects without an established design system
- **web-design-guidelines** — For auditing accessibility and UI quality

## Remember

The best frontend code is invisible. It uses the tools the project chose — the component library, the CSS framework, the theme system — exactly as they were meant to be used. No overrides. No workarounds. No cleverness that the next developer has to reverse-engineer.

**Use the framework. Trust the framework. Don't fight the framework.**
