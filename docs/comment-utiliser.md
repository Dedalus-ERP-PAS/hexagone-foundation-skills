# Comment utiliser les Foundation Skills

Guide complet pour installer et utiliser les skills avec vos assistants IA de développement (GitHub Copilot, Claude, Cursor, Windsurf).

## Table des matières

1. [Prérequis](#prérequis)
2. [Installation](#installation)
3. [Utilisation avec différents agents](#utilisation-avec-différents-agents)
4. [Exemples d'utilisation](#exemples-dutilisation)
5. [Gestion des skills](#gestion-des-skills)
6. [Dépannage](#dépannage)

## Prérequis

- Node.js 18+ et npm installés
- Un assistant IA compatible (GitHub Copilot, Claude, Cursor, Windsurf)
- Git (pour certains skills)
- **Activation de l'option "Use Agent skills" dans les paramètres de votre IDE**
  - Pour VS Code : ouvrir les settings (Ctrl+,) et rechercher "agent skills"
  - Pour Cursor/Windsurf : vérifier que l'option "Use Agent skills" est activée dans les préférences

## Installation

### Installation globale (tous les skills)

Installer tous les skills pour tous les agents supportés :

```bash
npx skills add Dedalus-ERP-PAS/foundation-skills -g -y
```

Cette commande :
- `-g` : Installation globale (disponible dans tous vos projets)
- `-y` : Accepte automatiquement les prompts

### Installation sélective

#### Installer des skills spécifiques

```bash
npx skills add Dedalus-ERP-PAS/foundation-skills \
  --skill backend-patterns \
  --skill react-best-practices \
  --skill frontend-design \
  -g -y
```

#### Installer pour des agents spécifiques

```bash
npx skills add Dedalus-ERP-PAS/foundation-skills \
  -a cursor \
  -a github-copilot \
  -g -y
```

### Installation locale (projet spécifique)

Pour installer les skills uniquement dans le projet courant (sans `-g`) :

```bash
cd votre-projet
npx skills add Dedalus-ERP-PAS/foundation-skills -y
```

## Utilisation avec différents agents

### GitHub Copilot (VS Code)

Les skills sont automatiquement chargés et disponibles. Pour activer un skill :

1. Ouvrez la palette de commandes (`Ctrl+Shift+P` / `Cmd+Shift+P`)
2. Tapez "GitHub Copilot: Chat"
3. Mentionnez le skill dans votre conversation :
   ```
   @workspace en utilisant le skill backend-patterns, crée une API REST pour les utilisateurs
   ```

### Claude (Desktop App / VS Code)

Les skills sont chargés automatiquement. Référencez-les dans vos instructions :

```
Utilise le skill react-best-practices pour optimiser ce composant
```

### Cursor

Les skills sont intégrés dans Cursor. Utilisez-les via :

1. Chat Composer (`Ctrl+L` / `Cmd+L`)
2. Inline chat (`Ctrl+K` / `Cmd+K`)
3. Mentionnez le skill ou laissez Cursor le détecter automatiquement

```
Avec backend-patterns, implémente un système de caching Redis
```

### Windsurf

Les skills sont disponibles via les flows. Référencez-les dans vos prompts :

```
Applique frontend-design pour créer une page de login
```

## Exemples d'utilisation

### 1. Créer une API backend avec patterns

```
Prompt : "Crée une API REST pour gérer des tâches (tasks) avec :
- CRUD complet
- Repository pattern
- Validation avec Zod
- Authentification JWT
- Utilise le skill backend-patterns"
```

L'agent va :
- Créer la structure avec Repository Pattern
- Implémenter le Service Layer
- Ajouter la validation des inputs
- Mettre en place l'auth JWT
- Suivre les conventions REST

### 2. Optimiser un composant React

```
Prompt : "Optimise ce composant avec react-best-practices :
- Éviter les re-renders inutiles
- Lazy loading
- Code splitting
- Performance"
```

L'agent va :
- Analyser les re-renders
- Ajouter React.memo si nécessaire
- Implémenter lazy loading
- Suggérer des optimisations

### 3. Créer une interface frontend

```
Prompt : "Crée une page de profil utilisateur en suivant frontend-design :
- Design moderne
- Responsive
- Accessible
- Avec animations"
```

L'agent va :
- Créer un design cohérent
- Assurer la responsivité
- Respecter l'accessibilité (ARIA, contraste)
- Ajouter des micro-interactions

### 4. Manipuler des fichiers Office

```
Prompt : "Avec le skill docx, génère un rapport mensuel :
- En-tête avec logo
- Tableaux de données
- Graphiques
- Export en PDF"
```

L'agent va :
- Créer le document Word
- Structurer le contenu
- Formater professionnellement
- Générer le PDF

### 5. Automatiser un workflow web

```
Prompt : "Utilise playwright-skill pour automatiser :
1. Connexion sur le site
2. Navigation vers le dashboard
3. Extraction des données
4. Génération d'un rapport"
```

L'agent va :
- Créer le script Playwright
- Gérer l'authentification
- Extraire les données
- Sauvegarder les résultats

### 6. Parser des messages de santé HPK

```
Prompt : "Avec hpk-parser, explique ce message HPK :
ID|M1|C|HEXAGONE|20260122120000|USER001|PAT12345|DUPONT|JEAN|19750315|M|..."
```

L'agent va :
- Identifier le type de message (ID|M1 = Patient Identity)
- Extraire tous les champs avec labels
- Valider la structure
- Fournir une explication détaillée en français

### 7. Parser des messages HL7 IHE PAM

```
Prompt : "Utilise hl7-pam-parser pour analyser ce message HL7 ADT :
MSH|^~\&|HEXAFLUX|CHU_PARIS|TARGET|DEST|20260122140000||ADT^A01..."
```

L'agent va :
- Identifier le message type (ADT^A01 = Admission)
- Extraire les segments MSH, EVN, PID, PV1
- Valider contre les spécifications IHE PAM 2.10
- Expliquer le contexte clinique

## Gestion des skills

### Lister les skills disponibles

```bash
npx skills add Dedalus-ERP-PAS/foundation-skills --list
```

### Mettre à jour les skills

```bash
npx skills add Dedalus-ERP-PAS/foundation-skills -g -y --update
```

### Désinstaller un skill

```bash
npx skills remove backend-patterns
```

### Vérifier l'installation

```bash
# Liste les skills installés globalement
ls ~/.config/code/skills/

# Liste les skills installés localement
ls .skills/
```

## Astuces d'utilisation

### 1. Combiner plusieurs skills

Vous pouvez combiner plusieurs skills dans une même tâche :

```
Crée une application fullstack :
- Frontend avec react-best-practices et frontend-design
- Backend avec backend-patterns
- Base de données avec postgres
```

### 2. Référencer explicitement

Pour des résultats optimaux, mentionnez explicitement le skill :

```
❌ "Crée une API"
✅ "Avec backend-patterns, crée une API avec Repository Pattern"
```

### 3. Être spécifique sur les patterns

Précisez quels patterns vous voulez :

```
"Implémente le Repository Pattern et le Service Layer Pattern 
pour une API de gestion de produits"
```

### 4. Demander des explications

N'hésitez pas à demander des explications :

```
"Explique pourquoi tu utilises le cache-aside pattern dans ce code"
```

### 5. Itérer progressivement

Commencez simple, puis ajoutez de la complexité :

```
1. "Crée une API basique pour les users"
2. "Ajoute le caching Redis"
3. "Ajoute le rate limiting"
4. "Ajoute l'authentification JWT"
```

## Skills par cas d'usage

### Développement Backend
- `backend-patterns` - Architecture, API, DB, caching
- `postgres` - Requêtes SQL
- `coding-standards` - Standards généraux

### Développement Frontend
- `react-best-practices` - React/Next.js
- `vue-best-practices` - Vue.js/Nuxt
- `frontend-design` - UI/UX
- `web-design-guidelines` - Audit design

### Automatisation & Tests
- `playwright-skill` - Tests et automatisation web avec Playwright

### Documents & Fichiers
- `docx` - Documents Word
- `pptx` - Présentations PowerPoint
- `xlsx` - Fichiers Excel
- `pdf` - Manipulation PDF

### Gestion de projet
- `github-issues` - Issues GitHub
- `gitlab-issue` - Issues GitLab
- `gitlab-code-review` - Code review GitLab
- `changelog-generator` - Génération changelogs

### Santé & Interopérabilité
- `hpk-parser` - Messages HPK (format santé français)
- `hl7-pam-parser` - Messages HL7 IHE PAM 2.10

### Outils spécialisés
- `mcp-builder` - Serveurs MCP
- `article-extractor` - Extraction articles web
- `toxic-manager-translator` - Communication professionnelle
- `create-design-system-rules` - Design systems

## Dépannage

### Les skills ne sont pas détectés

1. Vérifiez l'installation :
   ```bash
   npx skills add Dedalus-ERP-PAS/foundation-skills --list
   ```

2. Réinstallez :
   ```bash
   npx skills add Dedalus-ERP-PAS/foundation-skills -g -y --force
   ```

3. Redémarrez votre IDE/agent

### Erreur "skill not found"

- Vérifiez le nom exact du skill (voir README.md)
- Installez le skill spécifique :
  ```bash
  npx skills add Dedalus-ERP-PAS/foundation-skills --skill nom-du-skill -g -y
  ```

### Conflit entre skills

Certains skills peuvent avoir des overlaps (ex: coding-standards et backend-patterns sur les APIs). C'est normal - utilisez le plus spécifique à votre besoin.

### Problèmes de permissions

Sur Linux/Mac, si vous avez des erreurs de permissions :

```bash
sudo npx skills add Dedalus-ERP-PAS/foundation-skills -g -y
```

### Les scripts Python ne s'exécutent pas

Pour les skills avec scripts Python (postgres, etc.) :

1. Installez Python 3.8+
2. Installez les dépendances :
   ```bash
   cd ~/.config/code/skills/nom-du-skill
   pip install -r requirements.txt
   ```

## Support

- Issues GitHub : [foundation-skills/issues](https://github.com/Dedalus-ERP-PAS/foundation-skills/issues)
- Documentation : [docs/](https://github.com/Dedalus-ERP-PAS/foundation-skills/tree/main/docs)
- Standard Agent Skills : [agentskills.io](https://agentskills.io)

## Contribuer

Pour ajouter ou améliorer un skill, consultez le [CONTRIBUTING.md](../CONTRIBUTING.md).

## Ressources supplémentaires

- [Agent Skills Documentation](https://agentskills.io/docs)
- [skills CLI](https://github.com/vercel-labs/agent-skills)
- [Guide des patterns backend](backend-patterns.md)
- [Guide React best practices](react-best-practices.md)
