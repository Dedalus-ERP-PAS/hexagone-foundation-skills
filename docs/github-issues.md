# GitHub Issues

Gestion des issues GitHub : création, consultation, mise à jour et workflows structurés.

## Utilisation

### Créer une issue

```
Crée une issue pour le bug de connexion
```

```
Nouvelle feature request pour le mode sombre
```

```
Crée une tâche pour mettre à jour la documentation
```

### Consulter des issues

```
Montre-moi l'issue #42
```

```
Liste les bugs ouverts
```

```
Quelles issues me sont assignées ?
```

### Mettre à jour une issue

```
Ferme l'issue #123
```

```
Ajoute le label "priority-high" à l'issue #45
```

### Rechercher des issues

```
Recherche les issues contenant "authentification"
```

```
Trouve les bugs créés cette semaine
```

## Prérequis

- Serveur MCP (Model Context Protocol) GitHub configuré (`github-mcp`)
- Accès au repository GitHub concerné

## Types d'issues

| Type | Préfixe | Sections attendues |
|------|---------|-------------------|
| **Bug Report** | `[Bug]` | Description, étapes de reproduction, comportement attendu/actuel, environnement |
| **Feature Request** | `[Feature]` | Résumé, motivation, solution proposée, critères d'acceptation |
| **Task** | `[Task]` | Description, contexte, définition de "terminé", dépendances |

## Exemples

### Création d'un bug

```
Utilisateur : Crée une issue pour le bug de login OAuth

Assistant : J'ai besoin de quelques informations :
- Comportement actuel ? Étapes de reproduction ? Version ?

Utilisateur : Session expirée → reconnexion Google impossible.
             Erreur "Invalid state parameter".

Assistant :
Titre : [Bug] Login OAuth échoue après expiration de session
Labels : bug
Confirmer la création ?
```

### Liste, fermeture et recherche

```
Utilisateur : Montre-moi les bugs ouverts qui me sont assignés

Assistant :
#142 - [Bug] Timeout API        | priority-medium | 15/01/2024
#138 - [Bug] Graphiques Safari  | frontend        | 12/01/2024
#125 - [Bug] Notifications mail | priority-high   | 08/01/2024

Utilisateur : Ferme l'issue #142, corrigé dans la v2.4.0
Assistant : Issue #142 fermée.

Utilisateur : Recherche les issues sur l'authentification
Assistant :
#156 - [Feature] Support SAML       | ouvert
#125 - [Bug] Erreur 2FA             | ouvert | priority-high
#138 - [Task] Documenter auth       | ouvert
```

## Labels courants

| Label | Utilisation |
|-------|-------------|
| `bug` | Quelque chose ne fonctionne pas |
| `enhancement` | Nouvelle fonctionnalité ou amélioration |
| `documentation` | Mise à jour de documentation |
| `good first issue` | Bon pour les débutants |
| `help wanted` | Attention supplémentaire nécessaire |
| `question` | Information supplémentaire requise |
| `wontfix` | Ne sera pas traité |
| `duplicate` | Existe déjà |

## Bonnes pratiques

### Titres efficaces

- Concis mais descriptifs
- Préfixe par type : [Bug], [Feature], [Task], [Docs]
- Mentionner le composant affecté si pertinent
- Garder sous 72 caractères

### Descriptions structurées

- Utiliser le formatage Markdown
- Inclure tout le contexte nécessaire
- Ajouter des captures d'écran ou logs si utile
- Lier les issues, PRs ou documentation connexes
- Utiliser des listes de tâches pour le suivi

### Labels

- Combiner type (`bug`, `enhancement`) et domaine (`frontend`, `api`)
- Utiliser des labels de priorité si nécessaire
- Maintenir une taxonomie cohérente

### Workflow

- Assigner les issues à des personnes spécifiques
- Utiliser les milestones pour la planification
- Mettre à jour le statut au fur et à mesure
- Fermer avec référence à la PR (Pull Request) : "Fixes #XX"

## Démarrage rapide

```bash
npx skills add Dedalus-ERP-PAS/foundation-skills --skill github-issues -g -y
```

## Ressources

- [SKILL.md complet](../skills/github-issues/SKILL.md) -- Guide détaillé
