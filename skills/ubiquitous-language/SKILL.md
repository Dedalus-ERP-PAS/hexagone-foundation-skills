---
name: ubiquitous-language
description: "Extrait un glossaire de langage ubiquitaire style DDD de la conversation en cours, signale les ambiguïtés et propose des termes canoniques. Sauvegarde dans UBIQUITOUS_LANGUAGE.md. À utiliser quand l'utilisateur veut définir des termes métier, construire un glossaire, durcir la terminologie, créer un langage ubiquitaire ou mentionne « domain model », « DDD », « glossaire » ou « langage ubiquitaire »."
version: 1.0.0
license: MIT
---

# Ubiquitous Language

Extract and formalize domain terminology from the current conversation into a consistent glossary, saved to a local file.

## Healthcare domain awareness

This skill is particularly valuable in healthcare contexts where precise domain language prevents costly misunderstandings. Healthcare systems deal with overlapping standards (HL7v2, FHIR, HPK, IHE profiles) that each introduce their own terminology for similar concepts — a "patient encounter" in FHIR, an "ADT event" in HL7v2, a "venue" in HPK can all refer to overlapping but distinct ideas. Formalizing a ubiquitous language early avoids bugs, specification drift, and integration errors that are expensive and dangerous in clinical environments.

## Bilingual support (French / English)

Our teams work primarily in French, but healthcare domain standards (HL7, FHIR, IHE) and DDD literature use English terminology. The glossary should capture both:

- The **canonical term** is chosen based on whichever language the team uses most naturally for that concept
- A **French term** column is included alongside each definition so that team members can map between languages
- When a standard imposes an English term (e.g. "Encounter", "Observation", "MessageHeader"), prefer the standard's English term as canonical and provide the French equivalent

## Process

1. **Scan the conversation** for domain-relevant nouns, verbs, and concepts
2. **Identify problems**:
   - Same word used for different concepts (ambiguity)
   - Different words used for the same concept (synonyms)
   - Vague or overloaded terms
   - Terms that conflict with established healthcare standards
3. **Propose a canonical glossary** with opinionated term choices
4. **Write to `UBIQUITOUS_LANGUAGE.md`** in the working directory using the format below
5. **Output a summary** inline in the conversation

## Output Format

Write a `UBIQUITOUS_LANGUAGE.md` file with this structure:

```md
# Ubiquitous Language

## Patient lifecycle

| Term | Terme français | Definition | Aliases to avoid |
|------|---------------|-----------|-----------------|
| **Encounter** | Rencontre / Venue | A single interaction between a patient and a healthcare provider, bounded by admission and discharge | Visit, stay, séjour, passage |
| **Admission** | Admission | The act of formally registering a patient for an encounter | Check-in, entrée |

## Clinical concepts

| Term | Terme français | Definition | Aliases to avoid |
|------|---------------|-----------|-----------------|
| **Observation** | Observation | A single clinical measurement or finding recorded during an encounter | Result, measure, mesure, donnée |
| **Prescription** | Prescription | A clinician's order for medication, treatment, or diagnostic test | Order, ordonnance (when referring to the act, not the document) |

## Relationships

- An **Encounter** belongs to exactly one **Patient**
- A **Prescription** is issued during one **Encounter** but may be fulfilled across multiple **Encounters**
- An **Observation** is always recorded within one **Encounter**

## Example dialogue

> **Dev:** "When a **Patient** arrives, do we create an **Encounter** immediately?"
> **Domain expert:** "Yes — the **Admission** triggers the creation of an **Encounter**. But note that pre-admission paperwork does not constitute an **Encounter**; it is handled separately."
> **Dev:** "And if the **Patient** is transferred to another unit?"
> **Domain expert:** "That is still the same **Encounter**. A transfer changes the location, not the **Encounter** itself. A new **Encounter** only begins if the **Patient** is discharged and readmitted."
> **Dev:** "So the HL7 ADT^A02 transfer message updates the **Encounter**, it doesn't create a new one?"
> **Domain expert:** "Exactly."

## Flagged ambiguities

- "séjour" was used to mean both **Encounter** (a clinical interaction) and a hospital stay (a period of time) — prefer **Encounter** for the clinical concept and **Hospitalization** for the administrative period.
- "venue" in HPK context refers to the location-bound encounter, while "venue" in everyday French means something different entirely — always use **Encounter** in code and documentation.
```

## Rules

- **Be opinionated.** When multiple words exist for the same concept, pick the best one and list the others as aliases to avoid.
- **Flag conflicts explicitly.** If a term is used ambiguously in the conversation, call it out in the "Flagged ambiguities" section with a clear recommendation.
- **Keep definitions tight.** One sentence max. Define what it IS, not what it does.
- **Show relationships.** Use bold term names and express cardinality where obvious.
- **Only include domain terms.** Skip generic programming concepts (array, function, endpoint) unless they have domain-specific meaning.
- **Group terms into multiple tables** when natural clusters emerge (e.g. by subdomain, lifecycle, or actor). Each group gets its own heading and table. If all terms belong to a single cohesive domain, one table is fine — don't force groupings.
- **Write an example dialogue.** A short conversation (3-5 exchanges) between a dev and a domain expert that demonstrates how the terms interact naturally. The dialogue should clarify boundaries between related concepts and show terms being used precisely.
- **Include French terms.** Every table row must have a "Terme français" column. When the canonical term is already French, the column may repeat it or note "identique".
- **Respect healthcare standards.** When a term is defined by HL7, FHIR, IHE, or HPK, prefer the standard's canonical spelling and casing. Note the source standard in the definition if helpful.

## Re-running

When invoked again in the same conversation:

1. Read the existing `UBIQUITOUS_LANGUAGE.md`
2. Incorporate any new terms from subsequent discussion
3. Update definitions if understanding has evolved
4. Mark changed entries with "(updated)" and new entries with "(new)"
5. Re-flag any new ambiguities
6. Rewrite the example dialogue to incorporate new terms

## Post-output instruction

After writing the file, state:

> I've written/updated `UBIQUITOUS_LANGUAGE.md`. From this point forward I will use these terms consistently. If I drift from this language or you notice a term that should be added, let me know.
