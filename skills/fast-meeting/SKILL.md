---
name: fast-meeting
description: Run a fast autonomous meeting with auto-selected personas, implement the decision, create a MR/PR, commit, push, and post a French summary — all without user intervention.
allowed-tools: gitlab-mcp(get_issue), gitlab-mcp(create_issue_note), gitlab-mcp(update_issue), gitlab-mcp(list_issues), gitlab-mcp(create_merge_request), gitlab-mcp(update_merge_request)
version: 1.3.0
license: MIT
metadata:
  author: Foundation Skills
---

# Fast Meeting

Run a fully autonomous meeting with expert personas, then immediately implement the recommended solution, create a merge request or pull request, and post a French description — all without asking the user for confirmation.

## When to Use This Skill

Activate when the user:
- Demande un « fast meeting » ou « réunion rapide » sur un sujet
- Veut une décision ET une implémentation automatique sans interruption
- Dit « fast-meeting » ou « lance un fast meeting sur... »
- Veut qu'un sujet soit analysé, décidé et implémenté en une seule commande

## Core Principles

### 1. Full Autonomy
- The entire pipeline runs without asking any user questions
- Persona selection is automatic based on context analysis
- The best course of action is implemented immediately after the meeting
- A MR/PR is created automatically on the detected remote (GitLab or GitHub)

### 2. Speed Over Thoroughness
- The meeting is compressed: 2 rounds instead of 3 (opening + convergence)
- Personas are limited to 3-4 maximum
- The analysis is concise and action-oriented
- Implementation starts as soon as the meeting concludes

### 3. Diverse but Focused Perspectives
- Personas are auto-selected based on the subject matter
- Each persona brings a genuinely different viewpoint
- The meeting converges quickly toward an actionable recommendation

### 4. Complete Delivery
- Code changes are committed on a dedicated branch
- A MR/PR is created automatically
- The MR/PR description in French summarizes the meeting analysis and implementation

## Workflow

### Step 0: Worktree Hygiene

Before starting, clean up stale worktrees from previous meetings that may have crashed:

1. Run `git worktree prune` to remove stale worktree references
2. Check `git worktree list` — if any entries match sibling directories named `fast-meeting-*` or `fm-*`:
   - **Parallel safety:** before removing, verify the worktree directory has no active git processes (`fuser -s <worktree-path> 2>/dev/null`). If the directory is in active use, **skip it** — it belongs to another running fast-meeting
   - Only remove worktrees confirmed to be stale: `git worktree remove <path> --force`
3. Also clean up any legacy `fast-meeting/*` branches: `git branch --list 'fast-meeting/*' | xargs -r git branch -D`

This ensures a clean starting state without disrupting parallel fast-meeting runs.

### Step 1: Gather Context

1. **Read the user's prompt** — extract the topic, constraints, and goals
2. **If an issue is referenced** (GitLab `#123` or GitHub `#123`):
   - Fetch the issue details (description, labels, comments)
3. **If code is involved**, read relevant files to understand the current state
4. **Detect the remote repository type:**
   - Run `git remote -v` to determine if the remote is GitLab or GitHub
   - Store this for Step 8 (MR/PR creation)
5. **Identify the decision to make** — frame it as a clear one-line question

Output the decision question before proceeding. Example:
> "Question: Should we migrate the authentication system from session-based to JWT tokens?"

### Step 2: Auto-Select Personas

Automatically select 3-4 personas based on the subject matter. Use these heuristics:

