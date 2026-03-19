# coding-standards

Standards de code universels et bonnes pratiques pour TypeScript, JavaScript, React et Node.js.

## Quand utiliser ce skill

Utilisez ce skill pour :
- Démarrer un nouveau projet avec des conventions solides
- Faire une revue de code qualité
- Établir des standards d'équipe
- Refactorer du code existant
- Former des développeurs juniors aux bonnes pratiques

## Démarrage rapide

```bash
npx skills add Dedalus-ERP-PAS/foundation-skills --skill coding-standards -g -y
```

## Principes fondamentaux

| Principe | Description |
|----------|-------------|
| **KISS** | Keep It Simple — pas de complexité inutile |
| **DRY** | Don't Repeat Yourself — factoriser le code dupliqué |
| **YAGNI** | You Ain't Gonna Need It — ne pas anticiper des besoins hypothétiques |
| **Readability First** | Le code est lu bien plus souvent qu'il n'est écrit |
| **Immutability** | Utiliser les spread operators, ne jamais muter directement |

## Contenu du skill

### TypeScript / JavaScript
- Typage strict (`noImplicitAny`, éviter `any`)
- Nommage clair et cohérent (camelCase variables, PascalCase composants)
- Préférer `const` à `let`, jamais `var`
- Déstructuration et spread operators
- Fonctions pures et immutabilité

### React
- Composition plutôt qu'héritage
- Custom hooks pour la logique partagée
- Mémoïsation ciblée (`useMemo`, `useCallback`)
- Gestion d'état minimale et locale d'abord

### API Design
- URLs basées sur les ressources
- Codes HTTP appropriés
- Gestion d'erreurs cohérente
- Validation des entrées avec Zod

### Organisation des fichiers
- Colocation (tests à côté du code)
- Exports nommés (pas de `default export`)
- Un composant par fichier

### Qualité du code
- Tests AAA (Arrange, Act, Assert)
- Noms de tests descriptifs (`should_return_error_when_...`)
- Détection de code smells (fonctions longues, nesting profond, magic numbers)

## Exemples d'utilisation

```
@workspace avec coding-standards, refactore ce service pour suivre les bonnes pratiques
@workspace avec coding-standards, revois ce fichier et signale les code smells
@workspace avec coding-standards, établis les conventions pour ce nouveau projet
```

## Ressources

- [Skill source](https://github.com/Dedalus-ERP-PAS/foundation-skills/tree/main/skills/coding-standards)
- [SKILL.md complet](../skills/coding-standards/SKILL.md) — Standards et exemples détaillés
