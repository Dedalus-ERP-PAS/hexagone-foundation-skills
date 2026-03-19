# Meeting

Simule une réunion structurée avec des experts virtuels (personas IA). Analyse un sujet sous différents angles, débat des options et converge vers une recommandation.

## Quand l'utiliser

- Avant une décision technique ou produit importante
- Pour explorer les compromis d'une architecture ou migration
- Pour challenger une idée avec des points de vue diversifiés
- Quand une issue GitLab/GitHub nécessite une analyse multi-perspectives

## Comment l'utiliser

Demandez simplement à votre agent IA de lancer une réunion :

```
Lance une réunion pour savoir si on doit utiliser GraphQL ou REST pour la nouvelle API
```

```
Fais une réunion sur l'issue #234 - migration vers des microservices
```

```
Discutons avec des personas : doit-on ajouter des notifications temps réel ?
```

## Ce que le skill fait

1. **Comprend le sujet** — Lit le contexte (prompt, issue, code concerné)
2. **Suggère 3-5 personas** — Sélection automatique par heuristiques, vous confirmez ou ajustez
3. **Anime la réunion** — 3 tours : positions initiales, débat, convergence pondérée
4. **Évalue la confiance** — Niveau élevé, moyen ou faible selon le consensus et les dissidences
5. **Produit une analyse en français** — Recommandation, risques, alternatives, points non résolus, prochaines étapes
6. **Attend votre validation** — Rien n'est implémenté sans votre accord
7. **Réunion de suivi** — Approfondir un point via une réunion ciblée (analyse delta)
8. **Implémente après validation** — MR/PR (Merge Request / Pull Request) automatique ou pas à pas
9. **Poste sur l'issue** — Si demandé, l'analyse est ajoutée en commentaire sur l'issue liée

## Personas disponibles

| Persona | Rôle | Ce qui compte pour elle |
|---------|------|------------------------|
| Alex | Ingénieur Backend Senior | Qualité de code, maintenabilité |
| Sarah | Product Owner | Valeur utilisateur, rapidité de livraison |
| Shug | Ingénieur Sécurité (certifié OWASP -- Open Web Application Security Project) | Surface d'attaque, sécurité web, pentest |
| Priya | Ingénieure DevOps / SRE (Site Reliability Engineer) | Opérabilité, déploiement, scalabilité |
| Mohammed | Ingénieur Frontend | UX, performance, Vue.js 2 & 3, React, PrimeVue |
| Didier | Tech Lead / Architecte | Vision long terme, capacité de l'équipe |
| Nicolas | Ingénieur QA (Quality Assurance) | Testabilité, cas limites, tests E2E (Playwright), tests unitaires (Vitest) |
| Isabelle | Ingénieure BDD Senior (Oracle) | Oracle (11.2 a 19c+), PL/SQL, tuning, RAC, Data Guard |
| Jean-Baptiste | Ingénieur Data | Intégrité des données, migrations |
| Santiago | PO (Product Owner) Interopérabilité Senior | Standards (HL7, FHIR, HPK), intégration inter-systèmes |
| Gilles | Développeur Fullstack Senior (Uniface) | Modernisation legacy, patterns 4GL/RAD, migration |
| Victor | Développeur Fullstack Interopérabilité Senior | Intégration bout-en-bout, parsing HL7/FHIR/HPK |

Des personas spécialisées (santé, finance, juridique) sont créées automatiquement si le sujet le nécessite.

## Nouveautés

| Amélioration | Description |
|---|---|
| **Heuristiques de sélection** | Suggestions automatiques selon le domaine. Vous confirmez avant le lancement. |
| **Convergence pondérée** | Positions pondérées par pertinence d'expertise (ex : un DBA pèse plus sur une question Oracle). |
| **Niveau de confiance** | Chaque analyse inclut un niveau : élevé, moyen ou faible. Si faible, réunion de suivi recommandée. |
| **Réunion de suivi** | Approfondir un point non résolu avec un panel ajusté. Produit une analyse delta. |
| **Chemin vers l'implémentation** | Choix entre implémentation rapide (MR/PR automatique) ou guidée (pas à pas). |

## Exemple de résultat

L'analyse produite contient :
- La question posée et les participants
- La synthèse de la discussion avec les tensions clés
- Le **niveau de confiance** de la recommandation
- La recommandation avec justification
- Les **points non résolus** (le cas échéant)
- Les risques identifiés et mitigations
- Les alternatives considérées
- Les prochaines étapes concrètes
