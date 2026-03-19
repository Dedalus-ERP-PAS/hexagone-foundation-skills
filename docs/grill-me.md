# Grill Me

L'agent IA vous interview en profondeur sur un plan ou une conception. Il explore chaque branche de décision et résout les dépendances une par une, jusqu'à une compréhension partagée complète.

## Cas d'usage

- **Validation de plan** : stress-tester un plan technique ou fonctionnel
- **Revue de conception** : se faire challenger sur une architecture
- **Clarification d'exigences** : identifier les zones floues d'un projet
- **Prise de décision** : explorer les options et leurs implications

## Déclenchement

Ce skill s'active quand vous :
- Demandez a stress-tester un plan
- Utilisez les phrases : **"grill me"** / **"interroge-moi"** / **"challenge-moi"** / **"questionne-moi"**
- Souhaitez valider une idée en profondeur

## Comment ca fonctionne

1. **Analyse** le plan ou la conception présentée
2. **Identifie** les hypothèses implicites et les dépendances
3. **Pose des questions** ciblées sur chaque branche de décision
4. **Explore le code** existant si nécessaire
5. **Continue** jusqu'à compréhension partagée complète

## Avantages

- **Exhaustivité** : aucun aspect du plan n'est laissé au hasard
- **Anticipation** : identification précoce des problèmes potentiels
- **Clarté** : résolution des ambiguïtés avant l'implémentation
- **Contexte** : utilisation du code existant pour éclairer les décisions

## Exemple

```
Utilisateur : "J'ai un plan pour refactorer notre système
d'authentification. Interroge-moi !"

Agent : [Active le skill grill-me]
- Quelle est la raison principale de ce refactoring ?
- Quelles sont les contraintes de compatibilité ?
- Comment gérer la migration des utilisateurs actuels ?
- Quelle stratégie de rollback prévoyez-vous ?
- [Continue jusqu'à clarification complète...]
```
