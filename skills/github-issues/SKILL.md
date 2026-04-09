---
name: github-issues
description: "Crée, récupère, met à jour et gère les issues GitHub avec collecte complète du contexte. À utiliser quand l'utilisateur veut créer une nouvelle issue, voir les détails d'une issue, mettre à jour des issues existantes, lister les issues du projet, ajouter des commentaires ou gérer les workflows d'issues dans GitHub."
version: 1.2.0
license: MIT
metadata:
  author: Foundation Skills
---

# GitHub Issues Management

Create, retrieve, update, and manage GitHub issues with comprehensive context integration and structured workflows.

## Prerequisites

- **gh** (GitHub CLI): required for all issue operations — install from https://cli.github.com or `brew install gh`

## When to Use This Skill

Activate this skill when:
- The user wants to create a new GitHub issue
- The user asks to view or retrieve issue details
- The user needs to update an existing issue
- The user wants to list issues in a repository
- The user mentions managing issues, bug reports, or feature requests in GitHub
- The user wants to close, reopen, or modify issue properties
- The user needs to add comments or labels to issues
- The user wants to search for issues

## Critical Rules

**IMPORTANT: Always confirm owner/repo before creating or modifying issues**

**Always use descriptive issue titles and provide structured descriptions**

**Never create duplicate issues - search existing issues first when appropriate**

## Available CLI Commands

| Command | Purpose |
|---------|---------|
| `gh issue create` | Create new issues |
| `gh issue edit <number>` | Update existing issues |
| `gh issue view <number>` | Fetch issue details |
| `gh search issues "<query>"` | Search issues |
| `gh issue comment <number>` | Add comments |
| `gh issue list` | List repository issues |

## Workflow

### 1. Gather Context

First, collect information about the current repository and context:

- Identify the repository (owner and repo name)
- Understand the type of issue (bug, feature, task, etc.)
- Gather relevant labels, milestones, and assignees if applicable

### 2. Repository Verification

Before any operation, verify you have the correct repository identifier:

- Confirm repository exists
- Understand repository structure
- Check available labels and milestones

### 3. Issue Operations

#### Creating a New Issue

When creating issues, gather complete context:

**Required Information:**
- `owner`: Repository owner (organization or user)
- `repo`: Repository name
- `title`: Clear, descriptive issue title

**Optional but Recommended:**
- `body`: Detailed description in Markdown format
- `labels`: Label names (e.g., "bug,enhancement")
- `assignees`: Usernames to assign
- `milestone`: Milestone number (integer)

**Human-in-the-Loop - Ask for Context**

Always ask to clarify issue details:

```
Question: "What type of issue is this?"
Options:
- "Bug report - something is not working correctly"
- "Feature request - new functionality needed"
- "Task - work item to complete"
- "Documentation - documentation needs update"
- "Other - let me describe it"
```

**Title Guidelines:**
- Start with type prefix when useful: `[Bug]`, `[Feature]`, `[Docs]`
- Be specific and actionable
- Keep under 72 characters
- Examples:
  - `[Bug] Login fails with SSO enabled`
  - `[Feature] Add dark mode support`
  - `Add unit tests for auth module`

**Issue Description Template:**

Structure descriptions for clarity:

```markdown
## Summary
[Brief description of the issue]

## Current Behavior
[What is happening now - for bugs]

## Expected Behavior
[What should happen - for bugs]

## Steps to Reproduce
[For bugs - numbered steps]

## Acceptance Criteria
[For features/tasks - what defines "done"]

## Additional Context
[Screenshots, logs, related issues, etc.]
```

#### Retrieving Issue Details

Use `gh issue view <number>` with:
- `<number>`: Issue number (e.g., 42)

This returns complete issue information including:
- Title and body
- State (open/closed)
- Labels and milestone
- Assignees and author
- Created/updated timestamps

#### Listing Issues

Use `gh issue list` with filters:
- `--state`: "open", "closed", or "all"
- `--label`: Filter by labels (comma-separated)
- `--assignee`: Filter by assignee username
- `--search`: Search in title and description
- `--sort`: Sort by "created", "updated", "comments"
- `--order`: "asc" or "desc"
- `--limit`: Results per page (default 30)

#### Searching Issues

Use `gh search issues "<query>"` for advanced queries:
- Search across repositories
- Use GitHub search qualifiers (is:open, label:bug, etc.)
- Full-text search in titles and bodies

#### Updating an Issue

When updating issues, only provide changed fields:

Use `gh issue edit <number>` with flags for fields to update (--title, --body, --add-label, --remove-label, --add-assignee, --milestone, etc.)

**State Changes:**
- `gh issue reopen <number>` - Open/reopen the issue
- `gh issue close <number>` - Close the issue

#### Adding Comments

Use `gh issue comment <number> --body "<comment>"` with:
- `<number>`: Issue number
- `<comment>`: Comment content in Markdown

### 4. Execute Operations (Requires Confirmation)

**CRITICAL: Confirm with user before creating or modifying issues**

After gathering all information, present a summary for user approval:

```
Creating issue in repository: owner/repo
Title: [title]
Description: [summary]
Labels: [labels]
Assignee: [assignee]

Proceed with issue creation?
```

## Issue Type Templates

### Bug Report

```markdown
## Description
The [component] is experiencing [issue] when [condition].

## Steps to Reproduce
1. [First step]
2. [Second step]
3. [See error]

## Expected Behavior
[What should happen]

## Actual Behavior
[What actually happens]

## Environment
- Application Version: [version]

## Screenshots/Logs
[Attach relevant files]

## Possible Solution
[Optional: if you have ideas]
```

