# Comment utiliser les Foundation Skills

Guide pour installer et utiliser les skills avec vos assistants IA (GitHub Copilot, Claude, Cursor, Windsurf).

## Prerequis

- **Node.js** 18+ et npm installes
- Un **assistant IA** compatible (GitHub Copilot, Claude, Cursor, Windsurf)
- Git (pour certains skills)
- **Activation de l'option "Use Agent skills"** dans les parametres de votre IDE
  - VS Code : ouvrir les settings (`Ctrl+,`) et rechercher "agent skills"
  - Cursor / Windsurf : verifier dans les preferences

## Installation

### Installation globale (tous les skills)

```bash
npx skills add Dedalus-ERP-PAS/foundation-skills -g -y
```

- `-g` : installation globale (disponible dans tous vos projets)
- `-y` : accepte automatiquement les prompts

### Installation selective

```bash
# Skills specifiques
npx skills add Dedalus-ERP-PAS/foundation-skills \
  --skill backend-patterns \
  --skill react-best-practices \
  -g -y

# Agents specifiques
npx skills add Dedalus-ERP-PAS/foundation-skills \
  -a cursor -a github-copilot -g -y
```

### Installation locale (projet specifique)

```bash
cd votre-projet
npx skills add Dedalus-ERP-PAS/foundation-skills -y
```

## Utilisation avec differents agents

### GitHub Copilot (VS Code)

Les skills sont charges automatiquement. Pour activer un skill :

1. Ouvrez la palette de commandes (`Ctrl+Shift+P`)
2. Tapez "GitHub Copilot: Chat"
3. Mentionnez le skill dans votre prompt :

```
@workspace en utilisant backend-patterns, cree une API REST
```

### Claude (Desktop App / VS Code)

```
Utilise react-best-practices pour optimiser ce composant
```

### Cursor

Utilisez le Chat Composer (`Ctrl+L`) ou Inline chat (`Ctrl+K`).

```
Avec backend-patterns, implemente un systeme de caching Redis
```

### Windsurf

```
Applique frontend-design pour creer une page de login
```

## Exemples d'utilisation

### Creer une API backend

```
Cree une API REST pour gerer des taches avec :
- CRUD complet, Repository pattern, validation Zod
- Authentification JWT
- Utilise backend-patterns
```

### Parser un message HPK

```
Avec hpk-parser, explique ce message HPK :
ID|M1|C|HEXAGONE|20260122120000|USER001|PAT12345|...
```

### Parser un message HL7 IHE PAM

```
Utilise hl7-pam-parser pour analyser ce message HL7 ADT :
MSH|^~\&|HEXAFLUX|CHU_PARIS|TARGET|DEST|20260122140000||ADT^A01...
```

## Gestion des skills

```bash
# Lister les skills disponibles
npx skills add Dedalus-ERP-PAS/foundation-skills --list

# Mettre a jour
npx skills add Dedalus-ERP-PAS/foundation-skills -g -y --update

# Desinstaller un skill
npx skills remove backend-patterns

# Verifier l'installation
ls ~/.config/code/skills/   # globale
ls .skills/                  # locale
```

## Astuces

- **Mentionner le skill explicitement** pour de meilleurs resultats
- **Combiner plusieurs skills** dans un meme prompt (ex : `react-best-practices` + `frontend-design`)
- **Commencer simple** puis iterer progressivement
- **Demander des explications** quand un pattern n'est pas clair

## Depannage

### Les skills ne sont pas detectes

1. Verifiez l'installation : `npx skills add Dedalus-ERP-PAS/foundation-skills --list`
2. Reinstallez : `npx skills add Dedalus-ERP-PAS/foundation-skills -g -y --force`
3. Redemarrez votre IDE

### Erreur "skill not found"

- Verifiez le nom exact du skill (voir [README.md](README.md))
- Installez le skill specifique avec `--skill nom-du-skill`

### Problemes de permissions (Linux/Mac)

```bash
sudo npx skills add Dedalus-ERP-PAS/foundation-skills -g -y
```

## Support

- Issues GitHub : [foundation-skills/issues](https://github.com/Dedalus-ERP-PAS/foundation-skills/issues)
- Documentation : [docs/](https://github.com/Dedalus-ERP-PAS/foundation-skills/tree/main/docs)
- Standard Agent Skills : [agentskills.io](https://agentskills.io)
