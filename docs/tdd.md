# TDD — Test-Driven Development

## Qu'est-ce que le TDD ?

Le **TDD** (Test-Driven Development) est une méthode où l'on écrit les tests **avant** le code de production. Le cycle fondamental est le **red-green-refactor** :

1. **RED** — Écrire un test qui échoue (il décrit un comportement attendu)
2. **GREEN** — Écrire le minimum de code pour faire passer le test
3. **REFACTOR** — Améliorer le code en gardant les tests au vert

## Pourquoi utiliser cette skill ?

Cette skill guide l'agent IA pour appliquer le TDD de manière rigoureuse :

- **Tranches verticales** : un test puis son implémentation, jamais tous les tests d'un coup
- **Tracer bullet** : le premier test prouve le chemin de bout en bout
- **Tests comportementaux** : on teste ce que le système fait (interface publique), pas comment il le fait (détails internes)
- **Agnostique au framework** : fonctionne avec Vitest, Jest, Playwright, Cypress, pytest ou tout autre outil de test

## Contenu

| Fichier | Description |
|---------|-------------|
| `SKILL.md` | Instructions principales — workflow red-green-refactor |
| `reference/tests.md` | Exemples de bons et mauvais tests |
| `reference/deep-modules.md` | Concevoir des modules profonds (petite interface, implémentation riche) |
| `reference/interface-design.md` | Concevoir des interfaces testables |
| `reference/mocking.md` | Quand et comment mocker (uniquement aux frontières système) |
| `reference/refactoring.md` | Candidats au refactoring après un cycle TDD |

## Installation

```bash
npx skills add Dedalus-ERP-PAS/foundation-skills --skill tdd -g -y
```

## Utilisation

Demandez simplement à votre agent IA de développer une fonctionnalité en TDD :

> « Implémente la validation du formulaire de commande en TDD. »

L'agent suivra automatiquement le cycle red-green-refactor. Il vous demandera de valider le plan et les comportements avant de commencer.
