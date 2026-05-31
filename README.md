# Podcaster Agent

An autonomous agent that writes your [OCDevel](https://ocdevel.com/tools/tts) podcast for you.
On each scheduled run it fetches a briefing from OCDevel, researches the topic on the live web,
drafts the episode, and submits it back — OCDevel turns the text into audio and publishes it to
your RSS feed.

**Why run it yourself?** OCDevel can also generate episodes server-side (on Gemini, billed to
your credits). Running your own agent instead uses a frontier model on *your* LLM tokens —
substantially sharper prose — while OCDevel only charges TTS credits for the audio. You also get
to shape the agent: edit [`CLAUDE.md`](./CLAUDE.md), [`setup.sh`](./setup.sh), and
[`.claude/settings.json`](./.claude/settings.json) to taste.

## Prerequisites

1. An OCDevel account with at least one podcast.
2. On that podcast: **TTS → Settings → "Automatic — my agent runs it"**, with a segment prompt
   (the show's standing directive). The agent covers every show you put in this mode.
3. An **OCDevel API key** (TTS Settings → Developer). Full account scope — treat it like a
   password; regenerate if it leaks.

## Quickstart — Claude Code Routine

[Routines](https://code.claude.com/docs/en/routines) are Anthropic's scheduled cloud sessions,
and the easiest way to run this. First **[fork this repo](https://github.com/lefnire/podcaster-agent/fork)**
— Routines run in your own GitHub account, and the agent commits its self-corrections back, so
it needs a repo you own. Then at [claude.ai/code/routines](https://claude.ai/code/routines) →
**New routine**:

1. **Repository**: your fork. The routine clones it each run and auto-loads `CLAUDE.md` +
   `.claude/settings.json`.
2. **Prompt**: `See CLAUDE.md.`
3. **Trigger**: a schedule (e.g. daily), matched to how often you want new episodes.
4. **Environment variables**: add `OCDEVEL_API_KEY`.
5. **Network access**: set to **Full** — the agent fetches arbitrary research pages, not just
   OCDevel.
6. *(Optional)* paste [`setup.sh`](./setup.sh) into the environment's **Setup Script** field —
   it ensures `curl`/`jq` and installs a headless browser (Playwright) for JS-rendered or
   bot-gated research pages. Skip if `curl`/`jq` are present and you don't need browser scraping.

That's it. Self-corrections (see below) land on a `claude/*` branch you can review and merge.

---

## Other ways to run

### Local (CLI / desktop)

```bash
git clone https://github.com/lefnire/podcaster-agent.git
cd podcaster-agent
cp env.example.sh env.sh   # fill in OCDEVEL_API_KEY, then: source env.sh
./setup.sh                 # only if curl/jq are missing
claude -p "See CLAUDE.md."
```

### GitHub Actions cron

A ready-to-use workflow ships as a **sample** at
[`examples/github-actions/`](./examples/github-actions/). It lives outside
`.github/workflows/` on purpose, so forking this repo never auto-starts a cron you didn't
ask for. To turn it on, copy it into `.github/workflows/` and add `OCDEVEL_API_KEY` +
`ANTHROPIC_API_KEY` as repo secrets — full steps in
[the sample's README](./examples/github-actions/README.md).

### Other agents (Codex, etc.)

The real instructions come from the briefing OCDevel returns, so the agent is model-agnostic.
Rename `CLAUDE.md` → `AGENTS.md` (or paste its contents into your agent's system prompt);
everything else is unchanged. The agent needs three capabilities: shell `curl` + `jq`, web
search/fetch, and a large-enough-context LLM.

## Staying current

`setup.sh`, `env.example.sh`, `.claude/settings.json`, and `.mcp.json` describe the environment
the agent expects, and `CLAUDE.md` tells it to fix and commit those when a run snags. Your fork
accumulates your own agent's fixes; **watch [the upstream repo](https://github.com/lefnire/podcaster-agent)**
and sync your fork to pick up improvements — most also need a matching tweak (a new env var, a
network-allowlist change) in your Routine / environment settings, since those live outside the repo.
