---
name: meeting-report
description: "Génère automatiquement un compte-rendu de réunion en français à partir d'une transcription Teams (.vtt) et optionnellement d'un rapport de présence (.csv). Spécifique au projet hexagone-monorepo. À utiliser quand l'utilisateur dépose un ou deux chemins de fichiers Teams dans le prompt et demande la génération d'un compte-rendu."
allowed-tools: Read, Write, Bash, Grep, Glob
version: 1.0.0
license: MIT
metadata:
  author: Foundation Skills
---

# Meeting Report

Generate a structured French meeting report from a Microsoft Teams `.vtt` transcript, optionally enriched with a Teams `.csv` attendance report. The report is written to the correct sub-domain folder under `docs/reports/` inside the **hexagone-monorepo** project.

**This skill is specific to the hexagone-monorepo project.** It assumes the working directory is hexagone-monorepo and that `docs/reports/` exists with the following sub-domain folders: `foundation/`, `core/`, `gap/`, `grh/`, `gef/`, `ui-ux/`.

## When to Use This Skill

Activate when the user:
- Dépose un chemin vers un fichier `.vtt` Teams dans le prompt
- Dit « crée un compte-rendu de cette transcription Teams »
- Dit « génère le compte-rendu de cette réunion »
- Dit « transforme cette transcription en rapport »
- Dépose en plus un fichier `.csv` de présence Teams (optionnel)

## Inputs

The skill expects **one or two file paths** dropped in the user prompt:

- **Required:** `.vtt` file — Teams meeting transcript in WebVTT format
- **Optional:** `.csv` file — Teams attendance report

Detection: inspect file extensions in the user prompt. If both are present, `.vtt` is the transcript and `.csv` is the attendance report. If only one file is dropped, it must be the `.vtt`.

## Workflow

### Step 1: Locate and Read the Files

1. Parse the user prompt for file paths (look for `.vtt` and `.csv` extensions)
2. Verify each file exists using Read
3. If no `.vtt` is found → stop and ask the user to provide one
4. Read the `.vtt` content entirely
5. Read the `.csv` content if provided

### Step 2: Parse the Transcript

Teams `.vtt` file structure:

```
WEBVTT

NOTE
Meeting metadata may appear here (date, title, organizer)

00:00:01.000 --> 00:00:04.000
<v Speaker Name>Speech content</v>

00:00:05.000 --> 00:00:08.000
Anonymous speech without voice tag
```

Extract:

1. **Meeting date** — try in this order:
   - **(a)** `NOTE` header content containing a date pattern (ISO `YYYY-MM-DD` or French `DD/MM/YYYY`)
   - **(b)** Filename date pattern (e.g. `20260410_...vtt` → `2026-04-10`)
   - **(c)** Today's date as fallback
2. **Speakers** — parse `<v Speaker Name>...</v>` voice tags (may be absent)
3. **Content blocks** — each timestamped segment is a speaker turn

### Step 3: Resolve Participants

Priority order:

1. **If `.csv` attendance report provided** → parse it and extract the `Name` column. Teams attendance CSVs typically contain columns like `Name`, `First Join`, `Last Leave`, `Duration`, `Role`, `Email`. Use names only for the `## Participants` section.
2. **Else if `<v>` voice tags are present in the `.vtt`** → extract unique speaker names
3. **Else** → **stop and ask the user** to provide the participants list before continuing:

   > « La transcription est anonyme et aucun fichier de présence n'est fourni. Peux-tu me donner la liste des participants ? »

### Step 4: Classify the Sub-Domain

Analyze transcript content for domain signals using the table below (case-insensitive keyword matching):

| Folder | Signals (French keywords) |
|---|---|
| `foundation/` | sprint, rétro, rétrospective, point équipe, stand-up, daily, foundation, équipe foundation |
| `core/` | architecture transversale, cross-domain, LDAP, S3A, S3A settings, permissions utilisateur, rôles, authentification |
| `gap/` | admission, patient, venue, séjour, dossier patient, pré-admission, AMO, AMC, débiteur, couverture sociale, facturation, valorisation, portail patient, ROC, serveur d'actes, actes, urgences, Diapason |
| `grh/` | RH, ressources humaines, employé, salarié, contrat, paie, MyRHConnect, RH Dossier |
| `gef/` | pharmacie, M21, contentieux, emprunts, trésorerie, HA GHT, immobilisations, achats, fournisseurs, comptabilité générale, Hélios, export comptable |
| `ui-ux/` | design, maquette, Figma, atelier UX, atelier UI, wireframe, écran, prototype, UX/UI |

