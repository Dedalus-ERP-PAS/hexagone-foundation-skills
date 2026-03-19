# Uniface ProcScript

## Vue d'ensemble

Le skill Uniface ProcScript donne aux agents IA un accès complet à la documentation de référence officielle du langage ProcScript pour Uniface 9.7. Il contient 594 entrées couvrant l'ensemble du langage.

## Ce qu'il fait

- **Recherche** dans la documentation de référence ProcScript (statements, fonctions, triggers, types de données)
- **Explique** la syntaxe, les paramètres, les valeurs de retour et les restrictions d'usage
- **Fournit** des exemples de code ProcScript tirés de la documentation officielle
- **Aide au débogage** en identifiant les erreurs de syntaxe et les contextes d'exécution invalides

## Quand l'utiliser

Utilisez ce skill quand vous avez besoin de :

- Comprendre la syntaxe d'une instruction ProcScript (`retrieve`, `store`, `putitem`, etc.)
- Connaître le comportement d'une fonction (`$concat`, `$status`, `$scan`, etc.)
- Savoir dans quel trigger utiliser une instruction
- Déboguer du code ProcScript existant
- Comprendre les types de données et le préprocesseur Uniface

## Contenu de la documentation

594 entrées réparties en 8 catégories :

| Catégorie | Entrées | Description |
|-----------|---------|-------------|
| Statements | 173 | Instructions du langage (`retrieve`, `store`, `if`, `for`, `putitem`, ...) |
| Functions | 248 | Fonctions intégrées (`$status`, `$concat`, `$scan`, `$date`, ...) |
| Standard Triggers | 74 | Triggers d'événements (`Read`, `Write`, `Store`, `Validate Field`, ...) |
| Extended Triggers | 34 | Triggers étendus (`OnClick`, `OnChange`, `expand`, ...) |
| Data Types | 21 | Types de données (`string`, `numeric`, `date`, `struct`, `handle`, ...) |
| Preprocessor | 23 | Directives de précompilation (`#define`, `#if`, `#include`, ...) |
| Struct Functions | 13 | Fonctions struct (`$name`, `$parent`, `$scalar`, `$tags`, ...) |
| Predefined Operations | 8 | Opérations prédéfinies (`Exec`, `Init`, `Cleanup`, `Quit`, ...) |

## Comment ca fonctionne

La documentation est organisée en fichiers fusionnés par catégorie. Chaque fichier contient toutes les entrées, séparées par des règles horizontales (`---`). L'agent utilise Grep pour localiser une entrée spécifique.

Un fichier d'index (`llms.txt`) liste toutes les entrées avec un résumé d'une ligne.

## Version cible

Ce skill couvre **Uniface 9.7** exclusivement. Ne pas extrapoler vers d'autres versions.

## Source

Généré à partir des fichiers HTML (MadCap Flare) de la documentation officielle Uniface 9.7 via `doc/scripts/convert.py` (dépôt `erp-pas/hexagone/uniface-doc`, branche DOC).
