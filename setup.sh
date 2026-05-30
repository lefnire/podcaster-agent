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

# ---- Playwright headless browser (optional fallback) ----
# For JS-rendered / bot-gated pages that curl + WebFetch can't read. Drop this
# block if you never want browser automation — the agent runs fine without it.
#
# Node ignores the system cert store, so behind Claude Code web's TLS-intercepting
# proxy npm dies with SELF_SIGNED_CERT_IN_CHAIN even though curl works; point it
# at the CA bundle curl already trusts. (sudo resets env, so pass the var through.)
# Best-effort: a browser-install hiccup must not brick the whole setup.
ca=/etc/ssl/certs/ca-certificates.crt
export NODE_EXTRA_CA_CERTS="$ca"
if ! { sudo NODE_EXTRA_CA_CERTS="$ca" npx --yes playwright install-deps chromium \
    && npx --yes @playwright/mcp install-browser chrome-for-testing; }; then
  echo "WARN: Playwright install failed; continuing without browser automation." >&2
fi
