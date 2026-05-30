# Environment for the podcaster agent. Copy to env.sh (gitignored) and fill in,
# or set these in your Routine / Claude Code web environment config.
# This file is the source of truth for WHICH vars exist — values stay blank
# here because the repo is public. Never commit a real key.

# Required. OCDevel API key (TTS Settings → Developer). Full account scope.
export OCDEVEL_API_KEY=

# Only for headless runs (GitHub Actions, `claude -p`). Leave commented under a
# Claude subscription (Routine / web) — it auths for you, and setting this can
# override that. Uncomment if you self-host the run.
# export ANTHROPIC_API_KEY=
