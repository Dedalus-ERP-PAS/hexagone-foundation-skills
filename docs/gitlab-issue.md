# GitLab Issue

Gestion des issues GitLab : création, consultation, mise à jour et workflows structurés.

## Configuration

**Instance GitLab utilisée :** https://gitlab-erp-pas.dedalus.lan

Configuré pour l'instance GitLab auto-hébergée de Dedalus.

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
Ajoute le label "priority::high" à l'issue #45
```

## Prérequis

- Serveur MCP (Model Context Protocol) GitLab configuré (`gitlab-mcp`)
- Accès à l'instance GitLab auto-hébergée : https://gitlab-erp-pas.dedalus.lan
- Identifiants et permissions appropriés sur les projets GitLab concernés

## Types d'issues

| Type | Préfixe | Sections attendues |
|------|---------|-------------------|
| **Bug Report** | `[BUG]` | Description, environnement, étapes de reproduction, comportement attendu/actuel |
| **Feature Request** | `[FEATURE]` | Description, problème à résoudre, solution proposée, critères d'acceptation |
| **Task** | `[TASK]` | Description, contexte, définition de "terminé" |

## Exemples

### Création d'un bug

```
Utilisateur : Crée une issue pour le bug de login OAuth

Assistant : J'ai besoin de quelques informations :
- Comportement actuel ? Étapes de reproduction ? Version ?

Utilisateur : Session expirée → reconnexion Google impossible.
             Erreur "Invalid state parameter".

Assistant :
Titre : [BUG] Login OAuth échoue après expiration de session
Labels : bug, priority::high, auth
Confirmer la création ?
```

### Liste et fermeture

```
Utilisateur : Montre-moi les bugs ouverts qui me sont assignés

Assistant :
#142 - [BUG] Timeout API        | priority::medium | 15/01/2024
#138 - [BUG] Graphiques Safari  | frontend         | 12/01/2024
#125 - [BUG] Notifications mail | priority::high   | 08/01/2024

Utilisateur : Ferme l'issue #142, corrigé dans la v2.4.0
Assistant : Issue #142 fermée.
```

## Bonnes pratiques

### Titres efficaces

- Concis mais descriptifs
- Préfixe par type : [BUG], [FEATURE], [TASK], [DOCS]
- Mentionner le composant affecté si pertinent

### Descriptions structurées

- Utiliser le formatage Markdown
- Inclure tout le contexte nécessaire
- Ajouter des captures d'écran ou logs si utile
- Lier les issues, MR ou documentation connexes

### Labels

- Utiliser des labels scopés : `priority::high`, `status::in-progress`
- Combiner type (`bug`, `feature`) et domaine (`frontend`, `api`)
- Maintenir une taxonomie cohérente

### Workflow

- Assigner les issues à des personnes spécifiques
- Utiliser les milestones pour la planification
- Mettre à jour le statut au fur et à mesure
- Fermer avec référence à la MR : "Closes #XX"

## Démarrage rapide

```bash
npx skills add Dedalus-ERP-PAS/foundation-skills --skill gitlab-issue -g -y
```

## Ressources

- [SKILL.md complet](../skills/gitlab-issue/SKILL.md) -- Guide détaillé
