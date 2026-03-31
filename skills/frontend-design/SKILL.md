---
name: frontend-design
description: "Crée des interfaces frontend distinctives, de qualité production, avec un haut niveau de design. Détecte automatiquement le design system et le framework du projet pour s'y conformer en priorité, puis exprime la créativité dans la composition, le layout et le motion. En mode greenfield (aucun système existant), applique une direction esthétique audacieuse et distinctive."
version: 2.0.0
license: Complete terms in LICENSE.txt
---

# Frontend Design Skill

This skill guides creation of distinctive, production-grade frontend interfaces. It automatically detects the project's existing design system and frontend framework, respects them first, then channels creativity through composition, layout, and motion.

The user provides frontend requirements: a component, page, application, or interface to build. They may include context about the purpose, audience, or technical constraints.

## Step 1: Codebase Context Discovery (MANDATORY)

**Before writing any code or choosing any aesthetic direction, scan the codebase.** This step is non-negotiable and runs every time.

### What to Detect

1. **Frontend framework** — Check `package.json` (or equivalent) for: `react`, `vue`, `angular`, `svelte`, `next`, `nuxt`, `astro`, `solid-js`
2. **Component library** — Check dependencies for: PrimeVue, shadcn/ui, Vuetify, MUI, Chakra UI, Ant Design, Radix, Mantine, Quasar, Element Plus, Headless UI
3. **CSS framework / methodology** — Check for:
   - Tailwind: `tailwind.config.*` files or `@tailwind` directives
   - CSS Modules: `*.module.css` files
   - Styled-components / Emotion: imports in component files
   - SCSS/SASS: `*.scss` files, variable files
   - CSS-in-JS: check imports
4. **Design tokens** — Scan for:
   - CSS custom properties files (`variables.css`, `tokens.css`, `:root` blocks)
   - Tailwind theme extensions in `tailwind.config.*`
   - SCSS variable files (`_variables.scss`, `_tokens.scss`)
   - Theme configuration files
5. **Existing typography** — Check for font declarations in:
   - Entry points (`index.html`, `_app.tsx`, `layout.tsx`, `nuxt.config.*`, `app.vue`)
   - Global CSS files
   - Font import statements (Google Fonts, local fonts)
6. **Existing color palette** — Look for defined colors in theme files, CSS variables, Tailwind config
7. **Component patterns** — Examine 2-3 existing components to understand:
   - Naming conventions (PascalCase, kebab-case)
   - Directory structure
   - Styling approach used in practice
8. **Design system rules** — Check for design system rules in `CLAUDE.md`, `.cursor/rules`, or other agent configuration files (the `create-design-system-rules` skill generates these)

### Context Summary

After scanning, internally classify the project into one of three tiers:

| Tier | Condition | Behavior |
|------|-----------|----------|
| **Tier 1: Greenfield** | No framework, no component library, no design tokens (standalone HTML, one-off artifact, new project) | Full creative freedom — proceed to Step 2 Path B |
| **Tier 2: Framework present** | Framework and/or CSS framework detected, but no established design system or component library | Use framework idioms, express creativity through theming, layout, and composition |
| **Tier 3: Design system present** | Component library + design tokens + established patterns detected | Strict adherence to existing system; creativity through composition, motion, and micro-interactions only |

**State your findings before proceeding.** Example: "Detected: Vue 3 + PrimeVue + Tailwind CSS with custom theme. Tier 3 — I will use PrimeVue components and existing design tokens."

## Step 2: Design Thinking

### Path A: Design Within an Existing System (Tier 2 & 3)

When an existing design system or framework is detected, creative expression is channeled — not suppressed.

**Hard constraints (NEVER violate):**
- NEVER import fonts that are not already in the project's font stack
- NEVER override existing design tokens (CSS variables, Tailwind theme values, SCSS variables)
- NEVER create components that duplicate existing library components (if the library has a Button, use it)
- NEVER introduce a CSS methodology that differs from the project's approach (if the project uses Tailwind, use Tailwind — not inline styles or CSS Modules)
- NEVER add external CDN links for styling resources not already used

**Creative layer (WHERE distinctiveness lives):**
- **Spatial composition** — Unexpected layouts using the existing grid system: asymmetric arrangements, dramatic whitespace, overlapping sections, diagonal flow, grid-breaking hero areas
- **Motion and animation** — Staggered reveals, scroll-triggered transitions, hover state choreography, page load orchestration. Use the project's animation approach (CSS transitions, Motion library, GSAP — whatever is already installed or appropriate for the framework)
- **Content hierarchy** — Dramatic size contrasts within the existing type scale, bold use of font weight variations, creative letter-spacing, text-transform as a design tool
- **Color accent strategy** — Within the existing palette, use dominant/accent relationships intentionally. A design system defines colors; this skill decides *how to deploy them* for maximum impact
- **Component composition** — Combine existing primitives in unexpected ways: a DataTable with editorial-quality header treatment, a Card grid with magazine-style layout, a Form with conversational flow
- **Micro-interactions** — Purposeful feedback on every interactive element: button press effects, input focus animations, loading state choreography, success/error transitions
- **Whitespace as design** — Generous padding, breathing room between sections, whitespace that creates visual rhythm

**Think like a designer at a company with an established brand:** you don't replace the brand typeface — you create distinction through *how you compose* the existing elements.

### Path B: Design From Scratch (Tier 1 — Greenfield)

When no existing system is detected, commit to a BOLD aesthetic direction:

