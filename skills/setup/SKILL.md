---
name: setup
description: "Installe les outils CLI prérequis (gh, glab, jq), guide l'authentification GitHub/GitLab, installe uvx et configure le serveur MCP mcp-atlassian pour Jira dans OpenCode. Idempotent : relancer le skill est sans danger. Déclenché quand l'utilisateur dit « setup », « install prerequisites » ou « configurer jira »."
version: 1.0.1
license: MIT
---

# Setup — Prerequisites & MCP Configuration

Install CLI tools, authenticate to GitHub/GitLab, and configure the `mcp-atlassian` Jira integration for OpenCode.

## Prerequisites

- Linux with `apt` package manager
- `bash` and `curl` available
- Internet access (for apt packages and uv installer)

## Trigger

User says: "setup", "install prerequisites", "configure jira", or similar.

> **Important — interactive skill only.** This skill requires user interaction (auth prompts, Jira credentials). It must **not** be called as a sub-step from autonomous skill pipelines (fast-meeting, issue-review, etc.) — doing so will stall the pipeline waiting for input that will never arrive.

---

## Workflow

### Phase 1 — Install CLI tools

Run the bundled script to install missing tools (idempotent — skips already-installed ones):

```bash
bash "$(dirname "$0")/reference/setup.sh"
```

The script installs (via `apt` if not already present):
- `gh` — GitHub CLI
- `glab` — GitLab CLI
- `jq` — JSON processor
- `uvx` — via the official `uv` installer (`curl -LsSf https://astral.sh/uv/install.sh | sh`)

After running, inform the user of what was installed vs. already present.

### Phase 2 — CLI Authentication

Check and authenticate each CLI:

```bash
gh auth status 2>&1
```

- Show the full output to the user (current logged-in account, token scopes, etc.)
- If not authenticated → tell the user: "Run `gh auth login` and follow the prompts."
- Do NOT run `gh auth login` automatically (requires interactive input).

```bash
glab auth status 2>&1
```

- Show the full output to the user (GitLab instance, current user, token validity, etc.)
- If not authenticated → tell the user: "Run `glab auth login` and follow the prompts."
- Do NOT run `glab auth login` automatically.

### Phase 3 — Configure mcp-atlassian for Jira

**Step 3.1 — Check if uvx is available:**

```bash
uvx --version 2>&1 || ~/.local/bin/uvx --version 2>&1
```

If not found, remind the user to restart their shell or source `~/.bashrc` / `~/.profile` after the Phase 1 script ran.

**Step 3.2 — Read existing OpenCode config:**

Use the Read tool to read `~/.config/opencode/opencode.json`.

- If the file does not exist, treat it as `{}`.
- If `mcp.mcp-atlassian` is already present → confirm to the user and skip the rest of Phase 3.

**Step 3.3 — Gather credentials (if not already configured):**

Ask the user these two questions in a single message:

1. **Jira URL** — default `https://jira.dedalus.com/` (Server/Data Center). Press Enter to accept.
2. **Jira Personal Access Token (PAT)** — steps to generate one:
   - Log in to your Jira instance
   - Go to **Profile → Personal Access Tokens**
   - Click **Create token**, give it a name, set an expiry
   - Copy the token and paste it here

> For **Jira Cloud** users: use `JIRA_USERNAME` (your email) + `JIRA_API_TOKEN` (from https://id.atlassian.com/manage-profile/security/api-tokens) instead of a PAT.

**Step 3.4 — Write the config:**

Merge the `mcp-atlassian` block into `~/.config/opencode/opencode.json`, preserving any existing content. Use the Write tool to write the final JSON.

For **Server/Data Center** (default):

```json
{
  "mcp": {
    "mcp-atlassian": {
      "type": "local",
      "command": ["uvx", "mcp-atlassian"],
      "environment": {
        "JIRA_URL": "<jira-url>",
        "JIRA_PERSONAL_TOKEN": "<pat>"
      },
      "enabled": true
    }
  }
}
```

For **Cloud** (if user specifies):

```json
{
  "mcp": {
    "mcp-atlassian": {
      "type": "local",
      "command": ["uvx", "mcp-atlassian"],
      "environment": {
        "JIRA_URL": "<jira-url>",
        "JIRA_USERNAME": "<email>",
        "JIRA_API_TOKEN": "<api-token>"
      },
      "enabled": true
    }
  }
}
```

**Step 3.5 — Secure the config file:**

```bash
chmod 600 ~/.config/opencode/opencode.json
```

### Phase 4 — Summary

Print a clear summary table:

| Component | Status |
|-----------|--------|
| gh | installed / already ok |
| glab | installed / already ok |
| jq | installed / already ok |
| uvx | installed / already ok |
| gh auth | authenticated / action needed |
| glab auth | authenticated / action needed |
| mcp-atlassian | configured / already ok / skipped |

End with: "Restart OpenCode to load the new MCP configuration."
