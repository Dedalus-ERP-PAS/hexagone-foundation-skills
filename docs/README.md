# Documentation Foundation Skills

Index de la documentation disponible pour les Foundation Skills.

## Guides generaux

| Document                                   | Description                                                                               |
| ------------------------------------------ | ----------------------------------------------------------------------------------------- |
| [comment-utiliser.md](comment-utiliser.md) | **Guide complet** - Installation, utilisation avec differents agents, exemples, depannage |
| [coding-standards.md](coding-standards.md) | Standards de code universels pour TypeScript/JavaScript                                   |

## Documentation par skill

### Backend & APIs

| Skill                                   | Documentation                                                  |
| --------------------------------------- | -------------------------------------------------------------- |
| [backend-patterns](backend-patterns.md) | Patterns d'architecture backend, API design, DB, caching, auth |
| [postgres](postgres.md)                 | Requetes SQL lecture seule sur PostgreSQL                      |

### Frontend

| Skill                                             | Documentation                             |
| ------------------------------------------------- | ----------------------------------------- |
| [react-best-practices](react-best-practices.md)   | Guidelines performance React/Next.js      |
| [vue-best-practices](vue-best-practices.md)       | Best practices Vue.js 3/Nuxt              |
| [frontend-design](frontend-design.md)             | Interfaces frontend de qualite production |
| [web-design-guidelines](web-design-guidelines.md) | Audit UI, accessibilite et UX             |

### Securite & Qualite

| Skill                                             | Documentation                                 |
| ------------------------------------------------- | --------------------------------------------- |
| [security-review](security-review.md)             | Audit de securite et OWASP Top 10             |
| [coding-standards](coding-standards.md)           | Standards de code                             |
| [tdd](tdd.md)                                     | Developpement pilote par les tests (TDD)      |
| [testing-patterns](testing-patterns.md)           | Patterns de test : unitaire, integration, E2E |
| [typescript-migration](typescript-migration.md)   | Migration incrementale JS vers TypeScript     |
| [git-guardrails](git-guardrails.md)               | Garde-fous Git pour des commits propres       |

### Automatisation & Tests

| Skill                                   | Documentation                             |
| --------------------------------------- | ----------------------------------------- |
| [playwright-skill](playwright-skill.md) | Automatisation navigateur avec Playwright |

### Documents Office

| Skill            | Documentation                    |
| ---------------- | -------------------------------- |
| [docx](docx.md) | Documents Word (.docx)           |
| [pptx](pptx.md) | Presentations PowerPoint (.pptx) |
| [xlsx](xlsx.md) | Fichiers Excel avec formules     |
| [pdf](pdf.md)   | Manipulation de PDF              |

### Gestion de projet

| Skill                                         | Documentation                                                 |
| --------------------------------------------- | ------------------------------------------------------------- |
| [github-issues](github-issues.md)             | Gestion des issues GitHub                                     |
| [gitlab-issue](gitlab-issue.md)               | Gestion des issues GitLab                                     |
| [gitlab-code-review](gitlab-code-review.md)   | Code review GitLab                                            |
| [changelog-generator](changelog-generator.md) | Generation de changelogs                                      |
| [grill-me](grill-me.md)                       | Interview approfondie pour validation de plans et conceptions |
| [triage-issue](triage-issue.md)               | Triage de bugs avec plan de fix TDD                           |
| [meeting](meeting.md)                         | Reunion simulee avec personas experts                         |
| [fast-meeting](fast-meeting.md)               | Reunion autonome rapide avec decision et MR/PR                |

### Hexagone / Domaine sante

| Skill                                       | Documentation                                                          |
| ------------------------------------------- | ---------------------------------------------------------------------- |
| [hexagone-swdoc](hexagone-swdoc.md)         | Documentation des web services Hexagone (endpoints, formats, contrats) |
| [hexagone-frontend](hexagone-frontend.md)   | Documentation des composants frontend Hexagone (@his/hexa-components)  |
| [hexagone-web-feature-extractor](hexagone-web-feature-extractor.md) | Exploration et capture d'un espace Hexagone Web en document Word PO |
| [hpk-parser](hpk-parser.md)                 | Parsing des messages HPK proprietaires                                 |
| [hl7-pam-parser](hl7-pam-parser.md)         | Parsing des messages HL7 v2.5 IHE PAM                                  |
| [uniface-procscript](uniface-procscript.md) | Reference ProcScript pour Uniface 9.7                                  |

### Outils specialises

| Skill                                                       | Documentation                                     |
| ----------------------------------------------------------- | ------------------------------------------------- |
| [mcp-builder](mcp-builder.md)                               | Creation de serveurs MCP                           |
| [article-extractor](article-extractor.md)                   | Extraction d'articles web                          |
| [create-design-system-rules](create-design-system-rules.md) | Generation de regles de design system              |
| [docs](docs.md)                                             | Generation de README et documentation projet       |
| [write-a-skill](write-a-skill.md)                           | Guide pour creer un nouveau skill                  |
| [ubiquitous-language](ubiquitous-language.md)                | Extraction de glossaire DDD (langage ubiquitaire)  |

## Demarrage rapide

### 1. Installation

```bash
# Tous les skills
npx skills add Dedalus-ERP-PAS/foundation-skills -g -y

# Skill specifique
npx skills add Dedalus-ERP-PAS/foundation-skills --skill backend-patterns -g -y
```

### 2. Utilisation de base

```
# Dans GitHub Copilot, Claude, Cursor ou Windsurf
@workspace avec backend-patterns, cree une API REST pour les users
```

### 3. Consulter le guide complet

Voir le [guide complet d'utilisation](comment-utiliser.md).

## Bonnes pratiques

- **Mentionner explicitement le skill** dans vos prompts
- **Combiner plusieurs skills** pour des taches complexes
- **Commencer simple** puis iterer
- **Consulter la doc** du skill avant utilisation

## Support

- Issues : [foundation-skills/issues](https://github.com/Dedalus-ERP-PAS/foundation-skills/issues)
- Guide : [comment-utiliser.md](comment-utiliser.md)
- Standard : [agentskills.io](https://agentskills.io)

## Licence

MIT