### Feature Request

```markdown
## Summary
[One-line description of the feature]

## Motivation
[Why is this feature needed? What problem does it solve?]

## Proposed Solution
[How should this work?]

## Acceptance Criteria
- [ ] [Criterion 1]
- [ ] [Criterion 2]
- [ ] [Criterion 3]

## Alternatives Considered
[Other approaches considered]

## Additional Context
[Mockups, examples, references]
```

### Task

```markdown
## Task Description
[What needs to be done]

## Background
[Why is this needed?]

## Requirements
- [ ] [Requirement 1]
- [ ] [Requirement 2]

## Definition of Done
- [ ] [Criterion 1]
- [ ] [Criterion 2]

## Dependencies
[Related issues, blockers]
```

## Examples

### Example 1: Creating a Bug Report

**User:** "Create a bug issue - the login page crashes when using SSO"

**AI Workflow:**
1. Ask for repository (owner/repo) if not known
2. Ask clarifying questions about the bug
3. Generate structured description
4. Present summary for confirmation
5. Create issue with `gh issue create --title "[Bug] Login page crashes when using SSO" --body "<description>" --label "bug"`

**Result:**
```
gh issue create \
  --title "[Bug] Login page crashes when using SSO" \
  --body "## Description
The login page crashes when users attempt to authenticate using SSO.

## Steps to Reproduce
1. Navigate to login page
2. Click 'Sign in with SSO'
3. Page crashes

## Expected Behavior
SSO authentication should complete and redirect to dashboard.

## Actual Behavior
Page becomes unresponsive and displays error.

## Environment
- Browser: [To be filled]
- OS: [To be filled]" \
  --label "bug"
```

### Example 2: Feature Request with Priority

**User:** "Create a feature request for dark mode with high priority"

**AI Workflow:**
1. Gather feature details
2. Structure the request
3. Add appropriate labels
4. Confirm and create

**Result:**
```
gh issue create \
  --title "[Feature] Add dark mode support" \
  --body "## Summary
Add dark mode theme option for improved user experience and accessibility.

## Motivation
- Reduces eye strain in low-light environments
- Increasingly expected by users
- Improves accessibility

## Proposed Solution
Implement theme toggle with system preference detection.

## Acceptance Criteria
- [ ] Toggle switch in settings
- [ ] Persists user preference
- [ ] Respects system preference by default
- [ ] All UI components support both themes" \
  --label "enhancement,high-priority"
```

### Example 3: Listing and Filtering Issues

**User:** "Show me all open bugs assigned to me"

**AI Workflow:**
1. Use `gh issue list --state open --label bug --assignee @me`

**Result:**
```
Found 3 open bug issues assigned to you:

#142 - [Bug] API timeout on large file uploads
      Labels: bug, priority-medium
      Created: 2024-01-15

#138 - [Bug] Dashboard graphs not rendering on Safari
      Labels: bug, frontend
      Created: 2024-01-12

#125 - [Bug] Email notifications delayed by 30+ minutes
      Labels: bug, priority-high
      Created: 2024-01-08
```

### Example 4: Closing an Issue with Comment

**User:** "Close issue #142 and add a comment that it's fixed in v2.4.0"

**AI Workflow:**
1. First, add a comment to the issue: `gh issue comment 142 --body "Fixed in v2.4.0. Closing this issue."`
2. Then close the issue: `gh issue close 142`

**Result:**
```
Issue #142 has been commented and closed.
```

## Common Labels

Use these standard labels when applicable:

| Label | Use For |
|-------|---------|
| `bug` | Something isn't working |
| `enhancement` | New feature or improvement |
| `documentation` | Documentation updates |
| `good first issue` | Good for newcomers |
| `help wanted` | Extra attention needed |
| `question` | Further information requested |
| `wontfix` | Will not be addressed |
| `duplicate` | Already exists |
| `invalid` | Not a valid issue |

## Important Notes

- **Always verify repository access** - Ensure you have permission to create/modify issues
- **Use labels consistently** - Follow repository labeling conventions
- **Be specific in titles** - Prefix with [Bug], [Feature], [Task] for clarity
- **Include reproduction steps** - Essential for bug reports
- **Define acceptance criteria** - Clear "definition of done" for features/tasks
- **Link related issues** - Use "Related to #XX" or "Blocks #XX" in descriptions
- **Mention users with @username** - For visibility and notifications
- **Use milestones** - Associate issues with releases when applicable

## GitHub Issue Best Practices

### Writing Effective Titles
- Be concise but descriptive
- Include issue type prefix: [Bug], [Feature], [Task], [Docs]
- Mention affected component if applicable
- Avoid vague titles like "Fix bug" or "Update code"

### Structuring Descriptions
- Use Markdown formatting for readability
- Include all relevant context upfront
- Add screenshots or logs when helpful
- Link to related issues, PRs, or documentation
- Use task lists for trackable sub-items

### Label Strategy
- Combine type labels (`bug`, `enhancement`) with area labels (`frontend`, `api`)
- Use priority labels when needed (`priority-high`, `priority-low`)
- Keep label taxonomy consistent across repositories

### Assignment and Workflow
- Assign issues to specific team members
- Use milestones for release planning
- Update issue status as work progresses
- Close issues with reference to fixing PR: "Fixes #XX"
