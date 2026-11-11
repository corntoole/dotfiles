# jj megamerge: parallel agent workspaces

Tooling for running several CLI agents (Claude Code, Codex, Amp, …) in parallel
`jj` workspaces while the `default` workspace stays an integration workspace.
Config lives in [`dot_config/jj/config.toml`](../../dot_config/jj/config.toml);
home-manager installs it as `~/.config/jj/config.toml`.

## Model

- Each agent works in its own workspace (`jj mega-new agent-a`), creating
  sibling directories next to the main checkout.
- Each agent ends milestones with `jj commit -m "<task>: <summary>"` and then
  `jj new`, so its working copy `@` is an empty *buffer* commit and its
  finished work sits at `@-`.
- `jj mega-sync` aggregates every active agent head plus `trunk()` into a
  single mutable merge commit described exactly `megamerge`, and puts an empty
  `default@` on top of it for the human (or an integration agent) to inspect.
- `jj` records conflicts inside the megamerge commit instead of blocking, so a
  sync never fails just because two agents touched the same lines.

## Commands

| Command | Purpose |
| :--- | :--- |
| `jj mega-new <name> [rev]` | Create agent workspace `<name>` as a sibling directory, based on `rev` (default `trunk()`). |
| `jj mega-sync` | Snapshot all agent workspaces, rebase/create the `megamerge` commit onto `active_agents() \| trunk()`, and put `default@` on top. Prints a hint when the result is conflicted. |
| `jj mega-status` | List active agent workspaces, idle ones, and whether `megamerge` has conflicts. |
| `jj mega-fix <name>` | Push the uncommitted changes in `default@` into workspace `<name>`'s commit (line-level fixes to lines that agent touched). |
| `jj mega-prune` | Forget workspaces that are empty and sitting on the base, and workspaces whose directories were deleted. |

The revset aliases `agent_wcs()`, `active_agents()`, `idle_agents()`,
`megamerge()`, and `agents_of_megamerge()` are available for ad-hoc `jj log`
queries. `megamerge_base()` defaults to `trunk()`; override it per repo in
`.jj/repo/config.toml` if you integrate on a different bookmark.

## Conflict resolution

Conflicts land in the `megamerge` commit. Two supported flows:

**Integrate in the megamerge (default).** After `jj mega-sync`, fix the
conflicted files in `default@` and run `jj squash` — the resolution moves
*into* the megamerge commit, which carries it forward across future syncs.
Each new sync only re-conflicts where agents actually overlap again.

**Fix a specific agent.** For a small fix that belongs in one agent's commit,
edit the file in `default@` and run `jj mega-fix <workspace>`. The agent picks
it up with `jj workspace update-stale` on its next command.

`jj absorb` from `default@` also works for non-merge fixes, but note it stops
at the nearest non-merge ancestor that touched the same lines — with a
resolution already committed on top of the megamerge, further fixes land there
rather than in the agent commits.

## Agent rules (paste into each project's AGENTS.md)

```markdown
## jj workspace rules (parallel agents)

1. **Verify your workspace before editing:** run `jj workspace root` and
   `jj status` at the start of your session. If you were started in a workspace
   other than `default`, work there and only there.
2. **Handle stale working copies immediately:** if any `jj` command reports the
   working copy is stale, run `jj workspace update-stale` before continuing.
   Other workspaces committing will make yours stale; this is normal.
3. **Leave a clean buffer commit:** at each milestone run
   `jj commit -m "<task-id>: <summary>" && jj new`, so finished work sits at
   `@-` and `@` stays an empty buffer. This lets the integration workspace use
   `jj absorb` / `jj mega-fix` without touching files you have open.
4. **Never touch `default`, `megamerge`, or other workspaces:** do not rebase,
   abandon, or edit commits outside your own workspace ancestry unless the
   user explicitly asks. Run `jj mega-sync` only from `default`.
```

## Notes

- The primary workspace must be named `default` (`agent_wcs()` excludes
  `default@`). That is jj's default; no action needed.
- `trunk()` follows remote bookmarks (`origin/main` / `origin/master`); in a
  repo with no remote it falls back to the root commit. Set `megamerge_base()`
  in such repos if the fallback is wrong.
- `megamerge()` matches commits described exactly `megamerge`. Do not name
  other commits that way, or `mega-sync` will try to rebase them too.
- `mega-sync` runs `jj workspace update-stale` in every workspace first: any
  command run in a stale workspace fails, and agents committing concurrently
  make other workspaces stale constantly.
