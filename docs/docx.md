# Documents Word (docx)

Manipulation de documents Word (.docx) : lecture, creation, edition et suivi des modifications.

## Contexte

Ce skill permet a l'agent de travailler avec des fichiers Word. Il couvre la lecture, la creation et l'edition, y compris le **redlining** (suivi des modifications pour revision collaborative).

## Operations disponibles

| Operation | Outil | Commande |
|-----------|-------|----------|
| **Lire** | pandoc | `pandoc --track-changes=all fichier.docx -o output.md` |
| **Creer** | docx-js (JavaScript) | Via l'API `Document`, `Packer`, `Paragraph` |
| **Editer** | python-docx (Python) | Decompresser, modifier le XML, recompresser |
| **Redlining** | pandoc / python-docx | Tracked changes pour revision |

## Creer un document (section technique)

```javascript
const { Document, Packer, Paragraph } = require('docx')
const doc = new Document({
  sections: [{ children: [new Paragraph("Contenu")] }]
})
Packer.toBuffer(doc).then(buf =>
  fs.writeFileSync("output.docx", buf)
)
```

## Editer un document (section technique)

Le format `.docx` est une archive ZIP contenant du XML. Le workflow d'edition :

1. **Decompresser** le fichier .docx
2. **Modifier** les fichiers XML internes
3. **Recompresser** en .docx

## Redlining

Le **redlining** (tracked changes) permet de marquer les insertions et suppressions. Utile pour la revision collaborative de documents.
