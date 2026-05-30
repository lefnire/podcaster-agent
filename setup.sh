#!/usr/bin/env bash
# System bootstrap for the podcaster agent. Idempotent and safe to re-run.
#
# This is the only place root/sudo exists, so system installs live here — NOT
# in a SessionStart hook (those run non-root, every session). For a Claude Code
# Routine / web env, paste this into the environment's "Setup Script" field
# (runs once as root, then snapshotted). Locally / in CI, run it directly.
#
# The agent may edit this file (see CLAUDE.md) when a run needs a tool that
# isn't here yet.
set -euo pipefail

# ---- curl + jq: talk to the OCDevel API ----
# Both live in apt "main", so a stale/failed index update is fine to ignore.
if ! command -v curl >/dev/null || ! command -v jq >/dev/null; then
  sudo apt-get update -qq || true
  sudo apt-get install -y --no-install-recommends curl jq
fi

# ---- Playwright headless browser ----
# Fallback for JS-rendered / bot-gated research pages that curl + WebFetch
# can't read. Optional — drop this block if you never want browser automation.
# The Playwright MCP (wired in .mcp.json) drives chrome-for-testing, a separate
# binary from `playwright install chromium`. install-deps needs root (apt); the
# browser binary is then snapshotted.
sudo npx --yes playwright install-deps chromium
npx --yes @playwright/mcp install-browser chrome-for-testing
