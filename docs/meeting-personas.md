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
| Shug | Ingénieur Sécurité (certifié OWASP) | Surface d'attaque, sécurité web (OWASP Top 10), standards d'authentification, pentest |
| Priya | Ingénieure DevOps/SRE | Opérabilité, déploiement, scalabilité |
| Leo | Ingénieur Frontend | Expérience utilisateur, performance |
| Fatima | Tech Lead / Architecte | Vision long terme, capacité de l'équipe |
| Yuki | Ingénieure QA | Testabilité, cas limites, régression |
| Jean-Baptiste | Ingénieur Data | Intégrité des données, migrations |
| Santiago | PO Interopérabilité Senior | Standards (HL7, FHIR, HPK), intégration inter-systèmes |
| Victor | Développeur Fullstack Interopérabilité Senior | Intégration bout-en-bout, parsing de messages (HL7, FHIR, HPK), connecteurs et transformation de données |

Des personas spécialisées (santé, finance, juridique) sont créées automatiquement si le sujet le nécessite.

## Exemple de résultat

L'analyse produite contient :
- La question posée et les participants
- La synthèse de la discussion avec les tensions clés
- La recommandation avec justification
- Les risques identifiés et mitigations
- Les alternatives considérées
- Les prochaines étapes concrètes
