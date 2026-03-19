# Documents PDF

Manipulation complete de documents PDF : extraction, creation, fusion, decoupage et formulaires.

## Contexte

Ce skill couvre l'ensemble des operations sur les fichiers PDF. Il s'adresse aux equipes qui doivent extraire des donnees, generer des rapports ou manipuler des formulaires PDF.

## Cas d'utilisation

- **Extraire** du texte ou des tableaux depuis un PDF
- **Creer** de nouveaux documents PDF
- **Fusionner ou decouper** des PDF existants
- **Remplir** des formulaires PDF interactifs
- **Convertir** des PDF en images
- **Analyser** des PDF scannes via OCR (Optical Character Recognition)

## Librairies utilisees (section technique)

| Librairie | Usage principal |
|-----------|----------------|
| **pypdf** | Lecture, fusion, decoupage, metadonnees |
| **pdfplumber** | Extraction de texte et tableaux (recommande) |
| **reportlab** | Creation de PDF depuis zero |
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

### Creation de PDF

```python
from reportlab.pdfgen import canvas
c = canvas.Canvas("output.pdf")
c.drawString(100, 750, "Hello World")
c.save()
```

## Scripts disponibles

| Script | Fonction |
|--------|----------|
| `check_fillable_fields.py` | Verifier les champs de formulaire |
| `fill_fillable_fields.py` | Remplir les champs d'un formulaire |
| `extract_form_field_info.py` | Extraire les informations des champs |
| `convert_pdf_to_images.py` | Convertir les pages en images |

## Utilisation

```
@workspace avec pdf, extrais le texte de ce document
@workspace avec pdf, fusionne ces 3 PDF en un seul
@workspace avec pdf, remplis ce formulaire avec les donnees du JSON
```

## Demarrage rapide

```bash
npx skills add Dedalus-ERP-PAS/foundation-skills --skill pdf -g -y
```

## Ressources

- [SKILL.md complet](../skills/pdf/SKILL.md) — Guide detaille avec tous les workflows
