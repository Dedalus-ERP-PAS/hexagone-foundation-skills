# Documentation Foundation Skills

Index de la documentation disponible pour les Foundation Skills.

## Guides généraux

| Document                                   | Description                                                                                |
| ------------------------------------------ | ------------------------------------------------------------------------------------------ |
| [comment-utiliser.md](comment-utiliser.md) | **Guide complet** — Installation, utilisation avec différents agents, exemples, dépannage |
| [coding-standards.md](coding-standards.md) | Standards de code universels pour TypeScript/JavaScript                                    |

## Documentation par skill

### Backend & APIs

| Skill                                   | Documentation                                                  |
| --------------------------------------- | -------------------------------------------------------------- |
| [backend-patterns](backend-patterns.md) | Patterns d'architecture backend, API design, DB, caching, auth |
| [postgres](postgres.md)                 | Requêtes SQL lecture seule sur PostgreSQL                      |

### Frontend

| Skill                                             | Documentation                           |
| ------------------------------------------------- | --------------------------------------- |
| [react-best-practices](react-best-practices.md)   | Guidelines performance React/Next.js    |
| [vue-best-practices](vue-best-practices.md)       | Best practices Vue.js 3/Nuxt            |
| [design-compliance](design-compliance.md)         | Audit de conformité au design system Hexagone |

### Sécurité & Qualité

| Skill                                           | Documentation                                  |
| ----------------------------------------------- | ---------------------------------------------- |
| [security-review](security-review.md)           | Audit de sécurité et OWASP Top 10              |
| [coding-standards](coding-standards.md)         | Standards de code                              |
| [tdd](tdd.md)                                   | Développement piloté par les tests (TDD)       |
| [testing-patterns](testing-patterns.md)         | Patterns de test : unitaire, intégration, E2E  |
| [typescript-migration](typescript-migration.md) | Migration incrémentale JS vers TypeScript      |
| [git-guardrails](git-guardrails.md)             | Garde-fous Git pour des commits propres        |

### Automatisation & Tests

| Skill                                   | Documentation                             |
| --------------------------------------- | ----------------------------------------- |
| [playwright-skill](playwright-skill.md) | Automatisation navigateur avec Playwright |

### Documents Office

| Skill            | Documentation                     |
| ---------------- | --------------------------------- |
| [docx](docx.md)  | Documents Word (.docx)            |
| [pptx](pptx.md)  | Présentations PowerPoint (.pptx)  |
| [xlsx](xlsx.md)  | Fichiers Excel avec formules      |
| [pdf](pdf.md)    | Manipulation de PDF               |

### Gestion de projet

| Skill                                         | Documentation                                                 |
| --------------------------------------------- | ------------------------------------------------------------- |
| [github-issues](github-issues.md)             | Gestion des issues GitHub                                     |
| [gitlab-issue](gitlab-issue.md)               | Gestion des issues GitLab                                     |
| [code-review](code-review.md)                 | Code review des merge requests                                |
| [issue-review](issue-review.md)               | Revue autonome d'issues par personas IA                       |
| [changelog-generator](changelog-generator.md) | Génération de changelogs                                      |
| [grill-me](grill-me.md)                       | Interview approfondie pour validation de plans et conceptions |
| [triage-issue](triage-issue.md)               | Triage de bugs avec plan de fix TDD                           |
| [meeting](meeting.md)                         | Réunion simulée avec personas experts                         |
| [fast-meeting](fast-meeting.md)               | Réunion autonome rapide avec décision et MR/PR                |

### Hexagone / Domaine santé

| Skill                                                               | Documentation                                                          |
| ------------------------------------------------------------------- | ---------------------------------------------------------------------- |
| [hexagone-swdoc](hexagone-swdoc.md)                                 | Documentation des web services Hexagone (endpoints, formats, contrats) |
| [hexagone-frontend](hexagone-frontend.md)                           | Documentation des composants frontend Hexagone (@his/hexa-components)  |
| [hexagone-web-feature-extractor](hexagone-web-feature-extractor.md) | Exploration et capture d'un espace Hexagone Web en document Markdown PO |
| [hpk-parser](hpk-parser.md)                                         | Parsing des messages HPK propriétaires                                 |
| [hl7-pam-parser](hl7-pam-parser.md)                                 | Parsing des messages HL7 v2.5 IHE PAM                                  |
| [uniface-procscript](uniface-procscript.md)                         | Référence ProcScript pour Uniface 9.7                                  |

### Outils spécialisés

| Skill                                                       | Documentation                                     |
| ----------------------------------------------------------- | ------------------------------------------------- |
| [mcp-builder](mcp-builder.md)                               | Création de serveurs MCP                          |
| [article-extractor](article-extractor.md)                   | Extraction d'articles web                         |
| [docs](docs.md)                                             | Génération de README et documentation projet      |
| [write-a-skill](write-a-skill.md)                           | Guide pour créer un nouveau skill                 |
| [ubiquitous-language](ubiquitous-language.md)               | Extraction de glossaire DDD (langage ubiquitaire) |

## Démarrage rapide

### 1. Installation

```bash
# Tous les skills
npx skills add Dedalus-ERP-PAS/foundation-skills -g -y

# Skill spécifique
npx skills add Dedalus-ERP-PAS/foundation-skills --skill backend-patterns -g -y
```

### 2. Utilisation de base

```
# Dans GitHub Copilot, Claude, Cursor ou Windsurf
@workspace avec backend-patterns, crée une API REST pour les users
```

### 3. Consulter le guide complet

Voir le [guide complet d'utilisation](comment-utiliser.md).

## Bonnes pratiques

- **Mentionner explicitement le skill** dans vos prompts
- **Combiner plusieurs skills** pour des tâches complexes
- **Commencer simple** puis itérer
- **Consulter la doc** du skill avant utilisation

## Support

- Issues : [foundation-skills/issues](https://github.com/Dedalus-ERP-PAS/foundation-skills/issues)
- Guide : [comment-utiliser.md](comment-utiliser.md)
- Standard : [agentskills.io](https://agentskills.io)

## Licence

MIT
