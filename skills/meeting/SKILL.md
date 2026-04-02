---
name: meeting
description: "Lance une réunion simulée avec plusieurs personas experts pour analyser un sujet sous des perspectives diverses, prendre une décision et proposer une solution avant implémentation. Peut optionnellement publier l'analyse de la réunion sur une issue GitLab ou GitHub liée."
version: 1.3.0
license: MIT
metadata:
  author: Foundation Skills
---

# Meeting

Simulate a structured meeting with multiple expert personas to analyze a subject, debate perspectives, and converge on the best course of action. The output is a decision-ready analysis that the user validates before any implementation begins.

## When to Use This Skill

Activate when the user:
- Demande de « lancer une réunion » ou « simuler une réunion » sur un sujet
- Veut analyser un problème sous plusieurs angles avant de décider
- Dit « discutons-en avec des personas » ou « qu'en penseraient des experts ? »
- A besoin d'un débat structuré avant une décision d'architecture, produit ou technique
- Souhaite explorer les compromis sur une fonctionnalité, une migration, un refactoring ou un choix de design
- Référence une issue GitLab ou GitHub et souhaite y poster l'analyse de la réunion

## Core Principles

### 1. Diverse Perspectives
- Each persona brings a genuinely different viewpoint
- Personas may disagree — conflict is valuable
- No persona dominates the discussion

### 2. Structured Debate
- The meeting follows a clear agenda
- Arguments are grounded in facts, trade-offs, and experience
- Every position includes both benefits and risks

### 3. Decision-Oriented
- The meeting converges on a recommendation
- The recommendation includes a clear rationale
- Alternative options remain documented for context

### 4. User Has Final Say
- The meeting produces a proposal, not a decision
- The user reviews and validates before any implementation
- The user can ask for a follow-up meeting to dig deeper

## Workflow

### Step 1: Understand the Subject

Gather context about the subject to discuss:

1. **Read the user's prompt** carefully — extract the topic, constraints, and goals
2. **If an issue is referenced** (GitLab `#123` or GitHub `#123`):
   - Fetch the issue details to understand the full context
   - Read the issue description, labels, comments, and linked MRs
3. **If code is involved**, read the relevant files to understand the current state
4. **Identify the decision to make** — frame it as a clear question

**Output a one-line summary of the decision question before proceeding.**

Example: "Question: Should we migrate the authentication system from session-based to JWT tokens?"

### Step 2: Select Personas

Choose 3-5 personas relevant to the subject. Each persona has:
- A **name** and **role**
- A **perspective** (what they care about most)
- A **bias** (their natural tendency)

#### Suggested Selection Heuristics

Use these heuristics as a starting point. The user can override the selection before the meeting starts.

| Le sujet concerne... | Personas suggérés |
|---------------------|-------------------|
| Backend / API / base de données | SOLID Alex (Backend), Whiteboard Damien (Architecte), EXPLAIN PLAN Isabelle (DBA Oracle) |
| Frontend / UI / UX | Pixel-Perfect Hugo (Frontend), Figma Fiona (UX/UI), Sprint Zero Sarah (PO), Whiteboard Damien (Architecte) |
| Sécurité / auth / contrôle d'accès | Paranoid Shug (Sécurité), RGPD Raphaël (DPO), SOLID Alex (Backend), Whiteboard Damien (Architecte) |
| Infrastructure / déploiement / CI-CD | Pipeline Mo (DevOps), SOLID Alex (Backend), Whiteboard Damien (Architecte) |
| Données / migration / ETL | Schema JB (Data), EXPLAIN PLAN Isabelle (DBA Oracle), Whiteboard Damien (Architecte) |
| Interopérabilité / HL7 / FHIR / HPK | RFC Santiago (PO Interop), HL7 Victor (Dev Interop), SOLID Alex (Backend) |
| Legacy / Uniface / modernisation | Legacy Larry (Uniface), Whiteboard Damien (Architecte), SOLID Alex (Backend) |
| Tests / qualité / régression | Edge-Case Nico (QA), SOLID Alex (Backend), Pipeline Mo (DevOps) |
| Produit / fonctionnalité / décision UX | Sprint Zero Sarah (PO), Pixel-Perfect Hugo (Frontend), Figma Fiona (UX/UI), Whiteboard Damien (Architecte) |
| Santé / workflows cliniques | Dr. Workflow Wendy (Santé), Sprint Zero Sarah (PO), RGPD Raphaël (DPO) |
| RGPD / données personnelles / conformité | RGPD Raphaël (DPO), Paranoid Shug (Sécurité), Whiteboard Damien (Architecte) |
| BI / tableaux de bord / reporting / finance / comptabilité | Dashboard Estelle (BI Finance), Pixel-Perfect Hugo (Frontend), EXPLAIN PLAN Isabelle (DBA Oracle), Whiteboard Damien (Architecte) |
| Full-stack / sujet transverse | Whiteboard Damien (Architecte), SOLID Alex (Backend), Sprint Zero Sarah (PO), Edge-Case Nico (QA) |

