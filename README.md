# Foundation Skills

Bibliothèque centralisée de skills pour assistants IA de développement, destinée aux équipes ERP-PAS de Dedalus.

## Table des matières

- [A quoi sert ce produit ?](#a-quoi-sert-ce-produit-)
- [Fonctionnalités principales](#fonctionnalités-principales)
- [Comment ça fonctionne](#comment-ça-fonctionne)
- [Environnements](#environnements)
- [Stack technique](#stack-technique)
- [Skills disponibles](#skills-disponibles)
- [Documentation complémentaire](#documentation-complémentaire)

### Documentation technique

| Document | Description |
|----------|-------------|
| [Guide d'utilisation](docs/comment-utiliser.md) | Guide complet d'installation et d'utilisation des skills avec différents agents IA |
| [Index documentation](docs/README.md) | Index de la documentation avec liste des guides et skills disponibles |
| [Guide parseurs santé](docs/healthcare-parsers-guide.md) | Guide complet pour parser les messages HPK et HL7 PAM dans les systèmes hospitaliers |
| [Spécification HPK/GEF](docs/specification-hpk-gef.md) | Référentiel technique des messages de gestion économique et financière HPK/GEF |
| [Messages HPK ADT](docs/hpk-adt-message.md) | Spécification technique des messages de gestion économique au format HPK |
| [Parseur HPK](docs/hpk-parser.md) | Parsing et explication des messages HPK propriétaires au format délimité par pipes |
| [Parseur HL7 PAM](docs/hl7-pam-parser.md) | Parsing et explication des messages HL7 v2.5 IHE PAM d'administration des patients |
| [Backend patterns](docs/backend-patterns.md) | Patterns d'architecture backend (Repository, Service Layer) et optimisations API |
| [Coding standards](docs/coding-standards.md) | Standards de code universels pour TypeScript, JavaScript, React et Node.js |
| [React best practices](docs/react-best-practices.md) | Guide des best practices React et Next.js (architecture, performance, shadcn/ui) |
| [Vue best practices](docs/vue-best-practices.md) | Best practices Vue.js 3 et Nuxt avec Composition API et patterns d'organisation |
| [Frontend design](docs/frontend-design.md) | Création d'interfaces web distinctives et professionnelles |
| [Web design guidelines](docs/web-design-guidelines.md) | Audit et revue de code UI pour conformité aux guidelines web |
| [Design system rules](docs/create-design-system-rules.md) | Génération de règles de design system pour workflows Figma-to-code |
| [MCP builder](docs/mcp-builder.md) | Guide pour créer des serveurs MCP (Model Context Protocol) en TypeScript ou Python |
| [Playwright skill](docs/playwright-skill.md) | Tests et automatisation web complète avec Playwright |
| [PostgreSQL](docs/postgres.md) | Exécution de requêtes SQL en lecture seule sur PostgreSQL |
| [GitLab code review](docs/gitlab-code-review.md) | Revue de code des merge requests GitLab avec analyse qualité et sécurité |
| [GitLab issue](docs/gitlab-issue.md) | Création et gestion d'issues GitLab sur instance auto-hébergée |
| [GitHub issues](docs/github-issues.md) | Création et gestion d'issues GitHub avec workflows structurés |
| [Security review](docs/security-review.md) | Audit de sécurité couvrant authentification, injection SQL, secrets et CSRF |
| [Article extractor](docs/article-extractor.md) | Extraction du contenu propre d'articles web sans publicités |
| [Changelog generator](docs/changelog-generator.md) | Génération automatique de changelogs à partir de l'historique git |
| [Documents Word](docs/docx.md) | Manipulation et génération de documents Word (.docx) |
| [PDF](docs/pdf.md) | Manipulation de fichiers PDF (extraction de texte, tableaux et création) |
| [PowerPoint](docs/pptx.md) | Manipulation de présentations PowerPoint (lecture, création et modification) |
| [Excel](docs/xlsx.md) | Manipulation de fichiers Excel (création, lecture et formatage) |
| [Toxic manager translator](docs/toxic-manager-translator.md) | Transformation de messages émotionnels en réponses professionnelles |
| [README generator](docs/readme.md) | Génération automatique de README.md en français orienté Product Owner |
| [Meeting personas](docs/meeting-personas.md) | Simulation de réunion avec personas pour analyser un sujet et converger vers une décision |

## A quoi sert ce produit ?

- Fournir aux équipes des instructions IA réutilisables pour des tâches de développement courantes
- Garantir des pratiques de code homogènes grâce à des skills standardisés
- Accélérer le développement en automatisant les tâches répétitives (revue de code, changelogs, documentation)
- Parser et interpréter les messages de santé HPK et HL7 PAM propres au domaine hospitalier
- Créer et manipuler des documents bureautiques (Word, Excel, PowerPoint, PDF) de manière programmatique

## Fonctionnalités principales

- **Skills de développement** — Standards de code, patterns backend, best practices React et Vue.js
- **Revue de code automatisée** — Analyse qualité, sécurité et performance des merge requests GitLab
- **Parseurs de messages de santé** — Interprétation des formats HPK et HL7 PAM utilisés en milieu hospitalier
- **Gestion d'issues** — Création et suivi d'issues GitHub et GitLab avec contexte enrichi
- **Manipulation de documents** — Création et édition de fichiers Word, Excel, PowerPoint et PDF
- **Tests et automatisation web** — Tests fonctionnels et visuels avec Playwright
- **Audit de sécurité** — Détection des vulnérabilités OWASP Top 10 dans le code
- **Génération de changelogs** — Notes de version automatiques à partir de l'historique git

## Comment ça fonctionne

```mermaid
graph LR
    A[Développeur] -->|Installe les skills| B[CLI add-skill]
    B -->|Copie dans le projet| C[Répertoire .skills/]
    C -->|Chargement dynamique| D[Agent IA]
    D -->|Exécute les instructions| E[Tâche réalisée]
```

Le développeur installe les skills via la commande `npx add-skill`. Les fichiers sont copiés dans le projet local. L'agent IA (Copilot, Claude, Cursor) charge dynamiquement les skills nécessaires et exécute les instructions pour réaliser la tâche demandée.

## Environnements

| Environnement | URL | Description |
|---------------|-----|-------------|
| Dépôt GitHub | `https://github.com/Dedalus-ERP-PAS/foundation-skills` | Code source et releases |
| Installation locale | `npx add-skill Dedalus-ERP-PAS/foundation-skills -g -y` | Installation dans le projet |

## Stack technique

- **Format :** Markdown (SKILL.md), suivant le standard ouvert [Agent Skills](https://agentskills.io)
- **Distribution :** GitHub + CLI [add-skill](https://github.com/vercel-labs/add-skill)
- **Agents compatibles :** GitHub Copilot, Claude Code, Cursor, Windsurf
- **Licence :** MIT

## Skills disponibles

### Skills de développement

| Skill | Description | Documentation |
|-------|-------------|---------------|
| **backend-patterns** | Patterns d'architecture backend : API RESTful, repository pattern, optimisation DB, caching | [backend-patterns.md](docs/backend-patterns.md) |
| **changelog-generator** | Génération automatique de changelogs à partir de l'historique git | [changelog-generator.md](docs/changelog-generator.md) |
| **coding-standards** | Standards de code universels : conventions de nommage, principes SOLID, TypeScript/JavaScript | [coding-standards.md](docs/coding-standards.md) |
| **create-design-system-rules** | Règles de design system pour workflows Figma-to-code | [create-design-system-rules.md](docs/create-design-system-rules.md) |
| **frontend-design** | Interfaces frontend de qualité production avec direction esthétique audacieuse | [frontend-design.md](docs/frontend-design.md) |
| **github-issues** | Gestion complète des issues GitHub : création, recherche, mise à jour et commentaires | [github-issues.md](docs/github-issues.md) |
| **gitlab-code-review** | Revue de code des merge requests GitLab : qualité, sécurité, performance | [gitlab-code-review.md](docs/gitlab-code-review.md) |
| **meeting-personas** | Réunion simulée avec personas pour analyser un sujet et décider avant d'implémenter | [meeting-personas.md](docs/meeting-personas.md) |
| **gitlab-issue** | Gestion des issues GitLab sur instances auto-hébergées | [gitlab-issue.md](docs/gitlab-issue.md) |
| **hl7-pam-parser** | Parsing des messages HL7 v2.5 IHE PAM d'administration des patients | [hl7-pam-parser.md](docs/hl7-pam-parser.md) |
| **hpk-parser** | Parsing des messages HPK propriétaires (identité, mouvements, couverture) | [hpk-parser.md](docs/hpk-parser.md) |
| **mcp-builder** | Guide pour créer des serveurs MCP en Python (FastMCP) ou TypeScript (MCP SDK) | [mcp-builder.md](docs/mcp-builder.md) |
| **playwright-skill** | Tests et automatisation web avec Playwright : screenshots, validation UX, tests responsifs | [playwright-skill.md](docs/playwright-skill.md) |
| **postgres** | Requêtes SQL lecture seule sur PostgreSQL avec support multi-bases | [postgres.md](docs/postgres.md) |
| **react-best-practices** | Best practices React/Next.js : architecture, performance, shadcn/ui, React 19+ | [react-best-practices.md](docs/react-best-practices.md) |
| **security-review** | Audit de sécurité : secrets, validation inputs, authentification, OWASP Top 10 | [security-review.md](docs/security-review.md) |
| **vue-best-practices** | Best practices Vue.js 3/Nuxt : Composition API, réactivité, Tailwind CSS, PrimeVue | [vue-best-practices.md](docs/vue-best-practices.md) |
| **web-design-guidelines** | Audit UI/UX : conformité Web Interface Guidelines, accessibilité | [web-design-guidelines.md](docs/web-design-guidelines.md) |

### Skills de traitement de contenu et documents

| Skill | Description | Documentation |
|-------|-------------|---------------|
| **article-extractor** | Extraction du contenu d'articles web en texte propre, sans publicités | [article-extractor.md](docs/article-extractor.md) |
| **docx** | Création, édition et analyse de documents Word (.docx) avec tracked changes | [docx.md](docs/docx.md) |
| **pdf** | Manipulation de PDF : extraction de texte/tables, création, fusion, formulaires | [pdf.md](docs/pdf.md) |
| **pptx** | Création, édition et analyse de présentations PowerPoint (.pptx) | [pptx.md](docs/pptx.md) |
| **readme** | Génération de README.md en français orienté Product Owner avec diagrammes Mermaid | [readme.md](docs/readme.md) |
| **toxic-manager-translator** | Transformation de messages émotionnels en réponses professionnelles et stratégiques | [toxic-manager-translator.md](docs/toxic-manager-translator.md) |
| **xlsx** | Création, édition et analyse de fichiers Excel (.xlsx) avec formules et formatage | [xlsx.md](docs/xlsx.md) |

## Ressources

- **[Guide complet d'utilisation](docs/comment-utiliser.md)** — Documentation détaillée sur l'installation et l'utilisation
- [Agent Skills](https://agentskills.io) — Standard ouvert pour les skills d'agents IA
- [add-skill CLI](https://github.com/vercel-labs/add-skill) — Outil d'installation des skills

## Licence

MIT