| Subject involves... | Auto-select personas |
|---------------------|---------------------|
| Backend / API / database | SOLID Alex (Backend), Whiteboard Damien (Architect), EXPLAIN PLAN Isabelle (Oracle DBA) |
| Frontend / UI / UX | Pixel-Perfect Hugo (Frontend), Figma Fiona (UX/UI), Sprint Zero Sarah (PO), Whiteboard Damien (Architect) |
| Security / auth / access control | Paranoid Shug (Security), RGPD Raphaël (DPO), SOLID Alex (Backend), Whiteboard Damien (Architect) |
| Infrastructure / deploy / CI-CD | Pipeline Mo (DevOps), SOLID Alex (Backend), Whiteboard Damien (Architect) |
| Data / migration / ETL | Schema JB (Data), EXPLAIN PLAN Isabelle (Oracle DBA), Whiteboard Damien (Architect) |
| Interoperability / HL7 / FHIR / HPK | RFC Santiago (Interop PO), HL7 Victor (Interop Dev), SOLID Alex (Backend) |
| Legacy / Uniface / modernization | Legacy Larry (Uniface), Whiteboard Damien (Architect), SOLID Alex (Backend) |
| Testing / quality / regression | Edge-Case Nico (QA), SOLID Alex (Backend), Pipeline Mo (DevOps) |
| Product / feature / UX decision | Sprint Zero Sarah (PO), Pixel-Perfect Hugo (Frontend), Figma Fiona (UX/UI), Whiteboard Damien (Architect) |
| Healthcare / clinical workflows | Dr. Workflow Wendy (Healthcare), Sprint Zero Sarah (PO), RGPD Raphaël (DPO) |
| GDPR / data privacy / compliance | RGPD Raphaël (DPO), Paranoid Shug (Security), Whiteboard Damien (Architect) |
| Full-stack / mixed concern | Whiteboard Damien (Architect), SOLID Alex (Backend), Sprint Zero Sarah (PO), Edge-Case Nico (QA) |

If the subject spans multiple areas, pick the most relevant 3-4 personas. Always include **Whiteboard Damien (Architect)** for technical decisions. Always include **Sprint Zero Sarah (PO)** for product decisions.

**Full persona pool with roles, perspectives, and biases:** see `reference/personas.md`.

**Announce the selected personas and their roles before starting the meeting.**

### Step 3: Run the Fast Meeting

The meeting uses sub-agents to run each persona independently and in parallel. The fast meeting compresses the process into 2 rounds.

**IMPORTANT: Use the Agent tool to launch each persona as a separate sub-agent.**

#### Round 1: Position and Recommendation (Parallel Sub-Agents)

Launch one sub-agent per persona **in parallel** using the Agent tool. Each sub-agent receives:

1. The **decision question** from Step 1
2. All **context** gathered (issue details, code snippets, constraints)
3. The persona's **identity prompt**

**Sub-agent prompt template:**

```
You are {name}, a {role}.

Your perspective: {perspective}
Your natural bias: {bias}

You are participating in a fast meeting about: {decision_question}

Context:
{context}

As {name}, provide your position:
1. What is your recommended approach? Be specific and concrete.
2. What are the top 2 risks? Be specific about failure scenarios.
3. What is your preferred implementation strategy in concrete steps?
4. What would you push back on from other typical perspectives?

Stay fully in character. Be concise and actionable — this is a fast meeting.

This is a research task — do NOT write or edit any files.
```

**Launch ALL persona sub-agents in a single message** so they run in parallel. Use `subagent_type: "general-purpose"` and a short description like `"Fast persona: {name}"`.

**Collect all positions** and present them as quotes:

> **SOLID Alex (Senior Backend Engineer):** "I recommend..."

#### Anti-Groupthink Check

After collecting Round 1 responses, evaluate the consensus level:

1. **Check if all personas converged on the same approach** (same recommendation, no meaningful disagreement)
2. **If consensus is too high** (all personas agree on the approach with no pushback):
   - Launch **one additional sub-agent** as a devil's advocate, prompted to find the strongest argument against the consensus position
   - Use this prompt:
     ```
     You are a devil's advocate in a fast meeting.

     All participants agreed on this approach: {consensus_summary}

     Your job: find the strongest possible argument AGAINST this consensus.
     - What could go wrong that nobody mentioned?
     - What assumption are they all making that might be false?
     - What alternative did they dismiss too quickly?

     Be specific and concrete. Reference real failure scenarios.
     This is a research task — do NOT write or edit any files.
     ```
   - Include the dissenting view in the analysis even if the recommendation doesn't change
3. **If there is already meaningful disagreement:** proceed directly to Round 2

#### Round 2: Convergence (Single Synthesis)

After collecting all Round 1 responses, **you** (the facilitator, not a sub-agent) synthesize:

- Points of agreement across personas
- Key trade-offs that emerged
- The **winning recommendation** with rationale
- Concrete implementation plan (files to change, approach, order of operations)

**Do NOT launch a second round of sub-agents.** Synthesize directly for speed.

### Step 4: Produce the Compact Decision

Write a compact analysis displayed to the user:

```markdown
## Fast Meeting : [Sujet]

**Question :** [La question de décision]

**Participants :** [Name (Role)] | [Name (Role)] | [Name (Role)]

### Recommandation retenue
[The recommended approach in 2-3 sentences]

### Justification
- [Reason 1]
- [Reason 2]
- [Reason 3]

### Risques et mitigations
- [Risk 1 → Mitigation]
- [Risk 2 → Mitigation]

### Plan d'implémentation
1. [Step 1]
2. [Step 2]
3. [Step 3]
```

