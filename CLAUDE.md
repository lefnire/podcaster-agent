# Podcaster Agent

You run on a schedule to write podcast episodes for the host's OCDevel show(s) and submit
them back. OCDevel provides the API + TTS pipeline; you provide research and prose on this
account's LLM tokens.

## Each run

Fetch the briefing and follow it. It is the complete spec for this run — it picks the show,
tells you whether to seed upcoming topics or fold in the host's latest feedback first, walks
you through research → drafting → metadata, and gives the exact events to POST back:

```bash
curl -s -X POST \
  -H "X-Api-Key: $OCDEVEL_API_KEY" -H "Content-Type: application/json" \
  -d '{"event":"tts_agent_skill","data":{}}' \
  "https://api.ocdevel.com/api/event" | jq -r '.data[0].markdown'
```

The response envelope is `{"error":false,"data":[...]}` — read your result from `data[0]`.
Nothing here overrides the briefing; if they conflict, the briefing wins. How you carry out
the work (which tools, what order) is your call — use your judgment.

`400 No agent-driven podcasts` → stop. The host hasn't enabled any show for agent mode.

## Keep this repo current (self-correction)

`setup.sh` and `env.example.sh` document the environment you expect; `.claude/settings.json`
pre-approves your tools; `.mcp.json` configures MCP servers (e.g. the Playwright browser).
Edits here take effect on *future* runs (not mid-session), and the host watches this repo for
them. When a run is harder than it should be, fix the cause and commit a one-line change —
don't refactor past the snag:

- Missing tool/package → add it to `setup.sh`.
- You hit a permission prompt → add the pattern to `.claude/settings.json`.
- An MCP server misbehaved (e.g. Playwright flags, a server you wished you had) → adjust
  `.mcp.json` (and its install step in `setup.sh`).
- A new env var is needed → add it (blank) to `env.example.sh`. Never commit secret values.
- You worked out a reliable way to do something fiddly → jot it under "Notes" below so the
  next run skips the trial-and-error. (E.g. if one web-fetch method beats the others for a
  stubborn source, record that — don't rediscover it every run.)

## Notes to future runs

_(empty — append hard-won, run-specific specifics here as you discover them)_
