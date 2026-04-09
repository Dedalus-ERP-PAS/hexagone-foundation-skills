# Skill : setup

Configure votre environnement de développement en une seule commande : installe les outils CLI prérequis, guide l'authentification GitHub/GitLab, et configure l'intégration Jira (MCP) pour OpenCode.

## Ce que fait ce skill

| Phase | Actions |
|-------|---------|
| 1 — Outils CLI | Installe `gh`, `glab`, `jq`, `uvx` via apt/curl (si absents) |
| 2 — Authentification | Vérifie et guide la connexion à GitHub et GitLab |
| 3 — Jira MCP | Configure `mcp-atlassian` dans `~/.config/opencode/opencode.json` |
| 4 — Résumé | Affiche le statut de chaque composant |

Le skill est **idempotent** : relancer ne réinstalle pas ce qui est déjà présent.

## Déclenchement

Dites à votre assistant IA :

```
setup
```

ou

```
install prerequisites
```

ou encore :

```
configure jira
```

## Détail des installations

### Outils CLI (Phase 1)

Gérés par le script `reference/setup.sh` :

- **`gh`** — GitHub CLI : création d'issues, PR, releases
- **`glab`** — GitLab CLI : merge requests, issues GitLab
- **`jq`** — processeur JSON : requis par plusieurs skills (git-guardrails, etc.)
- **`uvx`** — runner de paquets Python (via `uv`) : requis pour `mcp-atlassian`

### Authentification (Phase 2)

Le skill vérifie l'état de connexion et vous indique les commandes à exécuter si nécessaire :

```bash
gh auth login    # GitHub
glab auth login  # GitLab
```

Ces commandes requièrent une interaction manuelle — le skill vous guide mais ne les exécute pas automatiquement.

### Configuration Jira MCP (Phase 3)

Le skill configure le serveur MCP `mcp-atlassian` dans votre fichier OpenCode (`~/.config/opencode/opencode.json`).

Vous aurez besoin :
- De votre **URL Jira** (par défaut : `https://jira.dedalus.com/`)
- D'un **Personal Access Token (PAT)** Jira :
  1. Connectez-vous à votre instance Jira
  2. Allez dans **Profil → Personal Access Tokens**
  3. Cliquez sur **Create token**, donnez-lui un nom et une expiration
  4. Copiez le token

> **Jira Cloud** : utilisez un API Token depuis `https://id.atlassian.com/manage-profile/security/api-tokens` avec votre email (`JIRA_USERNAME` + `JIRA_API_TOKEN`) à la place du PAT.

Une fois configuré, le fichier de config est sécurisé automatiquement (`chmod 600`).

## Après la configuration

Redémarrez OpenCode pour charger la nouvelle configuration MCP. Vous pouvez ensuite demander à votre assistant :

```
Lis le ticket HEX-5945
Liste mes tickets ouverts dans le projet HEX
```

## Dépendances

Aucun skill prérequis. Ce skill est conçu pour être la première chose à lancer après l'installation des Foundation Skills.

## Voir aussi

- [`gitlab-issue`](gitlab-issue.md) — gestion des issues GitLab (nécessite `glab`)
- [`github-issues`](github-issues.md) — gestion des issues GitHub (nécessite `gh`)
- [`git-guardrails`](git-guardrails.md) — protection des commandes git dangereuses (nécessite `jq`)
