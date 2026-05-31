# GitHub Actions cron (sample)

A ready-to-use workflow that runs the agent on a daily schedule (and on manual
dispatch) via GitHub Actions, as an alternative to a [Claude Code Routine](../../README.md#quickstart--claude-code-routine).

It lives **here in `examples/` on purpose, where it does nothing.** GitHub only
executes workflow files located in `.github/workflows/`, so keeping the sample
outside that directory means forking this repo never silently starts a daily cron
on your account. You opt in by copying it into place.

## Activate it

From your fork:

```bash
mkdir -p .github/workflows
cp examples/github-actions/podcaster-agent.yml .github/workflows/
git add .github/workflows/podcaster-agent.yml && git commit -m "Enable Actions cron" && git push
```

Then add two repository secrets (**Settings → Secrets and variables → Actions → New
repository secret**):

- `OCDEVEL_API_KEY` — your OCDevel API key.
- `ANTHROPIC_API_KEY` — the key whose tokens pay for the agent's drafting.

Scheduled workflows only fire from the **default branch**, and GitHub disables them
after 60 days of repo inactivity, so merge this to `main` and check back in if
episodes stop arriving. Adjust the `cron:` line for your cadence (it's UTC).

## Heads-up on self-corrections

`CLAUDE.md` tells the agent to merge its own repo-config fixes to `main` via a PR.
On Actions, the default `GITHUB_TOKEN` can do that only if you allow it: **Settings →
Actions → General → Workflow permissions → Read and write**, and enable "Allow GitHub
Actions to create and approve pull requests." Without that, self-correction PRs will
fail to merge and the agent's fixes won't carry to the next run.

## Deactivate it

Delete `.github/workflows/podcaster-agent.yml` from your fork (the sample here stays).
