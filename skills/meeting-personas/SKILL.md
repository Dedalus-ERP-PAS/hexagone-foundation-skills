---
name: meeting-personas
description: Run a simulated meeting with multiple expert personas to analyze a subject from diverse perspectives, reach a decision, and propose a solution before implementation. Optionally posts the meeting analysis to a linked GitLab or GitHub issue.
allowed-tools: gitlab-mcp(get_issue), gitlab-mcp(create_issue_note), gitlab-mcp(update_issue), gitlab-mcp(list_issues)
license: MIT
metadata:
  author: Foundation Skills
  version: 1.0.0
---

# Meeting Personas

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

#### Default Persona Pool

Pick from this pool or create custom ones based on the subject:

| Persona | Role | Perspective | Bias |
|---------|------|-------------|------|
| **Alex** | Senior Backend Engineer | Code quality, maintainability, technical debt | Prefers proven patterns, cautious about new tech |
| **Sarah** | Product Owner | User value, delivery speed, business impact | Prefers shipping fast, pragmatic trade-offs |
| **Shug** | Security Engineer (OWASP certified) | Attack surface analysis, web security (OWASP Top 10), authentication standards (OAuth2, OpenID Connect, JWT), data protection, penetration testing, compliance | Prefers the most secure option, systematically challenges exposed surfaces, risk-averse |
| **Priya** | DevOps/SRE Engineer | Operability, monitoring, deployment, scalability | Prefers simple infrastructure, observable systems |
| **Leo** | Frontend Engineer | User experience, performance, accessibility | Prefers user-centric solutions, design-first |
| **Fatima** | Tech Lead / Architect | System design, long-term vision, team capacity | Prefers sustainable architecture, balanced approach |
| **Yuki** | QA Engineer | Testability, edge cases, regression risk | Prefers thorough coverage, cautious about untested paths |
| **Jean-Baptiste** | Data Engineer | Data integrity, analytics, migration risks | Prefers schema stability, careful migrations |
| **Santiago** | Senior Interoperability PO | Standards compliance (HL7, FHIR, HPK), cross-system integration, data flow consistency | Prefers standard-based approaches, careful about breaking upstream/downstream systems |
| **Victor** | Senior Interoperability Fullstack Developer | End-to-end integration (API, middleware, frontend), message parsing (HL7, FHIR, HPK), system connectors, data mapping and transformation | Prefers pragmatic solutions that work across the full stack, bridges the gap between standards and implementation |

**Custom personas:** If the subject is domain-specific (healthcare, finance, legal...), create a relevant domain expert persona.

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

> **Alex (Senior Backend Engineer):** "I think we should..."

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

#### Round 3: Convergence

After collecting all Round 2 responses, **you** (the facilitator, not a sub-agent) synthesize the discussion:

- Identify points of agreement across all personas
- Highlight unresolved disagreements
- Note the key trade-offs that emerged
- Extract each persona's final position in one sentence

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

**Option recommandée :** [The recommended approach]

**Justification :**
- [Reason 1]
- [Reason 2]
- [Reason 3]

**Risques identifiés :**
- [Risk 1 + mitigation]
- [Risk 2 + mitigation]

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
> 1. Valider cette recommandation et passer à l'implémentation
> 2. Approfondir un point spécifique avec une nouvelle discussion
> 3. Poster cette analyse sur l'issue [#ID] (si applicable)
> 4. Modifier la recommandation"

**Do NOT start implementing anything until the user explicitly validates.**

### Step 6: Post to Issue (If Applicable)

If the subject is linked to a GitLab or GitHub issue and the user asks to post:

1. Format the analysis for the issue comment (keep the French markdown format)
2. Add a header: `## Analyse de réunion avec personas IA`
3. Add a footer: `---\n_Analyse générée par simulation de réunion avec personas IA_`
4. Post as a comment on the issue using the appropriate tool:
   - **GitLab:** Use `gitlab-mcp(create_issue_note)`
   - **GitHub:** Use `gh issue comment`

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

Meeting would include: Alex (Backend), Sarah (PO), Priya (DevOps), Leo (Frontend)
Decision question: "Devons-nous utiliser GraphQL ou REST pour la nouvelle API ?"
```

### Example 2: Architecture Decision with Issue

```
User: Fais une réunion sur l'issue #234 - migration du monolithe vers des microservices

Meeting would include: Fatima (Architect), Alex (Backend), Priya (DevOps), Sarah (PO), Yuki (QA)
Decision question: "Comment migrer du monolithe vers des microservices pour le module facturation ?"
Analysis posted to GitLab issue #234 after user validation
```

### Example 3: Product Decision

```
User: Organisons une réunion sur l'ajout de notifications temps réel dans l'application

Meeting would include: Sarah (PO), Leo (Frontend), Alex (Backend), Shug (Security)
Decision question: "Quelle approche adopter pour les notifications temps réel ?"
```

## Important Notes

- **Never implement before the user validates the recommendation**
- The meeting is a thinking tool, not a decision-making authority
- Keep meetings focused — one decision per meeting
- If the subject is too broad, suggest splitting into multiple focused meetings
- The analysis is always written in French
- Personas speak in English during the meeting for readability, the final analysis is in French
- If the user provides additional context during the meeting, adapt the discussion accordingly
