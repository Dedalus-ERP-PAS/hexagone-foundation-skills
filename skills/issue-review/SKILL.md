---
name: issue-review
description: "Lance une revue d'issue automatique avec des personas experts sélectionnés automatiquement, analyse la faisabilité, la complétude, les risques et l'architecture, puis publie un rapport structuré directement sur l'issue — le tout sans intervention de l'utilisateur."
version: 1.0.0
license: MIT
metadata:
  author: Foundation Skills
---

# Issue Review

Run a fully autonomous multi-angle review of a GitLab or GitHub issue using expert personas. The skill fetches issue context, explores the relevant codebase, runs a 3-round persona meeting (opening statements, debate, weighted convergence), and posts a structured review comment directly on the issue — all without asking the user for confirmation.

## When to Use This Skill

Activate when the user:
- Demande une « revue d'issue » ou « issue review » sur une issue
- Dit « issue-review #42 » ou « issue-review <URL> »
- Veut analyser une issue sous plusieurs angles avant implémentation
- Veut un avis structuré sur la faisabilité, la complétude et les risques d'une issue

## Core Principles

### 1. Full Autonomy
- The entire pipeline runs without asking any user questions (except for closed issues — see Edge Cases)
- Persona selection is automatic based on issue content analysis
- The review comment is posted directly on the issue

### 2. Multi-Angle Analysis
- Personas review feasibility, completeness, risks, and architecture
- 3 full rounds ensure genuine debate and richer analysis
- Each persona brings a genuinely different viewpoint

### 3. Contextual Depth
- The skill reads the full issue: description, all comments, labels
- If a branch is linked, the branch diff is analyzed
- The existing codebase is explored automatically to give personas informed context

### 4. Analytical Only
- This skill does NOT implement anything
- It produces a review with actionable next steps
- The team reads the analysis and decides what to do

## Workflow

### Step 1: Identify and Fetch the Issue

1. **Parse the user's input** to extract the issue reference:
   - Issue number: `#42`
   - Full URL: `https://gitlab.example.com/group/project/-/issues/42` or `https://github.com/owner/repo/issues/42`
   - If no valid issue reference is found, ask the user to provide one

2. **Detect the remote repository type:**
   - Run `git remote -v` to determine if the remote is GitLab or GitHub
   - Store this for Step 7 (posting the comment)

3. **Fetch the issue details:**
   - **GitLab:** `glab issue view <iid>` — title, description, labels, state
   - **GitHub:** `gh issue view <number>` — title, body, labels, state

4. **Fetch all issue comments:**
   - **GitLab:** `glab issue note list <iid>` or `glab api /projects/:id/issues/:iid/notes`
   - **GitHub:** `gh issue view <number> --comments`

5. **Check issue state:**
   - If the issue is **closed**, warn the user and ask for confirmation before proceeding (see Edge Cases)
   - If the issue is **open**, proceed normally

6. **Check for minimal content** (see Edge Cases):
   - If the issue has no description or only a one-line title with no meaningful content, skip the meeting and post a short comment listing what's missing

### Step 2: Gather Full Context

#### Issue Context
- Issue title, description, and all comments (collected in Step 1)
- Labels and milestones (for domain detection)

#### Linked Branch Context
1. **Check for linked branches:**
   - **GitLab:** Check the issue for related merge requests via `glab api /projects/:id/issues/:iid/related_merge_requests` or look for branch references in the issue/comments
   - **GitHub:** Check for linked pull requests via `gh pr list --search "<issue reference>"`
2. **If a branch exists:**
   - Fetch the diff: `git diff main...<branch>` (or the appropriate base branch)
   - Include the diff summary and key file changes in the persona context

#### Codebase Context
1. **Analyze the issue content** to identify which parts of the codebase are relevant:
   - File paths, module names, function names, or components mentioned in the issue or comments
   - Domain keywords that map to specific directories or files
2. **Explore the codebase** — read relevant files to understand the current state:
   - Use Glob and Grep to find related files
   - Read the most relevant files (prioritize files explicitly mentioned, then files in related modules)
   - Understand existing patterns, architecture, and conventions
3. **Build a context summary** for the personas including:
   - Issue content (description + comments)
   - Linked branch diff (if any)
   - Relevant codebase snippets and architecture overview

### Step 3: Auto-Select Personas

Automatically select 3-4 personas based on the issue content, labels, and domain. Use these heuristics:

