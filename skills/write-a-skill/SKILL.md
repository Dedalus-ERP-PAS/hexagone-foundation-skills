---
name: write-a-skill
description: "Guide la création d'un nouveau skill d'agent IA pour le dépôt foundation-skills. Génère le squelette du SKILL.md et du fichier docs, applique les conventions du dépôt (frontmatter, versionnage, structure). À utiliser quand l'utilisateur demande de créer un nouveau skill, écrire un skill, ajouter un skill ou générer le squelette d'un skill."
version: 1.0.0
license: MIT
---

# Write a Skill

Create a new skill for the foundation-skills repository following all repo conventions.

## Workflow

### Step 1: Gather requirements

Ask the user:
- What task or domain does the skill cover?
- What specific use cases should it handle?
- What triggers should activate it? (keywords, phrases, file types)
- Any reference materials to include?

### Step 2: Choose a skill name

- Use lowercase kebab-case (e.g., `my-new-skill`)
- Keep it short and descriptive
- Verify the name is not already taken in `skills/`

### Step 3: Create `skills/<name>/SKILL.md`

Start from `skills/_TEMPLATE/SKILL.md` but apply these **mandatory conventions**:

**Frontmatter** (YAML):
```yaml
---
name: <skill-name>
description: <what it does>. Use when <triggers>.
version: 1.0.0
---
```

- `name`, `description`, `version` are required and at **root level** (not nested under `metadata`)
- `description` max 1024 characters. First sentence: what it does. Second sentence: "Use when [triggers]."
- `version` starts at `1.0.0` for new skills
- SKILL.md is written in **English**

**Body rules**:
- Keep SKILL.md **under 100 lines** — concise, actionable instructions only
- Use progressive disclosure: put detailed content in `reference/` files
- Include concrete examples
- No time-sensitive information

### Step 4: Create reference files (if needed)

If content exceeds 100 lines or has distinct domains, split into:
```
skills/<name>/
├── SKILL.md
└── reference/
    ├── detailed-guide.md
    └── examples.md
```

Reference from SKILL.md: `See [detailed guide](reference/detailed-guide.md)`

### Step 5: Create `docs/<name>.md`

Create the matching documentation file **in French**. It must include:
- Title (skill name)
- Description section
- Cas d'usage (use cases)
- Declenchement (triggers)
- Fonctionnement (how it works)
- Exemples (examples in both English and French)
- Version number

See existing files in `docs/` for style reference.

### Step 6: Review checklist

- [ ] `skills/<name>/SKILL.md` exists with valid frontmatter (`name`, `description`, `version` at root)
- [ ] Description includes triggers ("Use when...")
- [ ] Description under 1024 characters
- [ ] SKILL.md under 100 lines
- [ ] SKILL.md written in English
- [ ] `docs/<name>.md` exists, written in French
- [ ] No time-sensitive info, consistent terminology
- [ ] Concrete examples included
- [ ] Reference files only one level deep

## Versioning rules

When modifying an existing skill, bump its `version` field:
- **patch** (1.0.0 -> 1.0.1): typo fixes, wording improvements, minor clarifications
- **minor** (1.0.0 -> 1.1.0): new features, new sections, meaningful behavior changes
- **major** (1.0.0 -> 2.0.0): breaking changes (renamed skill, removed features, restructured workflow)

## Important Notes

- Every skill lives in `skills/<name>/SKILL.md`; documentation in `docs/<name>.md` (in French)
- The `description` field is the **only thing the agent sees** when choosing which skill to load — make it count
- Scripts are discouraged; prefer Markdown instructions. Add scripts only for deterministic operations
