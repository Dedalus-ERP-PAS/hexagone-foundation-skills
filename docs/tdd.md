# TDD — Test-Driven Development

Le **TDD (Test-Driven Development)** est une méthode de développement piloté par les tests. Ce skill guide l'agent IA pour appliquer le cycle red-green-refactor de manière rigoureuse.

## Pourquoi ce skill

- **Moins de bugs en production** — Les tests écrits avant le code détectent les régressions immédiatement
- **Confiance lors des refactorings** — Modifier du code existant sans risque grâce à un filet de tests solide
- **Spécifications vivantes** — Les tests documentent le comportement attendu mieux qu'un cahier des charges
- **Feedback rapide** — Chaque cycle dure quelques minutes, pas des jours

## Qu'est-ce que le TDD ?

- Vous écrivez les tests **avant** le code de production
- Le cycle fondamental est le **red-green-refactor** :

1. **RED** — Écrire un test qui échoue (il décrit un comportement attendu)
2. **GREEN** — Écrire le minimum de code pour faire passer le test
3. **REFACTOR** — Améliorer le code en gardant les tests au vert

## Quand utiliser ce skill

- **Tranches verticales** : un test puis son implémentation, jamais tous les tests d'un coup
- **Tracer bullet** : le premier test prouve le chemin de bout en bout
- **Tests comportementaux** : on teste l'interface publique, pas les détails internes
- **Agnostique au framework** : fonctionne avec Vitest, Jest, Playwright, Cypress, pytest, etc.

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

Demandez à votre agent IA de développer une fonctionnalité en TDD :

> « Implémente la validation du formulaire de commande en TDD. »

- L'agent suit automatiquement le cycle red-green-refactor
- Il vous demande de valider le plan et les comportements avant de commencer
