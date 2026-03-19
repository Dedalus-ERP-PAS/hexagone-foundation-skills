---
name: git-guardrails
description: "Configure des hooks Claude Code pour bloquer les commandes git dangereuses (push, force-push, reset --hard, clean, branch -D, checkout/restore) avant leur exécution. Empêche les opérations git destructrices au niveau de l'agent."
version: 1.0.0
license: MIT
metadata:
  author: Foundation Skills
  adapted_from: DamienBattistella/skills/git-guardrails-claude-code
---

# Git Guardrails

Sets up a PreToolUse hook that intercepts and blocks dangerous git commands before Claude Code executes them.

## When to Use This Skill

Activate when the user:
- Wants to prevent destructive git operations from being run by the AI agent
- Asks to add git safety hooks to Claude Code
- Wants to block `git push`, `git reset --hard`, or other dangerous commands
- Is setting up a new project and wants guardrails on git operations

## What Gets Blocked

The following commands are intercepted and blocked before execution:

| Pattern | Description |
|---------|-------------|
| `git push` | All push variants (prevents unreviewed pushes) |
| `git push --force` | Force push (rewrites remote history) |
| `git push --force-with-lease` | Force push variant |
| `git reset --hard` | Discards all uncommitted changes |
| `git clean -f` / `git clean -fd` | Deletes untracked files permanently |
| `git branch -D` | Force-deletes a branch without merge check |
| `git checkout .` | Discards all working tree changes |
| `git restore .` | Discards all working tree changes |
| `git rebase` on main/master | Prevents rebase of protected branches |

When blocked, Claude sees a message telling it that it does not have authority to run these commands. The user must run them manually if needed.

## Setup Steps

### Step 1: Ask Scope

Ask the user: install for **this project only** (`.claude/settings.json`) or **all projects** (`~/.claude/settings.json`)?

### Step 2: Copy the Hook Script

The bundled script is at: [reference/block-dangerous-git.sh](reference/block-dangerous-git.sh)

Copy it to the target location based on scope:

- **Project**: `.claude/hooks/block-dangerous-git.sh`
- **Global**: `~/.claude/hooks/block-dangerous-git.sh`

Make it executable:

```bash
chmod +x <path-to-script>
```

### Step 3: Add Hook to Settings

Add to the appropriate settings file.

**Project scope** (`.claude/settings.json`):

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/block-dangerous-git.sh"
          }
        ]
      }
    ]
  }
}
```

**Global scope** (`~/.claude/settings.json`):

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/block-dangerous-git.sh"
          }
        ]
      }
    ]
  }
}
```

If the settings file already exists, merge the hook into the existing `hooks.PreToolUse` array. Do not overwrite other settings.

### Step 4: Ask About Customization

Ask if the user wants to add or remove any patterns from the blocked list. Edit the copied script accordingly.

Common additions users may want:
- Block `git stash drop` (prevents accidental stash loss)
- Block `git tag -d` (prevents tag deletion)
- Allow `git push` but only block `--force` variants

### Step 5: Verify Installation

Run a quick test to confirm the hook works:

```bash
echo '{"tool_input":{"command":"git push origin main"}}' | <path-to-script>
```

Expected result: exits with code 2 and prints a `BLOCKED` message to stderr.

Run a second test with a safe command:

```bash
echo '{"tool_input":{"command":"git status"}}' | <path-to-script>
```

Expected result: exits with code 0 (allowed).

## How It Works

Claude Code supports [PreToolUse hooks](https://docs.anthropic.com/en/docs/claude-code/hooks) that run before any tool invocation. The hook:

1. Receives the tool input as JSON on stdin
2. Extracts the `command` field using `jq`
3. Checks the command against a list of dangerous patterns
4. If a match is found, exits with code 2 (which tells Claude the command is blocked)
5. If no match, exits with code 0 (which allows normal execution)

## Important Notes

- The hook only blocks commands run by the AI agent. The user can still run any git command manually in their terminal.
- The blocked patterns use regex matching, so `git push` also catches `git push origin main --force`.
- If `jq` is not installed, the script will fail open (allow all commands). Ensure `jq` is available.
- The hook does not modify any git configuration; it only intercepts Claude Code tool calls.
