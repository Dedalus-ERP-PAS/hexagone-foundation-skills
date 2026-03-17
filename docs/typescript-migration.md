# typescript-migration

Guide de migration incrémentale de codebases JavaScript vers TypeScript. Stratégie fichier par fichier, configuration tsconfig, typage du code legacy et élimination progressive de `any`.

## Quand utiliser ce skill

Utilisez ce skill pour :
- Convertir un projet JavaScript (ou une partie) en TypeScript
- Ajouter TypeScript à un projet JS existant
- Typer du code legacy progressivement
- Réduire l'utilisation de `any` dans une codebase
- Configurer tsconfig pour un projet mixte JS/TS

## Principe fondamental

**Ne jamais tout réécrire d'un coup.** Migrer fichier par fichier, en partant des feuilles de l'arbre de dépendances. Chaque état intermédiaire doit être une codebase fonctionnelle.

## Les 5 phases de migration

| Phase | Action | Risque |
|-------|--------|--------|
| **1. Setup** | tsconfig + tooling, zéro changement de code | Nul |
| **2. Rename** | .js → .ts pour les fichiers feuilles, corriger les erreurs | Faible |
| **3. Type boundaries** | Typer les APIs publiques et interfaces partagées | Faible |
| **4. Tighten** | Activer les checks stricts un par un | Moyen |
| **5. Strict mode** | `strict: true`, supprimer `allowJs` | Moyen |

## Contenu du skill

### Phase 1 — Setup
- Installation de TypeScript et `@types/*`
- Configuration `tsconfig.json` permissive pour migration
- Adaptation des outils de build (Vite, Webpack, Next.js)

### Phase 2 — Rename (leaf-first)
- Identification de l'ordre de migration (feuilles d'abord)
- Stratégie de typage par fichier
- Ajout de types explicites aux exports

### Phase 3 — Type boundaries
- Création de fichiers de types partagés (`types/`)
- Typage des réponses API (`ApiResponse<T>`, `PaginatedResponse<T>`)
- Typage des payloads de messages (HPK, HL7) avec discriminated unions

### Phase 4 — Tighten
- Activation progressive : `strictNullChecks` → `noImplicitAny` → `noImplicitReturns` → `strict`
- Patterns pour gérer les erreurs `strictNullChecks`
- Stratégies pour éliminer `any` : `unknown`, type guards, Zod

### Phase 5 — Strict mode
- Activation de `strict: true`
- Suppression de `allowJs`
- Vérification de la couverture de types

## Patterns pour le code legacy

Le skill couvre des patterns spécifiques au code legacy :
- Typage de code avec callbacks → async/await
- Typage d'objets dynamiques (`Record`, index signatures)
- Déclarations de types pour les librairies non typées (`.d.ts`)
- Typage de middleware Express
- Discriminated unions pour les messages healthcare

## Checklist de migration

Le skill inclut 3 checklists :
1. **Avant de commencer** — alignement équipe, tooling, tsconfig
2. **Par fichier** — types exports, interfaces, pas de `any`, tests passent
3. **Avant strict mode** — tous fichiers .ts, nullChecks OK, `any` éliminé

## Pièges courants

| Piège | Conséquence | Solution |
|-------|-------------|----------|
| `as any` partout | TypeScript inutile | `unknown` + type guards |
| Réécrire le code pendant la migration | Bugs, blocage | Migrer les types, refactorer après |
| Démarrer en strict | Trop d'erreurs, abandon | Démarrer permissif, durcir progressivement |
| PR géantes (50 fichiers) | Impossible à reviewer | 1 fichier ou module par PR |

## Exemples d'utilisation

```
@workspace avec typescript-migration, configure TypeScript pour ce projet JS
@workspace avec typescript-migration, migre ce fichier en TypeScript
@workspace avec typescript-migration, élimine les `any` de ce module
@workspace avec typescript-migration, active strictNullChecks et corrige les erreurs
```

## Démarrage rapide

```bash
npx skills add Dedalus-ERP-PAS/foundation-skills --skill typescript-migration -g -y
```

## Skills complémentaires

- **coding-standards** — Conventions TypeScript/JavaScript
- **testing-patterns** — Patterns de test (vérifier que les tests passent après migration)
- **tdd** — Développement piloté par les tests

## Ressources

- [SKILL.md complet](../skills/typescript-migration/SKILL.md) — Guide détaillé avec exemples de code
- [TypeScript Handbook — Migrating from JavaScript](https://www.typescriptlang.org/docs/handbook/migrating-from-javascript.html)