Si le sujet couvre plusieurs domaines, choisir les 3-5 personas les plus pertinents. Toujours inclure **Whiteboard Damien (Architecte)** pour les décisions techniques. Toujours inclure **Sprint Zero Sarah (PO)** pour les décisions produit.

**After announcing the selected personas, ask the user to confirm or adjust before starting the meeting.**

#### Default Persona Pool

**Full persona pool with roles, perspectives, and biases:** see `reference/personas.md`.

**Announce the selected personas and their roles before starting the meeting.**

### Step 3: Run the Meeting

The meeting uses sub-agents to run each persona independently and in parallel, then brings their perspectives together for debate and convergence.

**IMPORTANT: Use the Agent tool to launch each persona as a separate sub-agent.** This produces richer, more authentic perspectives because each agent fully embodies its persona without being influenced by the others.

#### Round 1: Opening Statements (Parallel Sub-Agents)

Launch one sub-agent per persona **in parallel** using the Agent tool. Each sub-agent receives:

1. The **decision question** from Step 1
2. All **context** gathered (issue details, code snippets, constraints)
3. The persona's **identity prompt** (see template below)

**Sub-agent prompt template:**

```
You are {name}, a {role}.

Your perspective: {perspective}
Your natural bias: {bias}

You are participating in a meeting about: {decision_question}

Context:
{context}

As {name}, provide your opening statement:
1. What is your recommended approach? Be specific and concrete.
2. Why do you recommend this, from your role's perspective? Give concrete examples.
3. What are the top 2-3 risks you see? Be specific about failure scenarios.
4. What questions would you ask the other participants?

Stay fully in character. Use concrete examples, not abstract platitudes.
A security engineer talks about specific attack vectors, not vague "security concerns".
A product owner talks about user impact and delivery timelines, not code patterns.

This is a research task — do NOT write or edit any files.
```

**Launch ALL persona sub-agents in a single message** so they run in parallel. Use `subagent_type: "general-purpose"` and a short description like `"Persona: {name} opening"`.

**Collect all opening statements** from the sub-agent results. Present them to the user formatted as quotes:

> **SOLID Alex (Senior Backend Engineer):** "I think we should..."

#### Round 2: Debate and Challenges (Parallel Sub-Agents)

Once all opening statements are collected, launch a **second round of parallel sub-agents** — one per persona. Each sub-agent receives:

1. The **decision question**
2. The **full set of opening statements** from Round 1 (all personas)
3. The persona's identity prompt

**Sub-agent prompt template for Round 2:**

```
You are {name}, a {role}.

Your perspective: {perspective}
Your natural bias: {bias}

You are in a meeting about: {decision_question}

Here are the opening statements from all participants:
{all_opening_statements}

As {name}, react to the other participants' positions:
1. Which positions do you agree with and why?
2. Which positions do you challenge? Be specific about what's wrong or missing.
3. What trade-offs have the others missed?
4. Have any of the other statements changed your thinking? If so, how?
5. State your updated position after considering the others' arguments.

Be direct and create genuine debate. Challenge assumptions. Reference specific points from the other statements. It's OK to disagree strongly. It's also OK to change your mind if convinced.

This is a research task — do NOT write or edit any files.
```

**Launch ALL persona sub-agents in a single message** for Round 2.