- **Purpose**: What problem does this interface solve? Who uses it?
- **Tone**: Pick a clear aesthetic direction:
  - Brutally minimal
  - Maximalist chaos
  - Retro-futuristic
  - Organic/natural
  - Luxury/refined
  - Playful/toy-like
  - Editorial/magazine
  - Brutalist/raw
  - Art deco/geometric
  - Soft/pastel
  - Industrial/utilitarian

  Use these for inspiration but design one that is true to the aesthetic direction.

- **Differentiation**: What makes this UNFORGETTABLE? What's the one thing someone will remember?

**CRITICAL**: Choose a clear conceptual direction and execute it with precision. Bold maximalism and refined minimalism both work — the key is intentionality, not intensity.

## Implementation Standards

### For All Tiers

Implement working code that is:
- Production-grade and functional
- Cohesive with a clear visual point-of-view
- Meticulously refined in every detail
- Accessible (proper contrast ratios, semantic HTML, keyboard navigation)

### For Tier 2 & 3 (Existing System)

- Use the project's existing component library as the primary building block
- Follow the project's file naming and directory conventions
- Use the project's CSS methodology exclusively
- Extend, don't replace: if you need a variant, extend the existing token system rather than hardcoding values
- If a component you need doesn't exist in the library, build it following the library's patterns and conventions

### For Tier 1 (Greenfield)

- Choose fonts that are beautiful, unique, and interesting
- Define a cohesive color system using CSS variables
- Create a clear spacing scale
- Establish consistent component patterns
- Consider suggesting the `create-design-system-rules` skill to formalize the system

## Frontend Aesthetics Guidelines

### Typography

**Tier 2 & 3:** Use the project's established font stack. Create distinction through:
- Dramatic size contrasts (within the existing type scale)
- Variable font weight usage (if the project uses variable fonts)
- Creative letter-spacing and text-transform
- Line-height adjustments for visual rhythm
- If the project uses Inter, make Inter look *incredible* — font choice is not the only lever

**Tier 1 (Greenfield):**
- Choose fonts that are beautiful, unique, and interesting
- Avoid generic fonts like Arial and system defaults
- Pair a distinctive display font with a refined body font
- NEVER converge on overused choices (Space Grotesk, Inter, Roboto)

### Color & Theme

**Tier 2 & 3:** Work within the existing palette:
- Use dominant/accent relationships with intention
- Explore the full range of the existing palette (projects often have colors defined but underused)
- Use opacity and transparency variations of existing colors for depth
- Dark/light mode: follow the project's approach

**Tier 1 (Greenfield):**
- Commit to a cohesive aesthetic
- Use CSS variables for consistency
- Dominant colors with sharp accents outperform timid, evenly-distributed palettes
- Vary between light and dark themes

### Motion & Animation

**All Tiers (this is where distinctiveness thrives regardless of design system):**
- Use animations for effects and micro-interactions
- Focus on high-impact moments: page load reveals with staggered animation-delay
- Scroll-triggered animations and surprising hover states
- Purposeful transitions on state changes (loading, success, error)
- Use the project's preferred animation approach (CSS, Motion, GSAP, or framework-native)
- Prioritize CSS-only solutions for simple transitions

### Spatial Composition

**All Tiers (composition creativity works within any system):**
- Unexpected layouts (even with standard components)
- Asymmetric arrangements of symmetric components
- Overlapping elements for depth
- Grid-breaking hero sections
- Generous negative space OR controlled density — both are valid
- Diagonal flow and visual rhythm

### Backgrounds & Visual Details

**Tier 2 & 3:** Create atmosphere using the existing design language:
- Subtle gradients using existing palette colors
- Background patterns built from the existing token system
- Layered transparencies with existing colors
- Shadows that match the project's elevation system

**Tier 1 (Greenfield):**
- Gradient meshes
- Noise textures
- Geometric patterns
- Layered transparencies
- Dramatic shadows
- Decorative borders
- Custom cursors
- Grain overlays

## What to AVOID

### Always Avoid (All Tiers)
- Cookie-cutter layouts with no visual rhythm
- Identical components stacked without variation
- Animations that are purely decorative without purpose
- Accessibility violations (poor contrast, missing labels, no keyboard support)

### Tier 2 & 3: Avoid Breaking the System
- Overriding design tokens with hardcoded values
- Importing fonts not in the project's font stack
- Creating one-off components that duplicate library components
- Using a different CSS methodology than the project's
- Introducing external dependencies without checking the project's approach
- Ignoring existing component APIs and patterns

### Tier 1 (Greenfield): Avoid Generic AI Aesthetics
- Overused font families (Inter, Roboto, Arial, system fonts, Space Grotesk)
- Cliched color schemes (particularly purple gradients on white backgrounds)
- Predictable layouts and component patterns
- Generic styling that lacks context-specific character

## Design Variation

- No two designs should look the same
- Even within a design system, vary *how* components are composed across different pages
- Apply different spatial compositions to different sections
- Interpret requirements creatively — a dashboard can be editorial, a form can be conversational, a settings page can be elegant
- The constraint of a design system should inspire more creativity, not less

## Complementary Skills

- **create-design-system-rules** — If no design system is detected (Tier 1), suggest running this skill first to establish one. If design system rules already exist, consume and obey them.
- **react-best-practices** / **vue-best-practices** — Defer to these for framework idioms and component API patterns. This skill focuses on visual creativity, not framework best practices.
- **web-design-guidelines** — Use for auditing and reviewing existing interfaces against quality standards.

## Remember

First, understand your room. Then, be the most creative person in that room — but do not repaint the walls if someone already chose the color.

In a greenfield project: don't hold back. Create extraordinary, distinctive work.
In an existing project: create extraordinary work *within* the system. A PrimeVue dashboard can be breathtaking. A shadcn/ui page can be unforgettable. The design system is not a prison — it is a creative brief.
