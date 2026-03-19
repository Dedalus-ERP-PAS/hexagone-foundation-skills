# Article Extractor

Extraction de contenu propre d'articles web sans publicités ni navigation.

## Contexte

Les articles web contiennent beaucoup d'éléments parasites (pubs, menus, popups). Ce skill extrait uniquement le contenu utile et le sauvegarde en texte brut.

## Utilisation

Demandez simplement a l'assistant :

- `Extrais cet article : https://example.com/blog/mon-article`
- `Telecharge le contenu de https://example.com/tutoriel`
- `Sauvegarde ce blog post en texte : [URL]`

## Fonctionnalites

- **Extraction du contenu principal** de l'article
- **Suppression automatique** des publicites, navigation et popups
- **Sauvegarde** avec le titre de l'article comme nom de fichier
- **Previsualisation** du contenu extrait

## Elements supprimes

| Element | Exemple |
|---------|---------|
| Navigation | Menus, barres laterales |
| Publicites | Bannieres, contenus promotionnels |
| Formulaires | Inscription newsletter, popups |
| Social | Boutons de partage, commentaires |
| Divers | Notices de cookies |

## Prerequis (section technique)

L'un des outils suivants doit etre installe (par ordre de preference) :

| Outil | Installation | Note |
|-------|-------------|------|
| **reader** (recommande) | `npm install -g @mozilla/readability-cli` | Meilleure qualite |
| **trafilatura** | `pip3 install trafilatura` | Alternative Python |
| **curl** (fallback) | Aucune installation | Moins precis |

## Exemple

```
Utilisateur : Extrais https://blog.example.com/article
Agent : Extrait et sauvegarde "Article - Titre.txt"
```

## Limitations

- Les articles proteges par **paywall** ne peuvent pas etre extraits
- Les sites avec beaucoup de **JavaScript** peuvent poser probleme
- Certaines mises en page complexes affectent la qualite
