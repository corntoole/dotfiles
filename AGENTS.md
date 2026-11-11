## Agent skills

### Issue tracker

Issues are tracked in GitHub Issues for this repository. See `docs/agents/issue-tracker.md`.

### Triage labels

Use the canonical triage labels: `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, and `wontfix`. See `docs/agents/triage-labels.md`.

### Domain docs

This repo is configured as single-context: look for a root `CONTEXT.md` and `docs/adr/`. See `docs/agents/domain.md`.

### jj agent workspaces

When working in `jj`-backed repos with parallel agents, follow the workspace rules in `docs/agents/jj-megamerge.md` ("Agent rules" section). The `jj mega-*` commands (`mega-new`, `mega-sync`, `mega-status`, `mega-fix`, `mega-prune`) are defined in `dot_config/jj/config.toml`.