**Classification rule:**

1. If the meeting is clearly an internal **Foundation team recurring meeting** (sprint, rétro, daily, point équipe, stand-up) → `foundation/`
2. Otherwise, count keyword matches per domain folder and pick the **folder with the highest count** (dominant domain)
3. On a tie, prefer the folder whose signals appear earliest in the transcript
4. If no signals match at all → ask the user to confirm the target folder

### Step 5: Extract Meeting Title and Slug

1. Read the first minutes of the transcript for explicit subject references (greetings usually mention the meeting title)
2. Infer a clean French meeting title (e.g. `Atelier UX/UI Recherche Patient`)
3. Generate a kebab-case slug from the title:
   - Lowercase, ASCII only (strip accents)
   - Replace spaces and punctuation with `-`
   - Max ~60 characters
   - Example: `atelier-ux-ui-recherche-patient`

### Step 6: Rewrite Content by Topic

**Style:** Heavy rewrite, grouped by topic, **not** chronological, **not** verbatim.

1. Identify the main topics discussed — cluster speaker turns into thematic groups (topic detection, not speaker order)
2. For each topic, extract:
   - **Décisions** — concrete decisions made (always present as a `### Décisions` subsection)
   - **Point d'attention** — ambiguities, unresolved items (optional `### Point d'attention` subsection)
   - **Problèmes identifiés** — blockers, technical issues, missing dependencies (optional `### Problèmes identifiés` subsection)
3. Write in professional French:
   - Use "nous" or impersonal tone
   - **Fix all missing accents aggressively** — Teams French transcripts are notoriously bad with accents and punctuation
   - **Remove filler words** — « euh », « du coup », « en fait », repetitions, stammering
   - Use `**bold**` emphasis on key terms inside decision bullets
4. **Target length: 800–1500 words** for the full report
5. Number the sections: `## 1. <Topic>`, `## 2. <Topic>`, etc.
6. **Do not quote speakers verbatim.** The output is a synthesized report, not minutes.

### Step 7: Extract Actions

Comb the transcript for action items — things to do, follow-ups, commitments, decisions requiring later implementation. Identify for each:

- **Action** — the thing to do
- **Responsable** — who was assigned (or « À préciser » if unclear)
- **Statut** — typical values: `À planifier`, `En cours`, `En attente`, `Terminé`

Format as a Markdown table. The `## Actions` section is **always present** at the end of the report. If no actions were identified, write a single row:

```markdown
| Action | Responsable | Statut |
|--------|-------------|--------|
| Aucune action identifiée | — | — |
```

### Step 8: Decide Whether to Add a Mermaid Diagram

Add a mermaid diagram **only** when the content genuinely benefits from visualization. Good triggers:

- Multi-step workflows (e.g. a facturation 6/8/7-step process)
- Decision trees with clear branches
- Sequence of events between multiple actors (e.g. admission → séjour → facturation)
- Data flow between systems

Prefer these diagram types:
- `flowchart LR` or `flowchart TD` for processes and decisions
- `sequenceDiagram` for inter-actor interactions
- `timeline` for project phases

Place the diagram **inside the relevant topic section**, not at the top of the report.

**Default: no diagram.** When in doubt, skip it. A report without a diagram is the norm, not the exception.

### Step 9: Assemble the Report

Use this exact template (matches the hexagone-monorepo existing convention):

```markdown
# Compte-rendu — <Type de réunion> <Sujet>

**Date :** DD/MM/YYYY
**Organisateur :** <Nom> (<Rôle>)

## Participants

<Nom1>, <Nom2>, <Nom3>, ...

---

## 1. <Topic 1>

### Décisions

- **<Key term>** : <decision>
- ...

### Point d'attention

<Optional paragraph — only when there is an ambiguity or unresolved item>

### Problèmes identifiés

- <Optional bullet list — only when problems were raised>

---

## 2. <Topic 2>

### Décisions

- ...

---

<...as many topics as needed...>

## Actions

| Action | Responsable | Statut |
|--------|-------------|--------|
| ... | ... | ... |
```

