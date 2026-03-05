# Meeting Personas

Simule une réunion structurée avec des experts virtuels pour analyser un sujet sous différents angles, débattre des options et converger vers une recommandation avant toute implémentation.

## Quand l'utiliser

- Avant de prendre une décision technique ou produit importante
- Pour explorer les compromis d'une architecture, migration ou refactoring
- Pour challenger une idée avec des points de vue diversifiés
- Quand une issue GitLab/GitHub nécessite une analyse multi-perspectives

## Comment l'utiliser

Demandez simplement à votre agent IA de lancer une réunion :

```
Run a meeting about whether we should use GraphQL or REST for the new API
```

```
Simulate a meeting about issue #234 - migrating to microservices
```

```
Let's discuss with personas: should we add real-time notifications?
```

## Ce que le skill fait

1. **Comprend le sujet** — Lit le contexte (prompt, issue, code concerné)
2. **Sélectionne 3-5 personas** — Experts virtuels avec des perspectives différentes
3. **Anime la réunion** — 3 tours : positions initiales, débat, convergence
4. **Produit une analyse en français** — Recommandation, risques, alternatives, prochaines étapes
5. **Attend votre validation** — Rien n'est implémenté sans votre accord
6. **Poste sur l'issue** — Si demandé, l'analyse est ajoutée en commentaire sur l'issue liée

## Personas disponibles

| Persona | Rôle | Ce qui compte pour elle |
|---------|------|------------------------|
| Alex | Ingénieur Backend Senior | Qualité de code, maintenabilité |
| Sarah | Product Owner | Valeur utilisateur, rapidité de livraison |
| Marcus | Ingénieur Sécurité | Surface d'attaque, conformité |
| Priya | Ingénieure DevOps/SRE | Opérabilité, déploiement, scalabilité |
| Leo | Ingénieur Frontend | Expérience utilisateur, performance |
| Fatima | Tech Lead / Architecte | Vision long terme, capacité de l'équipe |
| Yuki | Ingénieure QA | Testabilité, cas limites, régression |
| Omar | Ingénieur Data | Intégrité des données, migrations |

Des personas spécialisées (santé, finance, juridique) sont créées automatiquement si le sujet le nécessite.

## Exemple de résultat

L'analyse produite contient :
- La question posée et les participants
- La synthèse de la discussion avec les tensions clés
- La recommandation avec justification
- Les risques identifiés et mitigations
- Les alternatives considérées
- Les prochaines étapes concrètes
