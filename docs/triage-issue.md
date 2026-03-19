# Triage Issue — Investigation et création d'issue

Investigation approfondie d'un bug avec analyse de cause racine. Création automatique d'une issue avec plan de correction TDD.

## Description

Le skill **triage-issue** permet à l'agent IA d'investiguer un problème signalé. Il trouve la cause racine dans le code. Il crée ensuite une issue (GitLab ou GitHub) avec un plan de correction en cycles **TDD** (RED-GREEN).

Adapté du skill [triage-issue de Damien Battistella](https://github.com/DamienBattistella/skills/tree/main/triage-issue), avec support multi-plateforme GitLab/GitHub.

## Cas d'usage

- **Triage de bug** : investiguer un bug signalé et créer une issue documentée
- **Analyse de cause racine** : explorer le code pour comprendre un comportement inattendu
- **Planification TDD** : définir un plan de correction par cycles RED-GREEN avant de coder
- **Documentation d'issue** : créer une issue durable, pertinente même après des refactors

## Déclenchement

Ce skill s'active quand l'utilisateur :
- Signale un bug ou un comportement inattendu
- Utilise les mots : **"triage"** / **"investigate"** / **"diagnostique"**
- Veut créer une issue après avoir rencontré un problème
- Demande d'analyser la cause racine d'un bug

## Fonctionnement

Le workflow se déroule en 5 phases, largement autonomes :

1. **Capture du problème** : l'agent demande une brève description si nécessaire (une question max)
2. **Exploration et diagnostic** : investigation du code, tests existants, historique git, patterns similaires
3. **Stratégie de correction** : identification du changement minimal pour corriger la cause racine
4. **Plan TDD** : liste ordonnée de cycles RED-GREEN (test qui échoue, puis correction minimale)
5. **Création de l'issue** : détection automatique de la plateforme et création avec le template structuré

## Détection de plateforme

L'agent détecte automatiquement la plateforme cible :
- **GitLab** : présence de `.gitlab-ci.yml` ou URL distante contenant `gitlab`
- **GitHub** : présence du répertoire `.github/` ou URL distante contenant `github.com`
- **Ambiguïté** : si les deux sont détectés ou aucun, l'agent demande à l'utilisateur

## Principes clés

- **Investiguer d'abord, demander ensuite** : l'agent explore le code au lieu de poser des questions
- **Pas de chemins de fichiers dans les issues** : les chemins deviennent obsolètes après un refactor. L'issue décrit des modules, comportements et contrats
- **Plan TDD obligatoire** : chaque correction est décrite comme une séquence de cycles RED-GREEN
- **Durabilité** : une bonne issue se lit comme une spécification comportementale

## Exemples

**English:**
```text
User: "The search API returns 500 when the query contains special characters. Triage this."

Agent: [Activates triage-issue skill]
- Investigates search endpoint, input validation, query parsing
- Finds root cause: unescaped regex characters in search query
- Creates issue with TDD fix plan:
  1. RED: Test search with special chars returns results
     GREEN: Escape regex metacharacters in query parser
  2. RED: Test search with empty query returns empty list
     GREEN: Add empty-string guard in search handler
- Posts issue URL and root cause summary
```

**Français :**
```text
Utilisateur : "L'API de recherche retourne une 500 quand la requête contient des caractères spéciaux. Triage."

Agent : [Active le skill triage-issue]
- Investigue l'endpoint de recherche, la validation des entrées, le parsing
- Trouve la cause racine : caractères regex non échappés dans la requête
- Crée une issue avec plan de correction TDD :
  1. RED : tester la recherche avec caractères spéciaux
     GREEN : échapper les métacaractères regex dans le parser
  2. RED : tester la recherche avec requête vide
     GREEN : ajouter un guard pour les chaînes vides
- Affiche l'URL de l'issue et un résumé de la cause racine
```

## Installation

```bash
npx skills add Dedalus-ERP-PAS/foundation-skills --skill triage-issue -g -y
```

## Version

1.0.0
