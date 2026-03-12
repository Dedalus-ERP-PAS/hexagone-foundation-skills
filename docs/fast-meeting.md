# Fast Meeting

Réunion rapide et autonome avec personas IA : analyse, décision, implémentation, et création de MR/PR — le tout sans intervention humaine.

## Quand l'utiliser

- Quand vous voulez une décision ET une implémentation automatique sans interruption
- Pour des décisions techniques ou produit où vous faites confiance à l'analyse IA
- Quand vous voulez aller vite : un seul prompt déclenche l'analyse, le code et la MR/PR

## Différence avec meeting

| | meeting | fast-meeting |
|---|---|---|
| **Personas** | Sélection manuelle ou suggérée | Sélection automatique selon le contexte |
| **Tours de réunion** | 3 tours (positions, débat, convergence) | 1 tour + avocat du diable si consensus + synthèse |
| **Validation utilisateur** | Obligatoire avant implémentation | Aucune — tout est automatique |
| **Implémentation** | Après validation explicite | Immédiate après la réunion (avec scope guard) |
| **Tests** | Non inclus | Exécution automatique après implémentation |
| **Working tree** | Non géré | Stash automatique et restauration |
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
5. **Vérifie le consensus** — Si toutes les personas sont d'accord, lance un avocat du diable pour challenger la décision
6. **Évalue le périmètre** — Si le scope est trop large, réduit à la première étape critique ou suggère `/meeting`
7. **Protège le working tree** — Stash automatique des changements non commités avant de créer la branche
8. **Produit une analyse concise** — Recommandation, risques, plan d'implémentation
9. **Implémente la recommandation** — Code, tests, modifications de fichiers
10. **Exécute les tests** — Lance la suite de tests du projet, tente une correction si échec
11. **Crée une branche, commit et push** — Branche `feature/<sujet>`, `fix/<sujet>` ou `refactor/<sujet>` selon le type de changement
12. **Crée la MR/PR** — Avec description complète en français (en Draft si les tests échouent)
13. **Restaure l'état initial** — Retour sur la branche d'origine et restauration du stash
14. **Poste sur l'issue** — Si applicable, ajoute un lien vers la MR/PR

## Personas disponibles

| Persona | Rôle | Ce qui compte pour elle |
|---------|------|------------------------|
| Alex | Ingénieur Backend Senior | Qualité de code, maintenabilité |
| Sarah | Product Owner | Valeur utilisateur, rapidité de livraison |
| Shug | Ingénieur Sécurité (certifié OWASP) | Surface d'attaque, sécurité web, standards d'authentification |
| Priya | Ingénieure DevOps/SRE | Opérabilité, déploiement, scalabilité |
| Mohammed | Ingénieur Frontend | Expérience utilisateur, Vue.js, React, PrimeVue |
| Didier | Tech Lead / Architecte | Vision long terme, capacité de l'équipe |
| Nicolas | Ingénieur QA | Testabilité, cas limites, Playwright, Vitest |
| Isabelle | Ingénieure Base de Données Senior (Oracle) | Administration Oracle, PL/SQL, tuning |
| Jean-Baptiste | Ingénieur Data | Intégrité des données, migrations |
| Santiago | PO Interopérabilité Senior | Standards HL7, FHIR, HPK |
| Gilles | Développeur Fullstack Senior (Uniface) | Modernisation legacy, patterns 4GL/RAD |
| Victor | Développeur Fullstack Interopérabilité Senior | Intégration bout-en-bout, parsing de messages |

La sélection est automatique selon le contexte. Des personas spécialisées sont créées si le sujet le nécessite.

## Garde-fous

| Protection | Comportement |
|---|---|
| **Working tree sale** | Stash automatique avant le branchement, restauration après le push |
| **Consensus trop facile** | Lancement d'un avocat du diable si toutes les personas sont d'accord |
| **Scope trop large** | Réduction au premier pas critique, ou abandon + suggestion de `/meeting` |
| **Tests en échec** | Une tentative de correction, puis MR/PR en Draft avec détails des échecs |

## Exemple de résultat

Le skill produit :
- Une **analyse affichée** dans la conversation (question, participants, recommandation, risques)
- Une **branche** `feature/<sujet>`, `fix/<sujet>` ou `refactor/<sujet>` avec le code implémenté
- Une **MR/PR** avec description technique orientée développeur (changements fichier par fichier, justifications techniques, points d'attention pour la revue)
- Un **commentaire sur l'issue** (si applicable) orienté Product Owner / consultant (valeur métier, impact utilisateur, risques projet) avec lien vers la MR/PR