**This round should produce genuine tension.** If the sub-agents all agree, add a follow-up prompt to one agent asking it to play devil's advocate on the majority position.

#### Round 3: Weighted Convergence

After collecting all Round 2 responses, **you** (the facilitator, not a sub-agent) synthesize the discussion using a structured approach:

1. **Weight positions by domain relevance:**
   - For each persona, assess how central the decision question is to their expertise
   - A database migration question: EXPLAIN PLAN Isabelle's position carries more weight than Pixel-Perfect Hugo's
   - A UI redesign question: Pixel-Perfect Hugo's position carries more weight than EXPLAIN PLAN Isabelle's
   - Whiteboard Damien (Architecte) et Sprint Zero Sarah (PO) jouent le rôle de voix équilibrantes sur tous les sujets

2. **Identify consensus and disagreements:**
   - Points of agreement across all personas
   - Unresolved disagreements — list them explicitly as open items, do NOT silently pick a side
   - Key trade-offs that emerged from the debate

3. **Assess confidence level:**
   - **High confidence:** Strong consensus among domain-relevant personas, risks are well-mitigated
   - **Medium confidence:** Majority agrees but 1-2 meaningful dissenting points remain
   - **Low confidence:** Deep disagreement among domain-relevant personas, or critical unknowns remain
   - Include the confidence level in the analysis output

4. **If confidence is low:**
   - Do NOT force a weak recommendation
   - Instead, clearly state the unresolved points and recommend a **follow-up meeting** (Step 7) focused on the specific disagreement
   - Present the competing options as equals with their trade-offs

5. **Extract each persona's final position** in one sentence

### Step 4: Produce the Decision Analysis

Write a structured analysis in French with the following format:

```markdown
## Analyse de réunion : [Sujet]

### Question posée
[La question de décision claire]

### Participants
| Persona | Rôle | Position finale |
|---------|------|-----------------|
| ... | ... | ... |

### Synthèse de la discussion

[2-3 paragraphs summarizing the key arguments, tensions, and agreements]

### Recommandation

**Niveau de confiance :** [Élevé / Moyen / Faible]

**Option recommandée :** [The recommended approach]

**Justification :**
- [Reason 1]
- [Reason 2]
- [Reason 3]

**Risques identifiés :**
- [Risk 1 + mitigation]
- [Risk 2 + mitigation]

**Points non résolus :** [List any unresolved disagreements, or "Aucun" if full consensus]

### Alternatives considérées

| Option | Avantages | Inconvénients | Verdict |
|--------|-----------|---------------|---------|
| Option A | ... | ... | Recommandée / Rejetée / À explorer |
| Option B | ... | ... | Recommandée / Rejetée / À explorer |

### Prochaines étapes proposées
1. [Step 1]
2. [Step 2]
3. [Step 3]
```

### Step 5: Present and Validate

Present the analysis to the user and ask:

> "Voici l'analyse de la réunion. Souhaitez-vous :
> 1. Valider cette recommandation et passer à l'implémentation (→ Step 8)
> 2. Approfondir un point spécifique avec une réunion de suivi (→ Step 7)
> 3. Poster cette analyse sur l'issue [#ID] (→ Step 6, si applicable)
> 4. Modifier la recommandation"

**Do NOT start implementing anything until the user explicitly selects option 1.**

### Step 6: Post to Issue (If Applicable — PO / Consultant Oriented)

If the subject is linked to a GitLab or GitHub issue and the user asks to post, format the comment for **Product Owners and stakeholders** — focus on business value, user impact, and strategic reasoning, not technical implementation details.

#### Issue Comment Template (French)

