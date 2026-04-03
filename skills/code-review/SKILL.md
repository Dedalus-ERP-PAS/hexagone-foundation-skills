---
name: code-review
description: "Effectue des revues de code complètes des merge requests GitLab, analysant la qualité du code, la sécurité, les performances et les bonnes pratiques. À utiliser quand l'utilisateur dit « code review » ou demande de revoir des merge requests ou d'analyser les changements d'une branche avant fusion."
version: 2.0.0
license: MIT
metadata:
  author: Foundation Skills
---

# Code Review

Perform comprehensive code reviews of GitLab merge requests, providing actionable feedback on code quality, security, performance, and best practices.

## GitLab Instance Configuration

This skill is configured for a self-hosted GitLab instance:
- **GitLab URL:** https://gitlab-erp-pas.dedalus.lan
- All project identifiers, URLs, and references should use this self-hosted instance
- Ensure you have appropriate access credentials configured for this GitLab server

## When to Use This Skill

Activate this skill when:
- The user types "review" or "code review" (with or without slash command)
- The user types "review MR-123" or "review !123" to review a specific merge request
- The user types "review ISSUE-ID" (e.g., "review #456") to review the MR associated with a GitLab issue
- The user asks to review a merge request
- Analyzing code changes before merging
- Performing code quality assessments
- Checking for security vulnerabilities or performance issues
- Reviewing merge request diffs

## Critical Rules

**IMPORTANT: Always confirm project_id before reviewing merge requests**

**Always provide constructive feedback framed as questions, not directives**

**Only review changes introduced in the merge request, not unrelated code**

## Workflow

### 1. Identify the Merge Request

#### Merge Request IID Provided

**If a merge request IID is provided** (e.g., "review !123" or "review MR 123"):

1. Extract the MR IID from the user input
2. Verify the project context (ask user if not clear)
3. Fetch merge request details using `glab mr view <iid>`

#### GitLab Issue ID Provided

**If a GitLab issue ID is provided** (e.g., "review #456"):

1. Fetch issue details using `glab issue view <iid>` to understand context
2. Find related merge requests using `glab mr list --search "<issue reference>"`
3. If multiple MRs found, ask user to select the one to review
4. Proceed with the selected MR

#### No Specific MR Provided

**If no MR is specified** (e.g., just "review"):

1. List recent open merge requests using `glab mr list --state opened`
2. Present the list to the user
3. Ask user to select which MR to review

### 2. Gather Merge Request Context

**Self-hosted GitLab Instance:** https://gitlab-erp-pas.dedalus.lan

Use `glab mr view <iid>` to retrieve:

- Title and description
- Source and target branches
- Author information
- State (open, merged, closed)
- Labels and milestones
- Approval status
- Pipeline status
- `diff_refs` (base_sha, head_sha, start_sha) for accurate diff comparison

**Extract key information:**
```
Project: namespace/project
MR: !123 - "Feature: Add user authentication"
Author: @username
Source: feature/auth -> Target: main
Status: Open | Pipeline: Passed | Approvals: 1/2
```

### 3. Analyze the Changes

#### Get File Changes

Use `glab mr diff <iid>` to retrieve:
- List of changed files
- Additions and deletions per file
- Diff content for each file

**Pagination**: If many files changed, the diff output may be large — review it in sections.

#### Get Detailed File Content

For complex changes, use `git show <ref>:<file_path>` to:
- View the complete file context
- Understand surrounding code
- Check for consistency with existing patterns

**Parameters:**
- `<ref>`: Use the source branch or head_sha from diff_refs
- `<file_path>`: Path to the file

#### Analyze Commits

Use `git log --oneline <source_branch>` to list commits, then use `git show <sha>` to:
- Understand commit history
- Review individual commit changes
- Check commit message quality

### 4. Check Existing Discussions

Use `glab api /projects/:id/merge_requests/:iid/discussions` to:
- Review existing feedback and discussions
- Avoid duplicate comments
- Understand ongoing conversations
- Check for unresolved threads

### 5. Check Pipeline Status

Use `glab ci list` and `glab ci view <pipeline_id>` to:
- Verify CI/CD pipeline status
- Check for failed jobs
- Review test results

If pipeline failed, use `glab ci trace <job_id>` to understand failures.

### 6. Perform Comprehensive Code Review

Conduct a thorough review of **only the changes introduced in this merge request**.

#### Code Quality Assessment