| Le sujet concerne... | Personas auto-sélectionnés |
|---------------------|---------------------|
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

Si le sujet couvre plusieurs domaines, choisir les 3-4 personas les plus pertinents.

**Pool complet des personas avec rôles, perspectives et biais :** see `reference/personas.md`.

**Announce the selected personas and their roles before starting the meeting.**

### Step 4: Run the Review Meeting

The meeting uses sub-agents to run each persona independently and in parallel. The review meeting runs 3 full rounds for depth.

**IMPORTANT: Use the Agent tool to launch each persona as a separate sub-agent.**

#### Round 1: Opening Statements (Parallel Sub-Agents)

Launch one sub-agent per persona **in parallel** using the Agent tool. Each sub-agent receives:

1. The **issue title and description**
2. All **context** gathered (comments, branch diff, codebase snippets)
3. The persona's **identity prompt**

**Sub-agent prompt template:**

```
You are {name}, a {role}.

Your perspective: {perspective}
Your natural bias: {bias}

You are reviewing an issue before implementation. Here is the issue:

**Title:** {issue_title}
**Description:** {issue_description}
**Comments:** {issue_comments}

Codebase context:
{codebase_context}

{branch_diff_context_if_any}

As {name}, provide your review:
1. **Feasibility:** Is this issue feasible as described? What's missing or unclear?
2. **Risks:** What are the top 2-3 risks? Be specific about failure scenarios from your domain.
3. **Completeness:** Are acceptance criteria clear enough to implement? What questions would you ask the PO?
4. **Architecture/Design:** How should this be approached technically? What patterns or constraints apply?
5. **Pushback:** What would you challenge from other typical perspectives?

Stay fully in character. Be concise and actionable. Use concrete examples, not abstract platitudes.

This is a research task — do NOT write or edit any files.
```

**Launch ALL persona sub-agents in a single message** so they run in parallel. Use `subagent_type: "general-purpose"` and a short description like `"Review persona: {name}"`.

**Collect all positions** and present them as quotes:

> **SOLID Alex (Senior Backend Engineer):** "I think..."

#### Anti-Groupthink Check

After collecting Round 1 responses, evaluate the consensus level:

1. **Check if all personas converged on the same assessment** (same verdict, no meaningful disagreement)
2. **If consensus is too high** (all personas agree with no pushback):
   - Launch **one additional sub-agent** as a devil's advocate:
     ```
     You are a devil's advocate reviewing an issue.

     All reviewers agreed on this assessment: {consensus_summary}

     Your job: find the strongest possible argument AGAINST this consensus.
     - What risk did nobody mention?
     - What assumption are they all making that might be false?
     - What edge case or failure mode was dismissed too quickly?

     Be specific and concrete. Reference real failure scenarios.
     This is a research task — do NOT write or edit any files.
     ```
   - Include the dissenting view in the analysis
3. **If there is already meaningful disagreement:** proceed directly to Round 2

#### Round 2: Debate and Challenges (Parallel Sub-Agents)

Launch a **second round of parallel sub-agents** — one per persona. Each sub-agent receives:

1. The **issue details**
2. The **full set of opening statements** from Round 1 (all personas)
3. The persona's identity prompt

**Sub-agent prompt template for Round 2:**

```
You are {name}, a {role}.

Your perspective: {perspective}
Your natural bias: {bias}

You are in a review meeting about this issue:

**Title:** {issue_title}

Here are the opening statements from all reviewers:
{all_opening_statements}

As {name}, react to the other reviewers' positions:
1. Which assessments do you agree with and why?
2. Which assessments do you challenge? Be specific about what's wrong or missing.
3. What risks or gaps have the others missed?
4. Have any of the other statements changed your assessment? If so, how?
5. State your updated verdict: is this issue ready for implementation, needs adjustments, or needs a rethink?

Be direct and create genuine debate. Challenge assumptions. Reference specific points from the other statements. It's OK to disagree strongly. It's also OK to change your mind if convinced.

This is a research task — do NOT write or edit any files.
```

**Launch ALL persona sub-agents in a single message** for Round 2.

**This round should produce genuine tension.** If the sub-agents all agree, add a follow-up prompt to one agent asking it to play devil's advocate on the majority position.

#### Round 3: Weighted Convergence

After collecting all Round 2 responses, **you** (the facilitator, not a sub-agent) synthesize the discussion:

