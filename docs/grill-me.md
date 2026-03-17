# Grill Me

## Description

Le skill **grill-me** permet à l'agent IA d'interviewer l'utilisateur de manière approfondie sur un plan ou une conception, jusqu'à atteindre une compréhension partagée complète. L'agent explore chaque branche de l'arbre de décision et résout les dépendances entre les décisions une par une.

## Cas d'usage

- **Validation de plan** : Stress-tester un plan technique ou fonctionnel avant implémentation
- **Revue de conception** : Se faire challenger sur une architecture ou un design
- **Clarification d'exigences** : Identifier les zones floues ou ambiguës d'un projet
- **Prise de décision** : Explorer méthodiquement les différentes options et leurs implications

## Déclenchement

Ce skill s'active quand l'utilisateur :
- Demande à "stress-test" un plan
- Veut être "grillé" sur sa conception
- Utilise les phrases : **"grill me"** / **"interroge-moi"** / **"challenge-moi"** / **"questionne-moi"**
- Souhaite valider une idée en profondeur

## Fonctionnement

L'agent va :
1. Analyser le plan ou la conception présentée
2. Identifier les points à clarifier, les hypothèses implicites, les dépendances
3. Poser des questions ciblées pour explorer chaque branche de décision
4. Explorer le code existant si nécessaire pour répondre aux questions
5. Continuer jusqu'à ce qu'une compréhension partagée soit atteinte

## Avantages

- **Exhaustivité** : Aucun aspect du plan n'est laissé au hasard
- **Anticipation** : Identification précoce des problèmes potentiels
- **Clarté** : Résolution de toutes les ambiguïtés avant l'implémentation
- **Contexte** : Utilisation du code existant pour informer les décisions

## Exemples

**English:**
```
User: "I have a plan to refactor our authentication system. Grill me!"

Agent: [Activates grill-me skill]
- What's the main reason for this refactoring?
- What are the compatibility constraints with the existing system?
- How will you handle migration of current users?
- What rollback strategy do you have?
- [Continues until complete clarification...]
```

**Français:**
```
Utilisateur: "J'ai un plan pour refactorer notre système d'authentification. Interroge-moi!"

Agent: [Active le skill grill-me]
- Quelle est la raison principale de ce refactoring ?
- Quelles sont les contraintes de compatibilité avec le système existant ?
- Comment allez-vous gérer la migration des utilisateurs actuels ?
- Quelle stratégie de rollback prévoyez-vous ?
- [Continue jusqu'à clarification complète...]
```

## Version

1.0.0
