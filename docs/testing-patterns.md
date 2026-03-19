# Testing Patterns — Stratégies de test JS/TS

Patterns et stratégies de test pour les projets JavaScript/TypeScript. Couvre les tests unitaires, d'intégration, E2E, le mocking et les anti-patterns.

## Quand utiliser ce skill

Utilisez ce skill pour :
- Écrire des tests pour du code existant ou nouveau
- Établir une stratégie de test pour un projet
- Améliorer la couverture ou la fiabilité des tests
- Corriger des tests instables (flaky)
- Choisir entre mock, stub et spy
- Décider quand faire du test unitaire vs intégration vs E2E

## Complémentarité avec le skill `tdd`

| Skill | Focus |
|-------|-------|
| **tdd** | Le *workflow* : boucle red-green-refactor, vertical slices |
| **testing-patterns** | Les *patterns* : comment écrire de bons tests, stratégie de mocking, organisation |

Les deux skills se complètent. Utilisez `tdd` quand vous développez en TDD, et `testing-patterns` pour les patterns concrets.

## Pyramide des tests

```
        /  E2E  \          Peu, lents, haute confiance
       /----------\
      / Intégration \      Nombre modéré, vitesse moyenne
     /----------------\
    /     Unitaires    \   Nombreux, rapides, ciblés
   /____________________\
```

**Règle générale** : ~70 % unitaires, ~20 % intégration, ~10 % E2E. Les codebases legacy bénéficient de plus de tests d'intégration au départ.

## Contenu du skill

### Tests unitaires
- Pattern AAA (Arrange, Act, Assert)
- Nommage descriptif des tests (spécifications)
- Tests paramétrés (table-driven)
- Tests de cas d'erreur
- Tests de code asynchrone

### Tests d'intégration
- Tests base de données (avec vraie DB, pas de mock)
- Tests d'API HTTP (supertest)
- Tests de pipelines de messages (HPK, HL7)

### Tests E2E
- Page Object Pattern
- Convention `data-testid`
- Tests de régression visuelle

### Stratégies de mocking
- Quand mocker vs ne pas mocker
- Mock vs Stub vs Spy
- MSW pour le mocking HTTP
- Mocking du temps

### Organisation des tests
- Colocation (tests à côté du code source)
- Factories pour les données de test
- Utilitaires partagés

### Anti-patterns
- Tester les détails d'implémentation
- Mocking excessif
- Tests instables (flaky) : causes et solutions
- Abus de snapshots

## Exemples d'utilisation

```text
@workspace avec testing-patterns, écris les tests pour ce service patient
@workspace avec testing-patterns, cette suite de tests est flaky, aide-moi à la stabiliser
@workspace avec testing-patterns, établis une stratégie de test pour ce projet
@workspace avec testing-patterns et tdd, implémente cette feature en TDD
```

## Frameworks supportés

| Framework | Usage |
|-----------|-------|
| **Vitest** | Unitaires + intégration (projets Vite) |
| **Jest** | Unitaires + intégration (legacy, CRA) |
| **Playwright** | E2E, régression visuelle |
| **Cypress** | E2E, tests de composants |
| **Testing Library** | Tests DOM (React, Vue) |
| **MSW** | Mocking HTTP |

## Démarrage rapide

```bash
npx skills add Dedalus-ERP-PAS/foundation-skills --skill testing-patterns -g -y
```

## Ressources

- [SKILL.md complet](../skills/testing-patterns/SKILL.md) — Tous les patterns avec exemples de code
- [Skill TDD](../skills/tdd/SKILL.md) — Workflow red-green-refactor
