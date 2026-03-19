# mcp-builder

Guide pour créer des serveurs MCP (Model Context Protocol) de qualité, permettant aux LLM (Large Language Models) d'interagir avec des services externes via des outils bien conçus.

## Quand utiliser ce skill

Utilisez ce skill pour :
- Créer un serveur MCP pour intégrer une API externe
- Exposer des outils (tools) et ressources (resources) à un LLM
- Structurer un projet MCP en TypeScript ou Python
- Tester et évaluer un serveur MCP

## Workflow de création

### 1. Recherche et planification
- Analyser l'API cible (endpoints, authentification, limites)
- Identifier les outils à exposer (actions utiles pour un LLM)
- Planifier les resources (données consultables)

### 2. Implémentation
- **TypeScript** (recommandé) : meilleur support, SDK (Software Development Kit) officiel `@modelcontextprotocol/sdk`
- **Python** : SDK `fastmcp` pour un développement rapide

### 3. Tests
- Utilisation de MCP Inspector pour valider les outils
- Tests unitaires des tools et resources
- Vérification des formats de réponse

### 4. Évaluation
- Création de cas de test réalistes
- Validation du comportement avec différents prompts
- Vérification de la robustesse (erreurs, edge cases)

## Structure d'un projet MCP

```
my-mcp-server/
├── src/
│   ├── index.ts          # Point d'entrée
│   ├── tools/            # Définition des outils
│   └── resources/        # Définition des resources
├── package.json
└── tsconfig.json
```

## Exemples d'utilisation

```
@workspace avec mcp-builder, crée un serveur MCP pour l'API GitLab
@workspace avec mcp-builder, ajoute un outil de recherche à ce serveur MCP
@workspace avec mcp-builder, teste ce serveur avec MCP Inspector
```

## Démarrage rapide

```bash
npx skills add Dedalus-ERP-PAS/foundation-skills --skill mcp-builder -g -y
```

## Ressources

Le skill inclut des guides détaillés dans `reference/` :

| Fichier | Contenu |
|---------|---------|
| `mcp_best_practices.md` | Bonnes pratiques de conception |
| `node_mcp_server.md` | Guide complet TypeScript |
| `python_mcp_server.md` | Guide complet Python |
| `evaluation.md` | Guide d'évaluation et tests |

- [SKILL.md complet](../skills/mcp-builder/SKILL.md) — Guide détaillé de création
- [Model Context Protocol](https://modelcontextprotocol.io) — Spécification officielle
