# Fast Meeting

Réunion rapide et autonome avec personas IA. Analyse, décision, implémentation et création de MR/PR (Merge Request / Pull Request) sans intervention humaine.

## Quand l'utiliser

- Vous voulez une décision ET une implémentation automatique
- Vous faites confiance a l'analyse IA pour une décision technique ou produit
- Vous voulez aller vite : un prompt déclenche analyse, code et MR/PR

## Différence avec meeting

| | meeting | fast-meeting |
|---|---|---|
| **Personas** | Sélection manuelle ou suggérée | Sélection automatique selon le contexte |
| **Tours de réunion** | 3 tours (positions, débat, convergence) | 1 tour + avocat du diable si consensus + synthèse |
| **Validation utilisateur** | Obligatoire avant implémentation | Aucune — tout est automatique |
| **Implémentation** | Après validation explicite | Immédiate après la réunion (avec scope guard) |
| **Tests** | Non inclus | Exécution automatique après implémentation |
| **Working tree** | Non géré | Worktree isolé (aucune modification du répertoire de travail) |
| **MR/PR** | Non incluse | Créée automatiquement (Draft si tests échouent) |
| **Description MR/PR** | N/A | En français, avec analyse complète et résultats de tests |

## Comment l'utiliser

Demandez simplement à votre agent IA de lancer un fast meeting :

```
fast-meeting : est-ce qu'on doit utiliser GraphQL ou REST pour la nouvelle API
```

```
fast-meeting sur l'issue #42 - les notifications ne s'affichent pas
```

```
fast-meeting : refactorer le module d'authentification pour OAuth2
```

## Ce que le skill fait

1. **Comprend le sujet** — Lit le contexte (prompt, issue, code concerné)
2. **Détecte le remote** — GitLab ou GitHub pour la création de MR/PR
3. **Sélectionne 3-4 personas automatiquement** — Selon le domaine du sujet
4. **Anime une réunion rapide** — 1 tour de positions parallèles + synthèse
5. **Vérifie le consensus** — Lance un avocat du diable si toutes les personas sont d'accord
6. **Évalue le périmètre** — Réduit au premier pas critique si le scope est trop large
7. **Protège le working tree** — Implémentation dans un worktree Git isolé
8. **Produit une analyse concise** — Recommandation, risques, plan d'implémentation
9. **Implémente la recommandation** — Code, tests, modifications de fichiers
10. **Exécute les tests** — Lance la suite de tests du projet, tente une correction si échec
11. **Crée une branche, commit et push** — Branche `feat/fm-*`, `fix/fm-*` ou `refactor/fm-*`
12. **Crée la MR/PR** — Description en francais, Draft si les tests echouent
13. **Nettoie le worktree** — Suppression automatique apres execution
14. **Poste sur l'issue** — Si applicable, ajoute un lien vers la MR/PR

## Personas disponibles

| Persona | Rôle | Ce qui compte pour elle |
|---------|------|------------------------|
| SOLID Alex | Ingénieur Backend Senior | Qualité de code, maintenabilité |
| Sprint Zero Sarah | Product Owner (PO) | Valeur utilisateur, rapidité de livraison |
| Paranoid Shug | Ingénieur Sécurité (certifié OWASP -- Open Web Application Security Project) | Surface d'attaque, sécurité web |
| Pipeline Mo | Ingénieur DevOps / SRE (Site Reliability Engineer) | Opérabilité, déploiement, scalabilité |
| Pixel-Perfect Hugo | Ingénieur Frontend | Expérience utilisateur, Vue.js, React, PrimeVue |
| Whiteboard Damien | Tech Lead / Architecte | Vision long terme, capacité de l'équipe |
| Edge-Case Nico | Ingénieur QA (Quality Assurance) | Testabilité, cas limites, Playwright, Vitest |
| EXPLAIN PLAN Isabelle | Ingénieure Base de Données Senior (Oracle) | Administration Oracle, PL/SQL, tuning |
| Schema JB | Ingénieur Data | Intégrité des données, migrations |
| RFC Santiago | PO Interopérabilité Senior | Standards HL7, FHIR, HPK |
| Legacy Larry | Développeur Fullstack Senior (Uniface) | Modernisation legacy, patterns 4GL/RAD |
| HL7 Victor | Développeur Fullstack Interopérabilité Senior | Intégration bout-en-bout, parsing de messages |
| RGPD Raphaël | DPO (Data Protection Officer) / Compliance | RGPD (Reg. Generale Protection Donnees), HDS (Hebergement Donnees de Sante), consentement |
| Dr. Workflow Wendy | Experte Domaine Santé | Workflows hospitaliers, administration patient |
| Figma Fiona | Designer UX/UI | Recherche utilisateur, tokens de design, WCAG (Web Content Accessibility Guidelines) |

La sélection est automatique selon le contexte. Des personas spécialisées sont créées si le sujet le nécessite.

## Garde-fous

| Protection | Comportement |
|---|---|
| **Working tree sale** | Worktree isolé — le répertoire de travail n'est jamais modifié |
| **Consensus trop facile** | Lancement d'un avocat du diable si toutes les personas sont d'accord |
| **Scope trop large** | Réduction au premier pas critique, ou abandon + suggestion de `/meeting` |
| **Tests en échec** | Une tentative de correction, puis MR/PR en Draft avec détails des échecs |
| **Exécutions parallèles** | Step 0 vérifie les processus actifs avant de nettoyer — pas de risque de supprimer un worktree en cours d'utilisation |

## Exemple de résultat

Le skill produit :
- Une **analyse affichée** dans la conversation (question, participants, recommandation, risques)
- Une **branche** `feat/fm-<sujet>`, `fix/fm-<sujet>` ou `refactor/fm-<sujet>` avec le code implémenté
- Une **MR/PR** avec description technique orientée développeur (changements fichier par fichier, justifications techniques, points d'attention pour la revue)
- Un **commentaire sur l'issue** (si applicable) orienté Product Owner / consultant (valeur métier, impact utilisateur, risques projet) avec lien vers la MR/PR
