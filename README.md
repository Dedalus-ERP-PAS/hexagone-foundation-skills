# Foundation Skills

Bibliothèque centralisée de skills pour assistants IA de développement, destinée aux équipes ERP-PAS de Dedalus.

## Installation rapide

```bash
# Installer tous les skills (global, disponible dans tous vos projets)
npx skills add Dedalus-ERP-PAS/foundation-skills -g -y
```

```bash
# Mettre à jour les skills vers la dernière version
npx skills add Dedalus-ERP-PAS/foundation-skills -g -y --update
```

```bash
# Installer uniquement certains skills
npx skills add Dedalus-ERP-PAS/foundation-skills --skill backend-patterns --skill react-best-practices -g -y
```

> **Prérequis :** Node.js 18+ et npm. Activez l'option "Use Agent skills" dans les paramètres de votre IDE.
>
> **Agents compatibles :** GitHub Copilot, Claude Code, Cursor, Windsurf
>
> **Guide complet :** [docs/comment-utiliser.md](docs/comment-utiliser.md) — installation sélective, utilisation par agent, dépannage

## Table des matières

- [Installation rapide](#installation-rapide)
- [A quoi sert ce produit ?](#a-quoi-sert-ce-produit-)
- [Fonctionnalités principales](#fonctionnalités-principales)
- [Comment ça fonctionne](#comment-ça-fonctionne)
- [Environnements](#environnements)
- [Stack technique](#stack-technique)
- [Skills disponibles](#skills-disponibles)
- [Documentation complémentaire](#documentation-complémentaire)

### Documentation technique

| Document                                                                 | Description                                                                                      |
| ------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------ |
| [Guide d'utilisation](docs/comment-utiliser.md)                          | Guide complet d'installation et d'utilisation des skills avec différents agents IA               |
| [Index documentation](docs/README.md)                                    | Index de la documentation avec liste des guides et skills disponibles                            |
| [Guide parseurs santé](docs/healthcare-parsers-guide.md)                 | Guide complet pour parser les messages HPK et HL7 PAM dans les systèmes hospitaliers             |
| [Spécification HPK/GEF](docs/specification-hpk-gef.md)                   | Référentiel technique des messages de gestion économique et financière HPK/GEF                   |
| [Messages HPK ADT](docs/hpk-adt-message.md)                              | Spécification technique des messages de gestion économique au format HPK                         |
| [Parseur HPK](docs/hpk-parser.md)                                        | Parsing et explication des messages HPK propriétaires au format délimité par pipes               |
| [Parseur HL7 PAM](docs/hl7-pam-parser.md)                                | Parsing et explication des messages HL7 v2.5 IHE PAM d'administration des patients               |
| [Backend patterns](docs/backend-patterns.md)                             | Patterns d'architecture backend (Repository, Service Layer) et optimisations API                 |
| [Coding standards](docs/coding-standards.md)                             | Standards de code universels pour TypeScript, JavaScript, React et Node.js                       |
| [React best practices](docs/react-best-practices.md)                     | Guide des best practices React et Next.js (architecture, performance, shadcn/ui)                 |
| [Vue best practices](docs/vue-best-practices.md)                         | Best practices Vue.js 3 et Nuxt avec Composition API et patterns d'organisation                  |
| [Frontend](docs/frontend.md)                                             | Règles de développement frontend natif — respect du framework et du design system                |
| [Web design guidelines](docs/web-design-guidelines.md)                   | Audit et revue de code UI pour conformité aux guidelines web                                     |
| [Design system rules](docs/create-design-system-rules.md)                | Génération de règles de design system pour workflows Figma-to-code                               |
| [MCP builder](docs/mcp-builder.md)                                       | Guide pour créer des serveurs MCP (Model Context Protocol) en TypeScript ou Python               |
| [Playwright skill](docs/playwright-skill.md)                             | Tests et automatisation web complète avec Playwright                                             |
| [PostgreSQL](docs/postgres.md)                                           | Exécution de requêtes SQL en lecture seule sur PostgreSQL                                        |
| [Code review](docs/code-review.md)                                       | Revue de code des merge requests GitLab avec analyse qualité et sécurité                         |
| [Issue review](docs/issue-review.md)                                     | Revue autonome d'issues par personas IA avec publication du rapport sur l'issue                   |
| [GitLab issue](docs/gitlab-issue.md)                                     | Création et gestion d'issues GitLab sur instance auto-hébergée                                   |
| [GitHub issues](docs/github-issues.md)                                   | Création et gestion d'issues GitHub avec workflows structurés                                    |
| [Security review](docs/security-review.md)                               | Audit de sécurité couvrant authentification, injection SQL, secrets et CSRF                      |
| [Article extractor](docs/article-extractor.md)                           | Extraction du contenu propre d'articles web sans publicités                                      |
| [Changelog generator](docs/changelog-generator.md)                       | Génération automatique de changelogs à partir de l'historique git                                |
| [Documents Word](docs/docx.md)                                           | Manipulation et génération de documents Word (.docx)                                             |
| [PDF](docs/pdf.md)                                                       | Manipulation de fichiers PDF (extraction de texte, tableaux et création)                         |
| [PowerPoint](docs/pptx.md)                                               | Manipulation de présentations PowerPoint (lecture, création et modification)                     |
| [Excel](docs/xlsx.md)                                                    | Manipulation de fichiers Excel (création, lecture et formatage)                                  |
| [Docs generator](docs/docs.md)                                           | Génération automatique de README.md et documentation en français orienté Product Owner           |
| [Fast meeting](docs/fast-meeting.md)                                     | Réunion rapide autonome avec personas : analyse, implémentation et création de MR/PR             |
| [Meeting](docs/meeting.md)                                               | Simulation de réunion avec personas pour analyser un sujet et converger vers une décision        |
| [Uniface ProcScript](docs/uniface-procscript.md)                         | Référence complète du langage ProcScript pour Uniface 9.7 (594 entrées de documentation)         |
| [Hexagone Web Services](docs/hexagone-swdoc.md)                          | Documentation des web services Hexagone depuis le dépôt swdoc GitLab                             |
| [Hexagone Frontend](docs/hexagone-frontend.md)                           | Documentation des composants frontend Hexagone (@his/hexa-components)                            |
| [Hexagone Web Feature Extractor](docs/hexagone-web-feature-extractor.md) | Exploration d'un espace Hexagone Web avec capture d'écrans et génération de document Markdown PO |
| [TDD](docs/tdd.md)                                                       | Développement piloté par les tests avec boucle red-green-refactor                                |
| [Testing patterns](docs/testing-patterns.md)                             | Patterns de test : unitaire, intégration, E2E, mocking et organisation                           |
| [TypeScript migration](docs/typescript-migration.md)                     | Guide de migration incrémentale JavaScript vers TypeScript                                       |
| [Triage issue](docs/triage-issue.md)                                     | Investigation de bugs et création automatique d'issues GitLab/GitHub                             |
| [Ubiquitous language](docs/ubiquitous-language.md)                       | Extraction de glossaire DDD adapté au domaine santé                                              |
| [Git guardrails](docs/git-guardrails.md)                                 | Hooks de sécurité pour bloquer les commandes git dangereuses                                     |
| [Write a skill](docs/write-a-skill.md)                                   | Guide de création de nouveaux skills pour le projet                                              |

## A quoi sert ce produit ?

- Fournir aux équipes des instructions IA réutilisables pour des tâches de développement courantes
- Garantir des pratiques de code homogènes grâce à des skills standardisés
- Accélérer le développement en automatisant les tâches répétitives (revue de code, changelogs, documentation)
- Parser et interpréter les messages de santé HPK et HL7 PAM propres au domaine hospitalier
- Créer et manipuler des documents bureautiques (Word, Excel, PowerPoint, PDF) de manière programmatique

## Fonctionnalités principales

- **Skills de développement** — Standards de code, patterns backend, best practices React et Vue.js
- **Revue de code automatisée** — Analyse qualité, sécurité et performance des merge requests GitLab
- **Revue d'issues par personas** — Analyse multi-angle de la faisabilité, complétude et risques avant implémentation
- **Parseurs de messages de santé** — Interprétation des formats HPK et HL7 PAM utilisés en milieu hospitalier
- **Gestion d'issues** — Création et suivi d'issues GitHub et GitLab avec contexte enrichi
- **Manipulation de documents** — Création et édition de fichiers Word, Excel, PowerPoint et PDF
- **Tests et automatisation web** — Tests fonctionnels et visuels avec Playwright
- **Audit de sécurité** — Détection des vulnérabilités OWASP Top 10 dans le code
- **TDD et triage de bugs** — Développement piloté par les tests et investigation structurée de bugs
- **Langage ubiquitaire** — Extraction de glossaires DDD adaptés au domaine santé (HL7, HPK, FHIR)
- **Gardes-fous git** — Hooks de sécurité bloquant les commandes git dangereuses
- **Génération de changelogs** — Notes de version automatiques à partir de l'historique git

## Comment ça fonctionne

```mermaid
graph LR
    A[Développeur] -->|Installe les skills| B[CLI skills]
    B -->|Copie dans le projet| C[Répertoire .skills/]
    C -->|Chargement dynamique| D[Agent IA]
    D -->|Exécute les instructions| E[Tâche réalisée]
```

Le développeur installe les skills via la commande `npx skills add`. Les fichiers sont copiés dans le projet local. L'agent IA (Copilot, Claude, Cursor) charge dynamiquement les skills nécessaires et exécute les instructions pour réaliser la tâche demandée.

## Environnements

| Environnement | URL / Commande                                                    | Description                          |
| ------------- | ----------------------------------------------------------------- | ------------------------------------ |
| Dépôt GitHub  | `https://github.com/Dedalus-ERP-PAS/foundation-skills`            | Code source et releases              |
| Installer     | `npx skills add Dedalus-ERP-PAS/foundation-skills -g -y`          | Installe tous les skills globalement |
| Mettre à jour | `npx skills add Dedalus-ERP-PAS/foundation-skills -g -y --update` | Met à jour vers la dernière version  |
| Lister        | `npx skills add Dedalus-ERP-PAS/foundation-skills --list`         | Liste les skills disponibles         |

## Stack technique

- **Format :** Markdown (SKILL.md), suivant le standard ouvert [Agent Skills](https://agentskills.io)
- **Distribution :** GitHub + CLI [skills](https://github.com/vercel-labs/agent-skills)
- **Agents compatibles :** GitHub Copilot, Claude Code, Cursor, Windsurf
- **Licence :** MIT

## Skills disponibles

### Skills de développement

| Skill                              | Description                                                                                            | Documentation                                                               |
| ---------------------------------- | ------------------------------------------------------------------------------------------------------ | --------------------------------------------------------------------------- |
| **backend-patterns**               | Patterns d'architecture backend : API RESTful, repository pattern, optimisation DB, caching            | [backend-patterns.md](docs/backend-patterns.md)                             |
| **changelog-generator**            | Génération automatique de changelogs à partir de l'historique git                                      | [changelog-generator.md](docs/changelog-generator.md)                       |
| **coding-standards**               | Standards de code universels : conventions de nommage, principes SOLID, TypeScript/JavaScript          | [coding-standards.md](docs/coding-standards.md)                             |
| **create-design-system-rules**     | Règles de design system pour workflows Figma-to-code                                                   | [create-design-system-rules.md](docs/create-design-system-rules.md)         |
| **frontend**                       | Règles de développement frontend natif — respect du framework et du design system                      | [frontend.md](docs/frontend.md)                                             |
| **github-issues**                  | Gestion complète des issues GitHub : création, recherche, mise à jour et commentaires                  | [github-issues.md](docs/github-issues.md)                                   |
| **code-review**                    | Revue de code des merge requests GitLab : qualité, sécurité, performance                               | [code-review.md](docs/code-review.md)                                       |
| **issue-review**                   | Revue autonome d'issues par personas IA : faisabilité, complétude, risques et publication sur l'issue  | [issue-review.md](docs/issue-review.md)                                     |
| **fast-meeting**                   | Réunion rapide autonome : analyse, décision, implémentation et création de MR/PR sans intervention     | [fast-meeting.md](docs/fast-meeting.md)                                     |
| **meeting**                        | Réunion simulée avec personas pour analyser un sujet et décider avant d'implémenter                    | [meeting.md](docs/meeting.md)                                               |
| **gitlab-issue**                   | Gestion des issues GitLab sur instances auto-hébergées                                                 | [gitlab-issue.md](docs/gitlab-issue.md)                                     |
| **grill-me**                       | Interview approfondie pour valider plans et conceptions jusqu'à compréhension partagée                 | [grill-me.md](docs/grill-me.md)                                             |
| **hl7-pam-parser**                 | Parsing des messages HL7 v2.5 IHE PAM d'administration des patients                                    | [hl7-pam-parser.md](docs/hl7-pam-parser.md)                                 |
| **hpk-parser**                     | Parsing des messages HPK propriétaires (identité, mouvements, couverture)                              | [hpk-parser.md](docs/hpk-parser.md)                                         |
| **mcp-builder**                    | Guide pour créer des serveurs MCP en Python (FastMCP) ou TypeScript (MCP SDK)                          | [mcp-builder.md](docs/mcp-builder.md)                                       |
| **playwright-skill**               | Tests et automatisation web avec Playwright : screenshots, validation UX, tests responsifs             | [playwright-skill.md](docs/playwright-skill.md)                             |
| **postgres**                       | Requêtes SQL lecture seule sur PostgreSQL avec support multi-bases                                     | [postgres.md](docs/postgres.md)                                             |
| **react-best-practices**           | Best practices React/Next.js : architecture, performance, shadcn/ui, React 19+                         | [react-best-practices.md](docs/react-best-practices.md)                     |
| **security-review**                | Audit de sécurité : secrets, validation inputs, authentification, OWASP Top 10                         | [security-review.md](docs/security-review.md)                               |
| **vue-best-practices**             | Best practices Vue.js 3/Nuxt : Composition API, réactivité, Tailwind CSS, PrimeVue                     | [vue-best-practices.md](docs/vue-best-practices.md)                         |
| **testing-patterns**               | Patterns de test complets : unitaire, intégration, E2E, mocking, anti-patterns                         | [testing-patterns.md](docs/testing-patterns.md)                             |
| **typescript-migration**           | Migration incrémentale JS → TypeScript : tsconfig, typage, élimination de `any`                        | [typescript-migration.md](docs/typescript-migration.md)                     |
| **web-design-guidelines**          | Audit UI/UX : conformité Web Interface Guidelines, accessibilité                                       | [web-design-guidelines.md](docs/web-design-guidelines.md)                   |
| **hexagone-swdoc**                 | Documentation des web services Hexagone : endpoints, formats, contrats de service                      | [hexagone-swdoc.md](docs/hexagone-swdoc.md)                                 |
| **hexagone-frontend**              | Documentation des composants frontend Hexagone (@his/hexa-components) : props, events, patterns        | [hexagone-frontend.md](docs/hexagone-frontend.md)                           |
| **hexagone-web-feature-extractor** | Exploration d'un espace Hexagone Web : capture d'écrans, description fonctionnelle et document Word PO | [hexagone-web-feature-extractor.md](docs/hexagone-web-feature-extractor.md) |
| **tdd**                            | Développement piloté par les tests : boucle red-green-refactor, vertical slices, tracer bullets        | [tdd.md](docs/tdd.md)                                                       |
| **triage-issue**                   | Investigation de bugs : diagnostic, analyse root cause, plan TDD et création d'issue (GitLab/GitHub)   | [triage-issue.md](docs/triage-issue.md)                                     |
| **ubiquitous-language**            | Extraction de glossaire DDD depuis les conversations, adapté au domaine santé (HL7, HPK, FHIR)         | [ubiquitous-language.md](docs/ubiquitous-language.md)                       |
| **uniface-procscript**             | Référence complète du langage ProcScript pour Uniface 9.7 (594 entrées de documentation)               | [uniface-procscript.md](docs/uniface-procscript.md)                         |
| **git-guardrails**                 | Hooks de sécurité bloquant les commandes git dangereuses (push --force, reset --hard, etc.)            | [git-guardrails.md](docs/git-guardrails.md)                                 |
| **write-a-skill**                  | Méta-skill guidant la création de nouveaux skills avec les conventions du projet                       | [write-a-skill.md](docs/write-a-skill.md)                                   |

### Skills de traitement de contenu et documents

| Skill                 | Description                                                                                        | Documentation                                     |
| --------------------- | -------------------------------------------------------------------------------------------------- | ------------------------------------------------- |
| **article-extractor** | Extraction du contenu d'articles web en texte propre, sans publicités                              | [article-extractor.md](docs/article-extractor.md) |
| **docx**              | Création, édition et analyse de documents Word (.docx) avec tracked changes                        | [docx.md](docs/docx.md)                           |
| **pdf**               | Manipulation de PDF : extraction de texte/tables, création, fusion, formulaires                    | [pdf.md](docs/pdf.md)                             |
| **pptx**              | Création, édition et analyse de présentations PowerPoint (.pptx)                                   | [pptx.md](docs/pptx.md)                           |
| **docs**              | Génération de README.md et documentation en français orienté Product Owner avec diagrammes Mermaid | [docs.md](docs/docs.md)                           |
| **xlsx**              | Création, édition et analyse de fichiers Excel (.xlsx) avec formules et formatage                  | [xlsx.md](docs/xlsx.md)                           |

## Gestion des skills

```bash
# Mettre à jour tous les skills
npx skills add Dedalus-ERP-PAS/foundation-skills -g -y --update

# Lister les skills disponibles
npx skills add Dedalus-ERP-PAS/foundation-skills --list

# Désinstaller un skill
npx skills remove backend-patterns

# Réinstaller en cas de problème
npx skills add Dedalus-ERP-PAS/foundation-skills -g -y --force

# Vérifier l'installation
ls ~/.config/code/skills/    # Skills globaux
ls .skills/                   # Skills locaux au projet
```

Pour plus de détails : [Guide complet d'utilisation](docs/comment-utiliser.md)

## Ressources

- **[Guide complet d'utilisation](docs/comment-utiliser.md)** — Installation, utilisation par agent, dépannage
- [Agent Skills](https://agentskills.io) — Standard ouvert pour les skills d'agents IA
- [skills CLI](https://github.com/vercel-labs/agent-skills) — Outil d'installation des skills

## Licence

MIT
