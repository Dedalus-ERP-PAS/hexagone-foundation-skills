# Git Guardrails — Protection contre les commandes Git destructrices

## Description

Le skill **git-guardrails** empêche l'agent IA (Claude Code) d'exécuter des commandes Git destructrices. Il intercepte les opérations dangereuses avant leur exécution.

## Pourquoi ce skill ?

Un agent IA peut exécuter des commandes Git irréversibles. Certaines causent des pertes de données :

- **`git push --force`** : écrase l'historique distant et le travail d'autres développeurs
- **`git reset --hard`** : supprime toutes les modifications non commitées
- **`git clean -f`** : supprime définitivement les fichiers non suivis
- **`git branch -D`** : supprime une branche sans vérifier si elle a été fusionnée

Ce skill bloque ces commandes. Si une opération dangereuse est nécessaire, l'utilisateur la lance manuellement.

## Cas d'usage

- **Sécurisation d'un projet** : empêcher l'agent de pousser du code non relu
- **Protection contre les erreurs** : bloquer les suppressions irréversibles de données
- **Conformité Git Flow** : garantir que les push passent par une revue humaine

## Fonctionnement

1. L'utilisateur active le skill et choisit la portée : projet uniquement ou globale
2. Un script de hook est copié dans le répertoire `.claude/hooks/`
3. La configuration Claude Code est mise à jour pour intercepter les commandes Bash
4. Toute commande Git dangereuse est bloquée avant exécution, avec un message explicatif

## Personnalisation

Le script de blocage peut être adapté pour chaque projet :
- Ajouter des patterns (ex : `git stash drop`, `git tag -d`)
- Retirer des patterns si besoin (ex : autoriser `git push` mais bloquer `--force`)

## Installation

```bash
npx skills add Dedalus-ERP-PAS/foundation-skills --skill git-guardrails -g -y
```

## Version

1.0.0