- Code style and formatting consistency
- Variable and function naming conventions
- Code organization and structure
- Adherence to DRY (Don't Repeat Yourself) principles
- Proper abstraction levels

#### Technical Review

- Logic correctness and edge cases
- Error handling and validation
- Performance implications
- Security considerations (input validation, SQL injection, XSS, etc.)
- Resource management (memory leaks, connection handling)
- Concurrency issues if applicable

#### Best Practices Check

- Design patterns usage
- SOLID principles adherence
- Testing coverage implications
- Documentation completeness
- API consistency
- Backwards compatibility

#### Dependencies and Integration

- New dependencies added
- Breaking changes to existing interfaces
- Impact on other parts of the system
- Database migration requirements

### 7. Generate Review Report

Create a structured code review report with:

1. **Executive Summary**: High-level overview of changes and overall assessment

2. **Statistics**:
   - Files changed, lines added/removed
   - Commits reviewed
   - Critical issues found

3. **Strengths**: What was done well

4. **Issues by Priority**:
   - 🔴 **Critical**: Must fix before merging (bugs, security issues)
   - 🟡 **Important**: Should address (performance, maintainability)
   - 🟢 **Suggestions**: Nice to have improvements

5. **Detailed Findings**: For each issue include:
   - File and line reference
   - A question framing the concern
   - Context explaining why you're asking
   - Code example if helpful

6. **Security Review**: Specific security considerations

7. **Performance Review**: Performance implications

8. **Testing Recommendations**: What tests should be added

9. **Documentation Needs**: What documentation should be updated

### 8. Add Comments to Merge Request (Optional)

**CRITICAL: Ask user before adding comments to the MR**

If user wants to add feedback directly to the MR:

#### General Comment

Use `glab mr note <iid> --message "<comment>"` to add a general comment:
- `<iid>`: MR internal ID
- `<comment>`: Comment content in Markdown

#### Line-Specific Discussion

Use `glab api POST /projects/:id/merge_requests/:iid/discussions` for code-specific feedback with:
- `body`: Discussion content
- `position`: Object with diff position details:
  - `base_sha`: From diff_refs
  - `head_sha`: From diff_refs
  - `start_sha`: From diff_refs
  - `new_path`: File path
  - `new_line`: Line number for new code
  - `old_path`: File path (for modifications)
  - `old_line`: Line number for removed code

## Feedback Style: Questions, Not Directives

**Frame all feedback as questions, not commands.** This encourages dialogue and respects the author's context.

### Examples

❌ **Don't write:**
- "You should use early returns here"
- "This needs error handling"
- "Extract this into a separate function"
- "Add a null check"

✅ **Do write:**
- "Could this be simplified with an early return?"
- "What happens if this API call fails? Would error handling help here?"
- "Would it make sense to extract this into its own function for reusability?"
- "Is there a scenario where this could be null? If so, how should we handle it?"

### Why Questions Work Better

- The author may have context you don't have
- Questions invite explanation rather than defensiveness
- They acknowledge uncertainty in the reviewer's understanding
- They create a conversation rather than a checklist

## Review Report Template

```markdown
# Code Review: !{MR_IID} - {MR_TITLE}

## Executive Summary
{Brief overview of changes and overall assessment}

## Merge Request Details
- **Project**: {project_path}
- **Author**: @{author}
- **Source Branch**: {source_branch} → **Target**: {target_branch}
- **Pipeline Status**: {status}
- **Approvals**: {current}/{required}

## Statistics
| Metric | Count |
|--------|-------|
| Files Changed | {count} |
| Lines Added | +{additions} |
| Lines Removed | -{deletions} |
| Commits | {commit_count} |

## Strengths
- {strength_1}
- {strength_2}

## Issues Found

### 🔴 Critical
{critical_issues_or_none}

### 🟡 Important
{important_issues_or_none}

### 🟢 Suggestions
{suggestions_or_none}

## Security Review
{security_findings}

## Performance Review
{performance_findings}

## Testing Recommendations
- {test_recommendation_1}
- {test_recommendation_2}

## Documentation Needs
- {doc_need_1}

## Verdict
{APPROVED | CHANGES_REQUESTED | NEEDS_DISCUSSION}
```

## Examples

### Example 1: Review a Specific Merge Request

```
User: Review !42 in namespace/project

Assistant actions:
1. glab mr view 42 — fetch MR details
2. glab mr diff 42 — get file changes
3. glab api /projects/:id/merge_requests/42/discussions — check existing feedback
4. glab ci list — check CI status
5. Analyze changes and generate report
6. Present review to user
7. Ask if user wants comments added to the MR
```

### Example 2: Review MR Related to an Issue

```
User: Review the MR for issue #123

Assistant actions:
1. glab issue view 123 — fetch issue details
2. glab mr list --search "#123" — find related MRs
3. Present found MRs and ask user to confirm
4. Proceed with code review workflow
```

### Example 3: List Open MRs for Review

```
User: Show me open merge requests to review

Assistant actions:
1. glab mr list --state opened — list open MRs
2. Present list with key details (title, author, pipeline status)
3. Ask user which MR to review
```

## Important Notes

- **Only review changes from THIS merge request** - do not comment on code that wasn't changed
- Frame feedback as questions to encourage dialogue
- Be constructive and specific in feedback
- Provide code examples for suggested improvements
- Acknowledge good practices and improvements
- Prioritize issues clearly (Critical > Important > Suggestions)
- Consider the context and purpose of changes
- Check pipeline status before concluding review
- Review existing discussions to avoid duplicate feedback
- **Always ask before adding comments to the MR**
- Verify the review addresses acceptance criteria if linked to an issue