1. **Weight positions by domain relevance:**
   - For each persona, assess how central the issue is to their expertise
   - A database migration issue: EXPLAIN PLAN Isabelle's position carries more weight than Pixel-Perfect Hugo's
   - A UI redesign issue: Pixel-Perfect Hugo's position carries more weight than EXPLAIN PLAN Isabelle's

2. **Identify consensus and disagreements:**
   - Points of agreement across all personas
   - Unresolved disagreements — list them explicitly
   - Key risks and gaps that emerged from the debate

3. **Assess the issue readiness:**
   - **Ready for implementation:** Well-defined, feasible, risks are manageable
   - **Needs adjustments:** Feasible but missing details, unclear acceptance criteria, or risks need mitigation
   - **Needs significant rework:** Major gaps, unclear scope, architectural concerns unresolved

4. **Compile actionable next steps** — concrete checklist items the team can act on

### Step 5: Produce the Review Analysis

Write a structured analysis displayed to the user:

```markdown
## Revue d'issue par personas IA

**Issue :** #XX — [titre de l'issue]

**Participants :** [Name (Role)] | [Name (Role)] | [Name (Role)]

### Contexte
[Résumé métier de l'issue — ce que l'utilisateur/patient/équipe gagne]

### Synthèse de la revue

#### Faisabilité
[Assessment: faisable en l'état / faisable avec réserves / nécessite clarification]

#### Complétude
[Are acceptance criteria clear? What's missing from the spec?]

#### Risques identifiés
- [Risque 1 en impact métier → Mitigation]
- [Risque 2 en impact métier → Mitigation]

#### Points techniques à considérer
[Only when personas surfaced architecture/security/performance concerns — omit section if none]

### Prochaines étapes recommandées
- [ ] [Action 1 — e.g., "Préciser les critères d'acceptation pour le cas X"]
- [ ] [Action 2 — e.g., "Valider l'impact sur le module Y avec l'équipe"]
- [ ] [Action 3]

### Verdict
[One of: ✅ Prête pour implémentation / ⚠️ Nécessite des ajustements avant implémentation / ❌ Nécessite une refonte significative]
```

### Step 6: Post to Issue

Post the review analysis as a comment on the issue. The comment uses the same structure as Step 5, with a footer.

#### Comment Template (French — PO / Consultant Oriented with Technical Concerns)

```markdown
## Revue d'issue par personas IA

### Contexte
[Résumé métier de l'issue — ce que l'utilisateur/patient/équipe gagne]

### Participants
| Expert | Rôle | Verdict |
|--------|------|---------|
| [Name] | [Role] | [Position résumée en 1 ligne orientée impact métier] |
| ... | ... | ... |

### Synthèse de la revue

#### Faisabilité
[Assessment formulé en termes d'impact métier et de faisabilité technique]

#### Complétude
[Analyse de la complétude des critères d'acceptation et des cas d'usage décrits]

#### Risques identifiés
- [Risque 1 en impact métier → Mitigation proposée]
- [Risque 2 en impact métier → Mitigation proposée]

#### Points techniques à considérer
[Uniquement si des préoccupations architecture/sécurité/performance ont émergé — omettre cette section si aucun point technique notable]

### Prochaines étapes recommandées
- [ ] [Action 1]
- [ ] [Action 2]
- [ ] [Action 3]

### Verdict
[✅ Prête pour implémentation / ⚠️ Nécessite des ajustements avant implémentation / ❌ Nécessite une refonte significative]

---
_Revue générée automatiquement par IA_
```

Post the comment using the appropriate tool:
- **GitLab:** `glab issue note <iid> --message "<comment>"`
- **GitHub:** `gh issue comment <number> --body "<comment>"`

If posting fails (API error, permission denied):
- Output the full review comment in the conversation so nothing is lost
- Provide a manual command the user can paste to post the comment themselves
- Record the failure in the Run Summary

### Step 7: Run Summary

**Always output a structured run summary at the end**, regardless of whether the pipeline succeeded or failed.

```markdown
### Issue Review — Run Summary
- **Issue :** #XX — [titre]
- **Remote :** GitLab / GitHub
- **Personas :** [Name (Role)] | [Name (Role)] | [Name (Role)]
- **Rounds :** 3 (ouverture + débat + convergence)
- **Anti-groupthink :** déclenché / non nécessaire
- **Verdict :** ✅ Prête / ⚠️ Ajustements / ❌ Refonte
- **Commentaire :** publié (#XX) / échec ([raison])
- **Durée totale :** [durée wall-clock]
```

