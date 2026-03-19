# postgres

Requêtes SQL (Structured Query Language) en lecture seule sur PostgreSQL.

## Quand utiliser ce skill

Utilisez ce skill pour :
- Interroger une base PostgreSQL sans risque de modification
- Explorer le schéma d'une base de données
- Exécuter des requêtes de diagnostic ou de reporting

## Commandes

```bash
# Lister les bases configurées
python3 scripts/query.py --list

# Exécuter une requête
python3 scripts/query.py --db production \
  --query "SELECT * FROM users LIMIT 10"

# Voir le schéma
python3 scripts/query.py --db production --schema
```

## Configuration

Créer `connections.json` à partir de `connections.example.json` :

```json
{
  "production": {
    "host": "localhost",
    "port": 5432,
    "database": "mydb",
    "user": "readonly_user",
    "password": "secret"
  }
}
```

**Important :** protéger le fichier avec `chmod 600 connections.json`.

## Sécurité

- **Lecture seule** -- Aucune modification de données possible
- **Permissions limitées** -- Utiliser un utilisateur dédié
- **Fichier protégé** -- Restreindre l'accès à `connections.json`

## Démarrage rapide

```bash
npx skills add Dedalus-ERP-PAS/foundation-skills --skill postgres -g -y
```

## Ressources

- [SKILL.md complet](../skills/postgres/SKILL.md) -- Guide détaillé
- [Documentation PostgreSQL](https://www.postgresql.org/docs/) -- Documentation officielle
