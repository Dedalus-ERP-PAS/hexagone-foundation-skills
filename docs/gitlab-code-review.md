# GitLab Code Review

Revue de code des merge requests (MR) GitLab couvrant qualité, sécurité, performance et bonnes pratiques.

**Instance GitLab utilisée :** https://gitlab-erp-pas.dedalus.lan

Configuré pour l'instance GitLab auto-hébergée de Dedalus.

## Utilisation

Demandez une revue de code en mentionnant la merge request :

```
Review !123
```

```
Code review de la MR 456
```

```
Revue de code pour l'issue #789
```

```
Montre-moi les MR ouvertes à reviewer
```

## Prérequis

- Serveur MCP (Model Context Protocol) GitLab configuré (`gitlab-mcp`)
- Accès à l'instance GitLab auto-hébergée : https://gitlab-erp-pas.dedalus.lan
- Identifiants et permissions appropriés sur les projets GitLab concernés

## Fonctionnalités

### Identification de la Merge Request

- Par numéro de MR : `review !123`
- Par issue liée : `review #456`
- Liste des MR ouvertes : `review` ou `liste les MR`

### Analyse complète

- **Qualité du code** : style, nommage, organisation, principes DRY (Don't Repeat Yourself)
- **Revue technique** : logique, gestion d'erreurs, edge cases
- **Sécurité** : validation des entrées, injections SQL, XSS (Cross-Site Scripting)
- **Performance** : implications sur les performances
- **Bonnes pratiques** : patterns, SOLID, tests, documentation

### Rapport structuré

Le rapport de revue inclut :

1. **Résumé exécutif** : vue d'ensemble des changements
2. **Statistiques** : fichiers modifiés, lignes ajoutées/supprimées
3. **Points forts** : ce qui est bien fait
4. **Problèmes par priorité** :
   - 🔴 Critique : à corriger avant merge
   - 🟡 Important : à adresser
   - 🟢 Suggestions : améliorations optionnelles
5. **Revue sécurité** : considérations de sécurité
6. **Recommandations de tests** : tests à ajouter

## Style de feedback

Les retours sont formulés sous forme de questions pour encourager le dialogue :

✅ **Bon** :
- "Serait-il possible de simplifier avec un early return ?"
- "Que se passe-t-il si cet appel API échoue ?"

❌ **À éviter** :
- "Vous devriez utiliser un early return"
- "Ajoutez une gestion d'erreur"

## Exemples

### Revue d'une MR spécifique

```
Utilisateur : Review !42 dans groupe/projet

Assistant :
# Code Review : !42 - "Ajout authentification utilisateur"
## Résumé — MR ajoute authentification JWT (JSON Web Token)
## Points forts — Bonne séparation, tests complets
## Problèmes
  🟡 Le token JWT n'a pas d'expiration configurée
  🟢 Envisager l'utilisation de refresh tokens
```

### Liste des MR à reviewer

```
Utilisateur : Montre-moi les MR ouvertes

Assistant :
!45 - "Fix: Pagination"     @alice  | Pipeline: Passed
!43 - "Feature: Export CSV"  @bob    | Pipeline: Running
!42 - "Refactor: Auth"       @charlie| Pipeline: Failed
```

## Notes importantes

- Seuls les changements de la MR sont analysés (pas le code existant)
- Les commentaires ne sont ajoutés qu'avec votre confirmation
- Le statut du pipeline est vérifié avant de conclure la revue

## Démarrage rapide

```bash
npx skills add Dedalus-ERP-PAS/foundation-skills --skill gitlab-code-review -g -y
```

## Ressources

- [SKILL.md complet](../skills/gitlab-code-review/SKILL.md) -- Guide détaillé
