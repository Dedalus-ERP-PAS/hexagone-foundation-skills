# Documents PDF

Manipulation complète de documents PDF : extraction, création, fusion, découpage et formulaires.

## Contexte

Ce skill couvre l'ensemble des opérations sur les fichiers PDF. Il s'adresse aux équipes qui doivent extraire des données, générer des rapports ou manipuler des formulaires PDF.

## Cas d'utilisation

- **Extraire** du texte ou des tableaux depuis un PDF
- **Créer** de nouveaux documents PDF
- **Fusionner ou découper** des PDF existants
- **Remplir** des formulaires PDF interactifs
- **Convertir** des PDF en images
- **Analyser** des PDF scannés via OCR (Optical Character Recognition)

## Librairies utilisées (section technique)

| Librairie | Usage principal |
|-----------|----------------|
| **pypdf** | Lecture, fusion, découpage, métadonnées |
| **pdfplumber** | Extraction de texte et tableaux (recommandé) |
| **reportlab** | Création de PDF depuis zéro |
| **pdftotext / qpdf / pdftk** | Outils en ligne de commande |

## Exemples (section technique)

### Extraction de texte

```python
from pypdf import PdfReader
reader = PdfReader("document.pdf")
text = reader.pages[0].extract_text()
```

### Extraction de tableaux

```python
import pdfplumber
with pdfplumber.open("document.pdf") as pdf:
    tables = pdf.pages[0].extract_tables()
```

### Création de PDF

```python
from reportlab.pdfgen import canvas
c = canvas.Canvas("output.pdf")
c.drawString(100, 750, "Hello World")
c.save()
```

## Scripts disponibles

| Script | Fonction |
|--------|----------|
| `check_fillable_fields.py` | Vérifier les champs de formulaire |
| `fill_fillable_fields.py` | Remplir les champs d'un formulaire |
| `extract_form_field_info.py` | Extraire les informations des champs |
| `convert_pdf_to_images.py` | Convertir les pages en images |

## Utilisation

```
@workspace avec pdf, extrais le texte de ce document
@workspace avec pdf, fusionne ces 3 PDF en un seul
@workspace avec pdf, remplis ce formulaire avec les données du JSON
```

## Démarrage rapide

```bash
npx skills add Dedalus-ERP-PAS/foundation-skills --skill pdf -g -y
```

## Ressources

- [SKILL.md complet](../skills/pdf/SKILL.md) — Guide détaillé avec tous les workflows
