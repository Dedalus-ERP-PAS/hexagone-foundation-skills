# CLAUDE.md — Foundation Skills

## Project Overview

Foundation Skills is a centralized repository of AI agent skills for Dedalus ERP-PAS development teams. Skills are Markdown-based instructions (SKILL.md files) that AI agents (GitHub Copilot, Claude Code, Cursor, Windsurf) load dynamically to perform specialized tasks reproducibly. The project follows the open [Agent Skills](https://agentskills.io) standard.

## Tech Stack

- **Format:** Markdown (SKILL.md), Agent Skills standard
- **Distribution:** GitHub + `npx skills` CLI
- **License:** MIT

## Project Structure

```
foundation-skills/
├── skills/              # All skill definitions (one directory per skill)
│   ├── <skill-name>/
│   │   ├── SKILL.md     # Main skill definition file
│   │   └── reference/   # Optional reference materials
├── docs/                # Documentation for each skill + guides
│   ├── README.md        # Documentation index
│   ├── comment-utiliser.md  # Installation & usage guide
│   └── <skill-name>.md # One doc per skill
├── README.md            # Project README (French, PO-oriented)
└── LICENSE              # MIT License
```

## Key Directories

- `skills/` — Contains 24 skill directories, each with a `SKILL.md` file defining the skill's instructions
- `docs/` — Contains documentation files: one per skill plus general guides (healthcare parsers, installation, etc.)

## Skill Categories

1. **Development skills:** coding-standards, backend-patterns, react-best-practices, vue-best-practices, frontend-design, web-design-guidelines, create-design-system-rules, mcp-builder, playwright-skill, postgres, security-review
2. **Healthcare parsers:** hpk-parser, hl7-pam-parser (domain-specific message formats)
3. **Issue/review management:** gitlab-code-review, gitlab-issue, github-issues
4. **Document processing:** docx, pdf, pptx, xlsx, article-extractor
5. **Utilities:** changelog-generator, toxic-manager-translator, readme

## Conventions

- Each skill lives in its own directory under `skills/`
- The main instruction file is always named `SKILL.md`
- Reference materials go in a `reference/` subdirectory
- Documentation in `docs/` mirrors skill names (e.g., `skills/postgres/` → `docs/postgres.md`)
- README and docs are written in French
- SKILL.md files are written in English (they are instructions for AI agents)

## Useful Commands

```bash
# Install skills in a project
npx skills add Dedalus-ERP-PAS/foundation-skills -g -y
```

## Git Workflow

- Main branch: `main`
- Remote: `https://github.com/Dedalus-ERP-PAS/foundation-skills.git`
- Commit messages: conventional commits style (`feat(scope): description`)

## Patterns to Follow

- When adding a new skill: create `skills/<name>/SKILL.md` and `docs/<name>.md`
- Update the skills table in `README.md` when adding/removing skills
- Keep SKILL.md files focused on actionable instructions for AI agents
- Documentation files in `docs/` should be concise guides explaining the skill's purpose and usage
