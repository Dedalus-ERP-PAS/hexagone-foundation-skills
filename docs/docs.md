# Documentation (docs)

Generation et mise a jour de la documentation projet : README.md, CLAUDE.md, AGENT.md et fichiers `docs/`.

## Contexte

Ce skill automatise la creation et la maintenance de la documentation. Il genere un README.md en francais, oriente Product Owner (PO), avec des diagrammes Mermaid. Il detecte aussi les fonctionnalites non documentees.

## Utilisation

Demandez simplement :

- `Cree le readme du projet`
- `Mets a jour le readme`
- `Genere la documentation`
- `/docs`

## Fonctionnalites

### Generation de fichiers

- **README.md** — Complet, en francais, oriente PO, avec diagrammes Mermaid
- **CLAUDE.md** — Instructions pour Claude Code (genere si absent)
- **AGENT.md** — Instructions pour agents autonomes (genere si absent)
- **Table des matieres** automatique avec liens vers la documentation technique

### Revue de la documentation

- **Relecture qualite** de chaque fichier `docs/*.md` (francais, concision, lisibilite)
- **Detection de documentation manquante** par analyse croisee du code

### Modes de fonctionnement

| Mode | Comportement |
|------|-------------|
| **Creation** | Genere les fichiers depuis zero |
| **Mise a jour** | Preserve les sections personnalisees |
