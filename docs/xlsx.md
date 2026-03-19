# Fichiers Excel (xlsx)

Creation, edition et analyse de fichiers Excel (.xlsx) avec formules, formatage et conventions de modelisation financiere.

## Contexte

Ce skill permet a l'agent de manipuler des fichiers Excel. Il applique les conventions de modelisation financiere (code couleur, formules obligatoires, recalcul systematique).

## Cas d'utilisation

- **Creer** des fichiers Excel avec formules et formatage
- **Lire et analyser** des donnees depuis un fichier existant
- **Modifier** en preservant les formules
- **Appliquer** les conventions de modelisation financiere

## Regles fondamentales

| Regle | Description |
|-------|-------------|
| **Zero erreur de formule** | Toutes les formules doivent etre valides |
| **Formules, pas de valeurs en dur** | Toujours utiliser des formules pour les calculs |
| **Recalcul obligatoire** | Lancer `recalc.py` apres chaque modification |

## Code couleur (convention financiere)

| Couleur | Signification |
|---------|---------------|
| **Bleu** | Inputs (donnees saisies) |
| **Noir** | Formules (calculees) |
| **Vert** | Liens internes (entre onglets) |
| **Rouge** | Liens externes (entre fichiers) |
| **Jaune** | Points d'attention |

## Exemples (section technique)

### Creation

```python
from openpyxl import Workbook
wb = Workbook()
sheet = wb.active
sheet['A1'] = 'Donnees'
sheet['B1'] = '=SUM(A1:A10)'
wb.save('output.xlsx')
```

### Lecture

```python
from openpyxl import load_workbook
wb = load_workbook('fichier.xlsx')
for row in wb.active.iter_rows(values_only=True):
    print(row)
```

## Recalcul des formules

Apres toute modification, le recalcul est **obligatoire** :

```bash
python recalc.py fichier.xlsx
```

Sans recalcul, les formules affichent des valeurs incorrectes dans Excel ou LibreOffice.

## Formatage des nombres

| Type | Format | Exemple |
|------|--------|---------|
| Monetaire | `#,##0` | 1 234 567 |
| Pourcentage | `0.0%` | 12.5% |
| Annees | Sans separateur de milliers | 2026 |

## Utilisation

```
@workspace avec xlsx, cree un tableau de bord financier avec formules
@workspace avec xlsx, analyse les donnees de ce fichier Excel
@workspace avec xlsx, ajoute une colonne calculee a ce classeur
```

## Demarrage rapide

```bash
npx skills add Dedalus-ERP-PAS/foundation-skills --skill xlsx -g -y
```

## Ressources

- [SKILL.md complet](../skills/xlsx/SKILL.md) — Guide detaille avec conventions de formatage