## Edge Cases

### Minimal or Empty Issue

If the issue has no description or only a one-line title with no meaningful content:

1. **Do NOT run the persona meeting** — there is not enough content to review
2. **Post a short comment in French** on the issue listing what's missing:

```markdown
## Revue d'issue — Contenu insuffisant

Cette issue ne contient pas assez d'informations pour réaliser une revue pertinente.

### Éléments manquants
- [ ] Description détaillée du besoin ou du problème
- [ ] Critères d'acceptation
- [ ] Contexte métier (qui est impacté, quel workflow)
- [ ] [Any other specific gaps detected]

Merci de compléter l'issue puis de relancer la revue.

---
_Revue générée automatiquement par IA_
```

3. Output the same message in the conversation and stop

### Closed Issue

If the issue is closed:

1. **Warn the user:** "Cette issue est fermée. Souhaitez-vous quand même lancer la revue ? (utile pour une rétrospective)"
2. **If the user confirms:** proceed normally
3. **If the user declines or does not respond:** stop

### Posting Failure

If the comment cannot be posted to the issue:
- Output the full review in the conversation
- Provide a pre-formatted manual command
- Record the failure in the Run Summary

## Meeting Quality Rules

### Persona Authenticity
- Each persona speaks consistently with their role and bias
- Personas use concrete examples, not abstract platitudes
- A security engineer talks about attack vectors, not vague "security concerns"
- A product owner talks about user impact and delivery timelines, not code patterns

### Debate Quality
- At least one persona must disagree with the majority
- Arguments must reference specific trade-offs (performance vs. maintainability, speed vs. safety)
- Avoid false consensus — if everyone agrees too quickly, the anti-groupthink check triggers a devil's advocate
- Personas can change their mind during the debate if convinced

### Review Quality
- The review must be actionable, not vague
- Risks must include mitigation strategies
- Next steps must be concrete and checkboxable
- The verdict must be one of the three defined levels (ready / needs adjustments / needs rework)
- The analysis is written in French (natural, professional, using "nous")

## Examples

### Example 1: Well-Defined Feature Issue

```
User: issue-review #42

→ Fetch issue #42 (feature: add patient notification system)
→ Fetch all comments (3 comments with PO clarifications)
→ No linked branch
→ Explore codebase: notification module, patient service, event system
→ Auto-select: SOLID Alex (Backend), Whiteboard Damien (Architecte), Sprint Zero Sarah (PO), Paranoid Shug (Sécurité)
→ Run 3-round review meeting
→ Verdict: ⚠️ Nécessite des ajustements (missing acceptance criteria for notification preferences)
→ Post review comment on issue #42
```

### Example 2: Issue with Linked Branch

```
User: issue-review https://github.com/org/repo/issues/15

→ Fetch issue #15 (bug: patient search returns duplicates)
→ Fetch comments (1 comment with reproduction steps)
→ Linked branch: fix/patient-search-duplicates — fetch diff
→ Explore codebase: search service, patient repository, index configuration
→ Auto-select: SOLID Alex (Backend), EXPLAIN PLAN Isabelle (DBA), Edge-Case Nico (QA)
→ Run 3-round review meeting
→ Verdict: ✅ Prête pour implémentation
→ Post review comment on issue #15
```

### Example 3: Incomplete Issue

```
User: issue-review #99

→ Fetch issue #99 (title only: "Fix the thing")
→ No description, no comments
→ Skip meeting — post "contenu insuffisant" comment
→ List missing elements on issue #99
```

### Example 4: Closed Issue (Retrospective)

```
User: issue-review #30

→ Fetch issue #30 (closed)
→ Warn user: "Cette issue est fermée. Souhaitez-vous quand même lancer la revue ?"
→ User confirms
→ Proceed with full review pipeline
→ Post review comment on issue #30
```

## Important Notes

- **Never create new labels** on GitLab or GitHub. Only use labels that already exist in the project. If no suitable label exists, skip labeling.
- **This skill is analytical only** — it does NOT implement code, create branches, or create MRs/PRs
- **The review comment is always in French**, PO/consultant oriented, with technical concerns surfaced when needed
- The codebase is always explored for context, even when no branch is linked
- The meeting runs 3 full rounds (opening + debate + convergence) for review depth
- If the remote type cannot be determined, default to `gh issue comment` (GitHub)
- The skill supports both GitLab and GitHub issues