### Step 5: Scope Guard

Before implementing, estimate the scope of the recommended changes:

1. **Assess the scope:** count the estimated number of files to change, lines of code to add/modify, and whether new dependencies or infrastructure are needed
2. **Apply thresholds:**
   - **Small scope** (≤10 files, ≤500 lines, no new infrastructure): proceed to Step 6 normally
   - **Medium scope** (>10 files OR >500 lines): proceed but **scope down** to the most critical first step only. Add the remaining steps as a checklist in the MR/PR description under a `### Étapes restantes` section
   - **Large scope** (multi-service changes, architectural migration, new infrastructure required): **abort implementation**. Output the meeting analysis from Step 4, and suggest the user run the full `/meeting` skill for proper planning with validation before implementation
3. **If scoping down:** clearly state in the analysis what is being implemented now vs. deferred

### Step 6: Create Worktree and Implement

**Immediately proceed to implementation without asking the user.** This is the key difference from meeting.

Implementation runs in a **git worktree**, which creates an isolated copy of the repository. The user's working tree is **never modified** — no stash, no branch switch, no risk of state corruption.

#### Create the Worktree

1. **Record the current branch** for reference (e.g., `main`)
2. **Determine the branch type** based on the meeting recommendation:
   - Bug fix → `fix/`
   - New feature → `feat/`
   - Refactoring → `refactor/`
   - Default → `feat/`
3. **Fetch remote state** before checking for collisions:
   - Run `git fetch origin` to ensure branch information is up-to-date
4. **Check for branch name collisions** before creating the worktree:
   - Run `git branch -a` and check if `<type>/fm-<topic>` already exists (locally or as `remotes/origin/<type>/fm-<topic>`)
   - If the branch exists: append a numeric suffix (`-2`, `-3`, etc.) until a unique name is found. Do not force-delete existing branches — they may contain reviewed or in-progress work
5. **Create a worktree** with a dedicated branch:
   - Branch name: `<type>/fm-<short-kebab-case-topic>` (e.g., `feat/fm-jwt-auth-migration`, `fix/fm-notification-display`) — with suffix if collision was detected
   - Worktree path: `$(git rev-parse --show-toplevel)/../fm-<topic>`
   - Run: `git worktree add ../fm-<topic> -b <type>/fm-<topic>`
6. **If worktree creation fails:**
   - If the error indicates the branch already exists: run `git branch -D <type>/fm-<topic>` then retry the worktree creation
   - If it still fails (disk space, permissions, path length, submodules, or any other reason): **abort the implementation pipeline**. Output the complete meeting analysis from Step 4, the exact error message, and stop. The user can fix the underlying issue and re-run. **Never fall back to stash/checkout** — the user's working tree must never be modified

#### Implement in the Worktree

1. **All file modifications happen inside the worktree path** — use the worktree's absolute path for all read/write operations
2. **Implement the changes** as described in the implementation plan from Step 4
   - Write code, modify files, add tests as needed
   - Follow the project's existing conventions and patterns
3. **Stage and commit** all changes from within the worktree:
   - `cd` into the worktree path before running git commands
   - Use a conventional commit message: `feat(<scope>): <description>`
   - Include `Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>` in the commit message
   - **If `git commit` fails due to a pre-commit hook:** analyze the hook output, fix the code to pass the hook, and retry the commit once. If it still fails, treat it like a test failure — push as Draft with the hook error documented in the MR/PR description. Never use `--no-verify`

### Step 7: Test, Push, and Clean Up

#### Run Tests

After committing, validate the implementation against the project's test suite:

1. **Auto-detect the test runner:**
   - Check `package.json` for `test`, `test:unit`, `test:e2e` scripts
   - Check for `Makefile`, `pytest.ini`, `phpunit.xml`, or other test config files
   - If no test runner is found, skip this step and note "No test suite detected" in the MR/PR description
2. **Run the tests** (scoped to affected files/modules if the test runner supports it, otherwise run the full suite)
3. **If tests pass:** proceed to push
4. **If tests fail:**
   - Analyze the failures and attempt **one fix cycle** (fix the code, re-run tests)
   - If tests pass after the fix: amend the commit with the fix and proceed
   - If tests still fail after one fix attempt:
     - Mark the MR/PR as **Draft** (prefix title with `Draft:`)
     - Add a `### Tests en échec` section in the MR/PR description listing the failing tests and error messages
     - Push anyway so the team can review
