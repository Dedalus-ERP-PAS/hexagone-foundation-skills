# docs

Génère ou met à jour un README.md en français, orienté Product Owner, avec des diagrammes Mermaid. Revoit et améliore la documentation technique du répertoire `docs/`. Détecte les fonctionnalités non documentées et propose de créer la documentation manquante. Génère aussi CLAUDE.md et AGENT.md si absents.

## Utilisation

Demandez simplement :

```
Crée le readme du projet
Mets à jour le readme
Génère un readme pour ce repo
Génère la documentation
/docs
```

## Fonctionnalités

- Génération d'un README.md complet en français, orienté Product Owner
- Diagrammes Mermaid pour l'architecture et le déploiement
- Table des matières automatique avec liens vers la documentation technique
- Génération de CLAUDE.md (instructions pour Claude Code) si absent
- Génération de AGENT.md (instructions pour agents autonomes) si absent
- Mode création et mode mise à jour (préserve les sections personnalisées)
- **Revue de la documentation technique** — Chaque fichier `docs/*.md` est relu et amélioré selon des règles de qualité (français, concision, lisibilité, diagrammes Mermaid)
- **Détection de documentation manquante** — Analyse croisée du code et des fichiers `docs/` pour identifier les fonctionnalités critiques ou importantes non documentées, avec proposition de création
