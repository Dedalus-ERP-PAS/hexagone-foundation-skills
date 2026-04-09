#!/bin/bash
# setup.sh
# Installs prerequisite CLI tools for Foundation Skills on Linux (apt).
# Idempotent: safe to run multiple times — skips already-installed tools.
#
# Tools installed:
#   gh    — GitHub CLI
#   glab  — GitLab CLI
#   jq    — JSON processor
#   uvx   — via the official uv installer (curl)

set -euo pipefail

INSTALLED=()
SKIPPED=()

# ── Helper ────────────────────────────────────────────────────────────────────

apt_install() {
  local pkg="$1"
  local cmd="${2:-$1}"
  if command -v "$cmd" &>/dev/null; then
    SKIPPED+=("$cmd")
  else
    echo "→ Installing $pkg..."
    sudo apt-get update -qq
    sudo apt-get install -y "$pkg"
    INSTALLED+=("$cmd")
  fi
}

# ── Phase 1: jq (no extra repo needed) ───────────────────────────────────────

apt_install jq

# ── Phase 2: gh (GitHub CLI) ─────────────────────────────────────────────────

if command -v gh &>/dev/null; then
  SKIPPED+=(gh)
else
  echo "→ Installing gh (GitHub CLI)..."
  sudo apt-get update -qq
  sudo apt-get install -y gh 2>/dev/null || {
    # Fallback: add the official GitHub CLI apt repo
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
      | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] \
https://cli.github.com/packages stable main" \
      | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt-get update -qq
    sudo apt-get install -y gh
  }
  INSTALLED+=(gh)
fi

# ── Phase 3: glab (GitLab CLI) ───────────────────────────────────────────────

if command -v glab &>/dev/null; then
  SKIPPED+=(glab)
else
  echo "→ Installing glab (GitLab CLI)..."
  GLAB_VERSION=$(curl -s https://gitlab.com/api/v4/projects/34675721/releases \
    | grep -oP '"tag_name":"\Kv[^"]+' | head -1)
  GLAB_VERSION="${GLAB_VERSION:-v1.46.0}"
  ARCH=$(dpkg --print-architecture)
  curl -fsSL "https://gitlab.com/gitlab-org/cli/-/releases/${GLAB_VERSION}/downloads/glab_${GLAB_VERSION#v}_linux_${ARCH}.deb" \
    -o /tmp/glab.deb
  sudo apt-get install -y /tmp/glab.deb
  rm -f /tmp/glab.deb
  INSTALLED+=(glab)
fi

# ── Phase 4: uvx (via uv installer) ──────────────────────────────────────────

if command -v uvx &>/dev/null || [ -x "${HOME}/.local/bin/uvx" ]; then
  SKIPPED+=(uvx)
else
  echo "→ Installing uv / uvx..."
  curl -LsSf https://astral.sh/uv/install.sh | sh
  INSTALLED+=(uvx)
  echo "NOTE: Add ~/.local/bin to your PATH if not already present:"
  echo "  echo 'export PATH=\"\$HOME/.local/bin:\$PATH\"' >> ~/.bashrc && source ~/.bashrc"
fi

# ── Summary ───────────────────────────────────────────────────────────────────

echo ""
echo "──────────────────────────────────────"
echo "  Setup complete"
echo "──────────────────────────────────────"
if [ ${#INSTALLED[@]} -gt 0 ]; then
  echo "  Installed : ${INSTALLED[*]}"
fi
if [ ${#SKIPPED[@]} -gt 0 ]; then
  echo "  Already ok: ${SKIPPED[*]}"
fi
echo ""
echo "Next: authenticate with 'gh auth login' and 'glab auth login'"
