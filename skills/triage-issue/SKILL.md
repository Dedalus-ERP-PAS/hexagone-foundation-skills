---
name: triage-issue
description: "Trier un bug ou une issue en explorant le codebase pour trouver la cause racine, puis créer une issue GitLab ou GitHub avec un plan de correction basé sur le TDD. À utiliser quand l'utilisateur signale un bug, veut créer une issue, mentionne « triage » ou veut investiguer et planifier la correction d'un problème."
version: 1.1.0
license: MIT
metadata:
  author: Foundation Skills
  adapted-from: DamienBattistella/skills/triage-issue
---

# Triage Issue

Investigate a reported problem, find its root cause, and create a GitLab or GitHub issue with a TDD fix plan. This is a mostly hands-off workflow -- minimize questions to the user.

## When to Use This Skill

Activate this skill when:
- The user reports a bug or unexpected behavior
- The user says "triage" or "investigate this issue"
- The user wants to file an issue after encountering a problem
- The user wants to understand root cause and plan a fix
- The user asks to create a bug report with investigation

## Process

### 1. Capture the Problem

Get a brief description of the issue from the user. If they haven't provided one, ask ONE question: "What's the problem you're seeing?"

Do NOT ask follow-up questions yet. Start investigating immediately.

### 2. Explore and Diagnose

Deeply investigate the codebase. Your goal is to find:

- **Where** the bug manifests (entry points, UI, API responses)
- **What** code path is involved (trace the flow)
- **Why** it fails (the root cause, not just the symptom)
- **What** related code exists (similar patterns, tests, adjacent modules)

Look at:
- Related source files and their dependencies
- Existing tests (what's tested, what's missing)
- Recent changes to affected files (`git log` on relevant files)
- Error handling in the code path
- Similar patterns elsewhere in the codebase that work correctly

### 3. Identify the Fix Approach

Based on your investigation, determine:

- The minimal change needed to fix the root cause
- Which modules/interfaces are affected
- What behaviors need to be verified via tests
- Whether this is a regression, missing feature, or design flaw

### 4. Design TDD Fix Plan

Create a concrete, ordered list of RED-GREEN cycles. Each cycle is one vertical slice:

- **RED**: Describe a specific test that captures the broken/missing behavior
- **GREEN**: Describe the minimal code change to make that test pass

Rules:
- Tests verify behavior through public interfaces, not implementation details
- One test at a time, vertical slices (NOT all tests first, then all code)
- Each test should survive internal refactors
- Include a final refactor step if needed
- **Durability**: Only suggest fixes that would survive radical codebase changes. Describe behaviors and contracts, not internal structure. Tests assert on observable outcomes (API responses, UI state, user-visible effects), not internal state. A good suggestion reads like a spec; a bad one reads like a diff.

### 5. Detect the Platform

Before creating the issue, detect whether the project uses GitLab or GitHub:

1. **Check for GitLab indicators:**
   - File `.gitlab-ci.yml` exists at the repository root
   - Git remote URL contains `gitlab` (e.g., `git remote -v`)
2. **Check for GitHub indicators:**
   - Directory `.github/` exists at the repository root
   - Git remote URL contains `github.com` (e.g., `git remote -v`)
3. **Fallback:** If both or neither are detected, ask the user: "This project seems to use both GitLab and GitHub (or I couldn't detect which). Which platform should I create the issue on?"

### 6. Create the Issue

Create the issue on the detected platform. Do NOT ask the user to review before creating -- just create it and share the URL.

#### For GitHub

Use `gh issue create` with the issue template below.

#### For GitLab

Use the GitLab CLI (`glab issue create`) or the GitLab API via CLI. You will need the `project_id` (URL-encoded path like `group/project` or numeric ID). If uncertain, derive it from the git remote URL.

#### Issue Template

Use this template for both platforms (the Markdown format is compatible with both GitLab and GitHub):

```markdown
## Problem

A clear description of the bug or issue, including:
- What happens (actual behavior)
- What should happen (expected behavior)
- How to reproduce (if applicable)

## Root Cause Analysis

Describe what you found during investigation:
- The code path involved
- Why the current code fails
- Any contributing factors

Do NOT include specific file paths, line numbers, or implementation details that couple to current code layout. Describe modules, behaviors, and contracts instead. The issue should remain useful even after major refactors.

## TDD Fix Plan

A numbered list of RED-GREEN cycles:

1. **RED**: Write a test that [describes expected behavior]
   **GREEN**: [Minimal change to make it pass]

2. **RED**: Write a test that [describes next behavior]
   **GREEN**: [Minimal change to make it pass]

...

**REFACTOR**: [Any cleanup needed after all tests pass]

## Related Issues

[Link to any existing issues that reported this bug or are related. Use `#<number>` for same-project references, or full URLs for cross-project references. If this was reported in an issue tracker, link to the original report here.]

## Acceptance Criteria

- [ ] Root cause is fixed, not just the symptom
- [ ] All new tests pass
- [ ] Existing tests still pass
- [ ] [Additional criteria specific to this bug]
```

#### Platform-Specific Notes

**GitHub:**
- Use labels like `bug`, `triage`, or project-specific labels
- The `gh issue create` command supports `--title`, `--body`, and `--label` flags
- Link related issues with `#<number>` syntax
- Reference PRs that fix the issue with "Fixes #XX" in the PR description

**GitLab:**
- Use scoped labels like `bug`, `priority::high`, `status::triage`
- Link related issues with `#<number>` for same-project or `group/project#<number>` for cross-project
- Reference MRs that fix the issue with "Closes #XX" in the MR description
- If the self-hosted GitLab instance is available, use its URL for all references

### 7. Report Back

After creating the issue:
1. Print the issue URL
2. Print a one-line summary of the root cause
3. If this bug was originally reported in an existing issue, mention that the new triage issue links back to it

## Critical Rules

- **Investigate first, ask later.** Do not pepper the user with questions. Explore the codebase yourself and only ask the user when you are genuinely stuck.
- **No file paths in issue descriptions.** File paths go stale after refactors. Describe modules, behaviors, and contracts instead. The issue should remain useful even after the codebase evolves.
- **TDD-based fix plans only.** Every fix must be described as a sequence of RED-GREEN cycles. No vague "fix the bug" instructions.
- **Durability over precision.** A good issue reads like a behavioral spec. A bad issue reads like a diff against today's code.
- **Link to existing issues.** If the user mentions an existing issue number, or if you find a related issue during investigation, always link to it in the "Related Issues" section.
- **One issue per root cause.** If investigation reveals multiple independent bugs, create separate issues for each.