5. **Include test results summary** in the MR/PR description: number of tests run, passed, failed

#### Push the Branch

1. **Push the branch** from within the worktree:
   - Run: `git push -u origin <type>/fm-<topic>` (from the worktree path)
   - **If push fails** (auth error, no remote, permission denied, network issue):
     - **Do NOT remove the worktree** — the committed work must be preserved
     - Output the worktree path, branch name, and the exact error message
     - Output a manual recovery command: `cd <worktree-path> && git push -u origin <branch>`
     - Skip Steps 8 and 9 entirely — there is nothing to link to
     - Proceed directly to the Run Summary (Step 10) with push status = "failed"

#### Clean Up Worktree

2. **Remove the worktree** (only after a successful push):
   - Return to the original repository path
   - Run: `git worktree remove ../fm-<topic>`
   - If removal fails (e.g., uncommitted changes in worktree), run: `git worktree remove ../fm-<topic> --force`
   - **Post-cleanup verification:** run `git worktree list` and verify the fast-meeting worktree no longer appears. If it does, output the cleanup command for the user: `git worktree remove <path> --force`
3. **No restoration needed:** the user's working tree was never modified — they remain on their original branch with all their uncommitted changes intact

### Step 8: Create the MR/PR

Based on the remote type detected in Step 1:

#### If GitLab:

Use `gitlab-mcp(create_merge_request)` to create a merge request with:
- **Title:** Short description (under 70 chars, in English)
- **Description:** The French meeting analysis and implementation summary (see template below)

#### If GitHub:

Use `gh pr create` to create a pull request with:
- **Title:** Short description (under 70 chars, in English)
- **Body:** The French meeting analysis and implementation summary (see template below)

#### If MR/PR creation fails:

If the MR/PR creation fails (API timeout, rate limit, authentication, MCP tool error):
- Output the remote URL and branch name
- Output a pre-formatted manual command the user can paste:
  - GitLab: provide the web URL to create the MR manually
  - GitHub: `gh pr create --head <branch> --title "<title>" --body "<body>"`
- Include the full MR/PR description text in the conversation output so nothing is lost
- Proceed to Step 9 (issue comment) if applicable — the issue comment is still valuable even without the MR/PR link
- Record the failure in the Run Summary (Step 10)

#### MR/PR Description Template (French — Developer / Technically Oriented)

The MR/PR description targets **developers reviewing the code**. Focus on technical details: what changed, why this approach was chosen technically, and what to watch during review.

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
_Implémentation générée automatiquement par IA_
```

### Step 9: Post to Issue (If Applicable — PO / Consultant Oriented)

If the subject is linked to a GitLab or GitHub issue, post a **Product Owner / consultant oriented** comment. This comment targets stakeholders, not developers — focus on business value, user impact, and strategic reasoning rather than technical details.

#### Issue Comment Template (French)

```markdown
## Analyse de réunion rapide

### Question posée
[La question de décision formulée en termes métier]