```markdown
## Analyse de réunion avec personas IA

### Question posée
[La question de décision formulée en termes métier]

### Participants
| Expert | Rôle | Position |
|--------|------|----------|
| ... | ... | [Position résumée en termes d'impact métier] |

### Synthèse
[2-3 paragraphes résumant les arguments clés en termes de valeur utilisateur, impact business et risques projet — pas de détails techniques]

### Décision recommandée

**Niveau de confiance :** [Élevé / Moyen / Faible]

**Approche retenue :** [Explication en termes de bénéfice utilisateur et valeur métier]

**Pourquoi cette décision :**
- [Bénéfice utilisateur / métier 1]
- [Bénéfice utilisateur / métier 2]
- [Alignement avec les objectifs produit]

### Risques projet
- [Risque 1 formulé en impact métier → Mitigation]
- [Risque 2 formulé en impact métier → Mitigation]

### Impact
- **Utilisateurs concernés :** [Qui est impacté et comment]
- **Dépendances :** [Autres équipes ou fonctionnalités impactées]

### Alternatives considérées
| Option | Valeur métier | Risques | Verdict |
|--------|--------------|---------|---------|
| Option A | ... | ... | Recommandée / Rejetée / À explorer |
| Option B | ... | ... | Recommandée / Rejetée / À explorer |

### Prochaines étapes
1. [Step 1]
2. [Step 2]
3. [Step 3]

---
_Analyse générée automatiquement par IA 🤖_
_Analyse générée automatiquement par IA_
```

Post the comment using the appropriate tool:
- **GitLab:** Use `glab issue note <iid> --message "<comment>"`
- **GitHub:** Use `gh issue comment <number> --body "<comment>"`

### Step 7: Follow-Up Meeting (If Option 2 Selected)

When the user selects option 2 ("Approfondir un point spécifique"), run a follow-up meeting with the following protocol:

1. **Carry forward context:**
   - Include the full previous meeting analysis as context for all sub-agents
   - Explicitly reference the original decision question and the specific point to explore deeper

2. **Narrow the scope:**
   - Frame a new, focused decision question around the unresolved point
   - Format: "Suite de réunion : [Sujet original] → Focus : [Point approfondi]"

3. **Adjust the persona panel:**
   - Keep personas whose expertise is directly relevant to the focused point
   - **Add new personas** if the focused topic requires expertise not present in the original meeting (e.g., if a security concern emerged, add Paranoid Shug if not already present)
   - Remove personas whose expertise is not relevant to the narrowed topic
   - Maximum 3-4 personas for the follow-up (keep it focused)