**Rules:**
- **No YAML front-matter**
- **Date in French format** `DD/MM/YYYY` in the body (ISO only in the filename)
- **Participants** is a single comma-separated line, not a table, no roles
- **Organisateur**: if identifiable from transcript/csv, write `**Organisateur :** Nom (Rôle)`. If not identifiable, write `**Organisateur :** À préciser`
- `---` horizontal rule separator between topics
- `## Actions` always at the very end

### Step 10: Determine the Filename

Rule:

- **Foundation team meetings** (`foundation/` folder) → `YYYY-MM-DD.md` (date only, no slug — one standing team meeting per day maximum)
- **All other folders** → `YYYY-MM-DD-<slug>.md`

The filename always uses the **ISO date format** `YYYY-MM-DD`, different from the French `DD/MM/YYYY` used in the report body.

### Step 11: Write the File

1. Build the target path: `docs/reports/<folder>/<filename>.md`
2. Verify the target folder exists using Bash (`ls docs/reports/<folder>/`)
3. Check if a file with the same name already exists — if yes, append `-2`, `-3`, etc. before writing (do NOT overwrite)
4. Write the file with the Write tool

### Step 12: Report to the User

Show a concise summary:

1. ✓ Target path: `docs/reports/<folder>/<filename>.md`
2. One-line summary: domain detected, number of topics, number of actions, number of participants
3. Note any fallback that was triggered (no attendance CSV, no voice tags, today's date used because no date found, etc.)
4. **Stop.** Do not run `git add`, `git commit`, or `git push`. The user commits the file manually after review.

## Important Notes

- **This skill is specific to the hexagone-monorepo project.** It assumes the current working directory is hexagone-monorepo and that `docs/reports/<sub-domain>/` exists for the six domains.
- **No redaction or pseudonymization.** Team meetings are considered internal and trusted. Patient names, client hospitals, commercial info, and personnel names may appear verbatim in reports.
- **No git actions.** The skill writes the file and stops. Commit and push are manual.
- **Rewrite heavily — do not transcribe.** The output is a thematic synthesis, not chronological minutes.
- **Fix French accents aggressively.** Teams `.vtt` French transcripts routinely miss accents and punctuation.
- **Foundation meetings use date-only naming.** All other folders use `YYYY-MM-DD-<slug>.md`.
- **Mermaid is optional, rare, and only when useful.** Default is no diagram.
- **Participants fallback order:** `.csv` first, then `<v>` voice tags, then ask the user. Never invent names.
- **Never overwrite an existing report.** Append a numeric suffix if a file with the same name already exists.

## Examples

### Example 1: UX/UI atelier with attendance CSV

```
User: crée un compte-rendu de cette transcription Teams /tmp/atelier_recherche_patient.vtt /tmp/attendees.csv

→ Skill reads both files
→ Extracts date from .vtt NOTE header: 2026-03-18
→ Participants from .csv: Chloé Julenon, Richard Gill, Adrien Marcos, Myriam Fatoux, Damien Battistella
→ Detects ui-ux signals (atelier, écran, maquette, recherche patient)
→ Classifies as ui-ux/
→ Extracts topics, decisions, actions
→ Writes docs/reports/ui-ux/2026-03-18-atelier-recherche-patient.md
→ Reports path to user
```

### Example 2: Foundation team sprint review, no CSV

```
User: génère le compte-rendu de cette réunion /tmp/sprint_review.vtt

→ Skill reads the .vtt
→ Parses <v Speaker> voice tags → extracts 4 speakers
→ Extracts date from NOTE header: 2026-04-10
→ Detects foundation signals (sprint, rétro, point équipe)
→ Classifies as foundation/
→ Uses date-only naming
→ Writes docs/reports/foundation/2026-04-10.md
```

### Example 3: Anonymous transcript with no CSV

```
User: transforme cette transcription en rapport /tmp/meeting.vtt

→ Skill reads the .vtt
→ No <v> tags found
→ No .csv provided
→ Stops and asks: « La transcription est anonyme et aucun fichier de présence n'est fourni. Peux-tu me donner la liste des participants ? »
→ Waits for the user, then continues with the provided names
```

### Example 4: Multi-domain transcript

```
User: compte-rendu /tmp/point_facturation_ght.vtt

→ Skill reads the .vtt
→ Detects signals for both gap (facturation, venue, séjour) and gef (HA GHT, pharmacie mentioned in passing)
→ gap has significantly more keyword hits → picks gap as dominant
→ Classifies as gap/
→ Writes docs/reports/gap/2026-04-08-point-facturation-ght.md
```
