# Comment utiliser les Foundation Skills

Guide pour installer et utiliser les skills avec vos assistants IA (GitHub Copilot, Claude, Cursor, Windsurf).

## Prérequis

- **Node.js** 18+ et npm installés
- Un **assistant IA** compatible (GitHub Copilot, Claude, Cursor, Windsurf)
- Git (pour certains skills)
- **Activation de l'option "Use Agent skills"** dans les paramètres de votre IDE
  - VS Code : ouvrir les settings (`Ctrl+,`) et rechercher "agent skills"
  - Cursor / Windsurf : vérifier dans les préférences

> **Après l'installation**, lancez le skill `setup` pour installer automatiquement les outils CLI prérequis (`gh`, `glab`, `jq`, `uvx`) et configurer l'intégration Jira :
>
> ```
> setup
> ```
>
> Voir [setup.md](setup.md) pour le détail.

## Installation

### Installation globale (tous les skills)

```bash
npx skills add Dedalus-ERP-PAS/foundation-skills -g -y
```

- `-g` : installation globale (disponible dans tous vos projets)
- `-y` : accepte automatiquement les prompts

### Installation sélective

```bash
# Skills spécifiques
npx skills add Dedalus-ERP-PAS/foundation-skills \
  --skill backend-patterns \
  --skill react-best-practices \
  -g -y

# Agents spécifiques
npx skills add Dedalus-ERP-PAS/foundation-skills \
  -a cursor -a github-copilot -g -y
```

### Installation locale (projet spécifique)

```bash
cd votre-projet
npx skills add Dedalus-ERP-PAS/foundation-skills -y
```

## Utilisation avec différents agents

### GitHub Copilot (VS Code)

Les skills sont chargés automatiquement. Pour activer un skill :

1. Ouvrez la palette de commandes (`Ctrl+Shift+P`)
2. Tapez "GitHub Copilot: Chat"
3. Mentionnez le skill dans votre prompt :

```
@workspace en utilisant backend-patterns, créez une API REST
```

### Claude (Desktop App / VS Code)

```
Utilisez react-best-practices pour optimiser ce composant
```

### Cursor

Utilisez le Chat Composer (`Ctrl+L`) ou Inline chat (`Ctrl+K`).

```
Avec backend-patterns, implémentez un système de caching Redis
```

### Windsurf

```
Appliquez frontend pour créer une page de login
```

## Exemples d'utilisation

### Créer une API backend

```
Créez une API REST pour gérer des tâches avec :
- CRUD complet, Repository pattern, validation Zod
- Authentification JWT
- Utilisez backend-patterns
```

### Parser un message HPK

```
Avec hpk-parser, expliquez ce message HPK :
ID|M1|C|HEXAGONE|20260122120000|USER001|PAT12345|...
```

### Parser un message HL7 IHE PAM

```
Utilisez hl7-pam-parser pour analyser ce message HL7 ADT :
MSH|^~\&|HEXAFLUX|CHU_PARIS|TARGET|DEST|20260122140000||ADT^A01...
```

## Gestion des skills

```bash
# Lister les skills disponibles
npx skills add Dedalus-ERP-PAS/foundation-skills --list

# Mettre à jour
npx skills add Dedalus-ERP-PAS/foundation-skills -g -y --update

# Désinstaller un skill
npx skills remove backend-patterns

# Vérifier l'installation
ls ~/.config/code/skills/   # globale
ls .skills/                  # locale
```

## Astuces

- **Mentionnez le skill explicitement** pour de meilleurs résultats
- **Combinez plusieurs skills** dans un même prompt (ex : `react-best-practices` + `frontend`)
- **Commencez simple** puis itérez progressivement
- **Demandez des explications** quand un pattern n'est pas clair

## Dépannage

### Les skills ne sont pas détectés

1. Vérifiez l'installation : `npx skills add Dedalus-ERP-PAS/foundation-skills --list`
2. Réinstallez : `npx skills add Dedalus-ERP-PAS/foundation-skills -g -y --force`
3. Redémarrez votre IDE

### Erreur "skill not found"

- Vérifiez le nom exact du skill (voir [README.md](README.md))
- Installez le skill spécifique avec `--skill nom-du-skill`

### Problèmes de permissions (Linux/Mac)

```bash
sudo npx skills add Dedalus-ERP-PAS/foundation-skills -g -y
```

## Support

- Issues GitHub : [foundation-skills/issues](https://github.com/Dedalus-ERP-PAS/foundation-skills/issues)
- Documentation : [docs/](https://github.com/Dedalus-ERP-PAS/foundation-skills/tree/main/docs)
- Standard Agent Skills : [agentskills.io](https://agentskills.io)