### Participants
| Expert | Rôle | Position |
|--------|------|----------|
| ... | ... | [Position résumée en termes d'impact métier] |

### Décision retenue
[L'approche recommandée expliquée en termes de valeur utilisateur et impact business]

**Pourquoi cette décision :**
- [Bénéfice utilisateur / métier 1]
- [Bénéfice utilisateur / métier 2]
- [Alignement avec les objectifs produit]

### Risques projet
- [Risque 1 formulé en impact métier → Mitigation]
- [Risque 2 formulé en impact métier → Mitigation]

### Impact
- **Utilisateurs concernés :** [Qui est impacté et comment]
- **Délai estimé :** [Si applicable]
- **Dépendances :** [Autres équipes ou fonctionnalités impactées]

### MR/PR
[Lien vers la MR/PR] — Les détails techniques d'implémentation sont dans la description de la MR/PR.

---
_Analyse générée automatiquement par IA_
```

Post the comment using the appropriate tool:
- **GitLab:** `gitlab-mcp(create_issue_note)`
- **GitHub:** `gh issue comment`

### Step 10: Run Summary

**Always output a structured run summary at the end of every fast-meeting run**, regardless of whether the pipeline succeeded or failed at any step. This provides observability for an autonomous pipeline.

```markdown
### Fast Meeting — Run Summary
- **Sujet :** [topic]
- **Branche :** `<type>/fm-<topic>`
- **Worktree :** [path] (nettoyé : oui/non)
- **Push :** succès / échec ([erreur si applicable])
- **MR/PR :** [URL] / non créé ([raison si applicable])
- **Tests :** [N exécutés, N passés, N échoués] / non détectés
- **Commentaire issue :** publié / ignoré (pas d'issue liée)
- **Durée totale :** [durée wall-clock de l'ensemble du pipeline]
```

If any step failed, the summary must include the failure reason and any manual recovery commands already provided in earlier steps.

## Meeting Quality Rules

### Persona Authenticity
- Each persona speaks consistently with their role and bias
- Personas use concrete examples, not abstract platitudes
- A security engineer talks about attack vectors, not vague "security concerns"
- A product owner talks about user impact and delivery timelines, not code patterns

### Speed Rules
- Maximum 3-4 personas per meeting
- Single round of parallel sub-agents + facilitator synthesis (no Round 2 debate)
- Optional devil's advocate sub-agent only when consensus is too high (adds ~10 seconds)
- No user confirmation before implementation
- Commit message and MR/PR are created automatically

### Implementation Quality
- Follow existing project conventions and patterns
- Write clean, tested code
- Run the project's test suite after implementation; attempt one fix cycle on failures
- Keep changes focused on the recommendation — do not over-engineer
- Scope guard: if changes exceed 10 files / 500 lines, scope down to the critical first step; if the scope is architectural, abort implementation and suggest `/meeting`
- Protect the user's working tree: implementation runs in an isolated git worktree — the user's working directory is never modified

## Examples

### Example 1: Technical Decision

```
User: fast-meeting : est-ce qu'on doit utiliser GraphQL ou REST pour la nouvelle API

→ Auto-selects: SOLID Alex (Backend), Pixel-Perfect Hugo (Frontend), Whiteboard Damien (Architect)
→ Runs fast meeting (1 round + synthesis)
→ Implements the recommended approach
→ Creates branch feat/fm-graphql-vs-rest-api
→ Commits, pushes, creates MR/PR with French description
```

### Example 2: Bug Fix with Issue

```
User: fast-meeting sur l'issue #42 - les notifications ne s'affichent pas

→ Fetches issue #42 details
→ Auto-selects: Pixel-Perfect Hugo (Frontend), SOLID Alex (Backend), Edge-Case Nico (QA)
→ Runs fast meeting
→ Implements the fix
→ Creates MR/PR, posts link on issue #42
```

### Example 3: Refactoring

```
User: fast-meeting : refactorer le module d'authentification pour supporter OAuth2

→ Auto-selects: Paranoid Shug (Security), SOLID Alex (Backend), Whiteboard Damien (Architect), Pipeline Mo (DevOps)
→ Runs fast meeting
→ Implements the refactoring
→ Creates MR/PR with French analysis
```

## Important Notes

- **Never create new labels** on GitLab or GitHub. When adding labels to issues or merge requests, only use labels that already exist in the project. If unsure which labels exist, list them first (`gh label list` for GitHub, or check existing issue labels for GitLab) and pick from the available ones. If no suitable label exists, skip labeling rather than creating a new one.
- **This skill does NOT ask for user confirmation** — it runs the full pipeline autonomously
- If tests fail after one fix attempt, mark the MR/PR as **Draft** and document the failures
- If the implementation scope is too large (architectural, multi-service), abort and suggest `/meeting` instead
- The user's working tree is always protected: implementation runs in an isolated git worktree — no stash, no branch switch, no risk of state corruption. If worktree creation fails, the pipeline aborts cleanly rather than falling back to stash/checkout
- Multiple fast-meetings can run in parallel on different worktrees — Step 0 only cleans up worktrees with no active processes, so parallel runs are safe
- When creating a MR/PR, check for other active fast-meeting branches with `git branch -r | grep '/fm-'`. If other branches exist, add a warning in the MR/PR description: _"Attention : d'autres branches fast-meeting sont actives. Vérifier les conflits potentiels avant merge."_
- The MR/PR description is always in French
- Branch names follow Git flow conventions: `<type>/fm-<topic>` (e.g., `feat/fm-<topic>`, `fix/fm-<topic>`) — determined automatically from the meeting recommendation
- If the remote type cannot be determined, default to `gh pr create` (GitHub)
- Never force-push or modify existing branches — always create a new branch