4. **Run a 2-round follow-up** (Round 1 + Round 2 only, skip Round 3's full synthesis):
   - Sub-agents receive the previous meeting analysis as additional context
   - Their prompts should reference: "In the previous meeting, [summary]. We are now focusing on [specific point]."

5. **Produce a delta analysis:**
   - Do NOT repeat the full original analysis
   - Write a focused section: `## Suite de réunion : Focus sur [point]`
   - Include: what changed, what was confirmed, updated recommendation and confidence level
   - If the original recommendation changed, clearly state: "La recommandation initiale est modifiée suite à l'approfondissement"
   - If confirmed, state: "La recommandation initiale est confirmée après approfondissement"

6. **Present the updated analysis** and return to Step 5 (validate again)

### Step 8: Post-Validation Implementation Path

When the user selects option 1 ("Valider cette recommandation et passer à l'implémentation"):

1. **Ask the user which implementation mode they prefer:**

   > "Recommandation validée. Comment souhaitez-vous procéder ?
   > 1. **Implémentation rapide** — Je lance un `/fast-meeting` avec la recommandation déjà validée (pas de nouvelle réunion, implémentation directe + MR/PR)
   > 2. **Implémentation guidée** — J'implémente pas à pas, vous validez chaque étape"

2. **If option 1 (fast implementation):**
   - Create a branch `meeting/<short-kebab-case-topic>`
   - Implement the validated recommendation directly (skip the meeting phase — it's already done)
   - Run tests, commit, push, create MR/PR following the same protocol as fast-meeting Steps 5-6
   - The MR/PR description must be **developer / technically oriented** (see template below) — focus on code changes, technical rationale, and review points, not the business analysis

   **MR/PR Description Template (French — Developer / Technically Oriented):**

   ```markdown
   ## Résumé technique

   ### Contexte
   [Brève description du problème technique ou de la décision d'architecture qui a motivé ces changements]

   ### Approche retenue
   [L'approche technique choisie et pourquoi — patterns utilisés, alternatives considérées et rejetées techniquement]

   ### Changements implémentés
   | Fichier | Modification | Justification technique |
   |---------|-------------|------------------------|
   | `path/to/file` | [Ce qui a changé] | [Pourquoi ce choix technique] |
   | ... | ... | ... |

   ### Points d'attention pour la revue
   - [Point technique à vérifier — ex: gestion d'erreurs, performance, rétrocompatibilité]
   - [Impact potentiel sur d'autres modules]
   - [Cas limites à valider]

   ### Tests
   - [Résultats des tests : nombre exécutés, passés, échoués]
   - [Couverture des cas limites identifiés]

   ### Prochaines étapes
   - [ ] Revue de code par l'équipe
   - [ ] Validation des tests
   - [ ] Merge après approbation

   ---
   _Implémentation générée automatiquement par IA 🤖_
   _Implémentation générée automatiquement par IA_
   ```

3. **If option 2 (guided implementation):**
   - Present the implementation plan step by step
   - Wait for user confirmation at each significant step
   - The user controls the pace and can adjust the plan

**Do NOT implement anything if the user hasn't selected option 1 in Step 5.**

## Meeting Quality Rules

### Persona Authenticity
- Each persona speaks consistently with their role and bias
- Personas use concrete examples, not abstract platitudes
- A security engineer talks about attack vectors, not vague "security concerns"
- A product owner talks about user stories and metrics, not code patterns

### Debate Quality
- At least one persona must disagree with the majority
- Arguments must reference specific trade-offs (performance vs. maintainability, speed vs. safety)
- Avoid false consensus — if everyone agrees too quickly, introduce a devil's advocate position
- Personas can change their mind during the debate if convinced

### Analysis Quality
- The recommendation must be actionable, not vague
- Risks must include mitigation strategies
- Next steps must be concrete and ordered
- The analysis is written in French (natural, professional, using "nous")

## Examples

### Example 1: Technical Decision

```
User: Lance une réunion pour savoir si on doit utiliser GraphQL ou REST pour la nouvelle API

Participants : SOLID Alex (Backend), Sprint Zero Sarah (PO), Pipeline Mo (DevOps), Pixel-Perfect Hugo (Frontend)
Decision question: "Devons-nous utiliser GraphQL ou REST pour la nouvelle API ?"
```

### Example 2: Architecture Decision with Issue

```
User: Fais une réunion sur l'issue #234 - migration du monolithe vers des microservices

Participants : Whiteboard Damien (Architecte), SOLID Alex (Backend), Pipeline Mo (DevOps), Sprint Zero Sarah (PO), Edge-Case Nico (QA)
Decision question: "Comment migrer du monolithe vers des microservices pour le module facturation ?"
Analysis posted to GitLab issue #234 after user validation
```

### Example 3: Product Decision

```
User: Organisons une réunion sur l'ajout de notifications temps réel dans l'application

Participants : Sprint Zero Sarah (PO), Pixel-Perfect Hugo (Frontend), SOLID Alex (Backend), Paranoid Shug (Sécurité)
Decision question: "Quelle approche adopter pour les notifications temps réel ?"
```

## Important Notes

- **Never create new labels** on GitLab or GitHub. When adding labels to issues or merge requests, only use labels that already exist in the project. If unsure which labels exist, list them first (`gh label list` for GitHub, or check existing issue labels for GitLab) and pick from the available ones. If no suitable label exists, skip labeling rather than creating a new one.
- **Never implement before the user validates the recommendation (option 1 in Step 5)**
- The meeting is a thinking tool, not a decision-making authority
- Keep meetings focused — one decision per meeting
- If the subject is too broad, suggest splitting into multiple focused meetings
- The analysis includes a **confidence level** (high/medium/low) — low confidence triggers a follow-up meeting suggestion instead of forcing a weak recommendation
- Follow-up meetings produce a **delta analysis**, not a full re-analysis
- When the user validates, they choose between fast implementation (automatic MR/PR) or guided implementation (step by step)
- The analysis is always written in French
- Personas speak in English during the meeting for readability, the final analysis is in French
- If the user provides additional context during the meeting, adapt the discussion accordingly
- Persona selection uses heuristics as suggestions; the user confirms or adjusts before the meeting starts
