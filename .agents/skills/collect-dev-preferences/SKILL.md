---
name: collect-dev-preferences
description: Scan global config/instruction files across Claude Code, Gemini CLI, pi, amp, and GitHub Copilot CLI, and consolidate the user's development preferences into one version-controlled markdown file. Also supports scanning a specific project folder for candidate preference updates (project mode is opt-in only — never run it without an explicit, current-turn request naming the project). Use when the user asks to collect, sync, merge, or audit their dev preferences/settings across these agent CLIs, or asks "what preferences do I have set" across tools.
---

# Collect Dev Preferences

Consolidates freeform instructions and relevant settings from five agent CLIs into a single
reference doc kept under version control at
`~/Projects/github.com/corntoole/dotfiles/dev-preferences.md` (the dotfiles repo — this file is
the source of truth; never write a copy elsewhere).

## Sources to check (search at runtime — paths vary by version/install)

| Tool | Look for |
|---|---|
| Claude Code | `~/.claude/CLAUDE.md`, `~/.claude/settings.json` (`permissions`, `model`, env vars) |
| Gemini CLI | `~/.gemini/settings.json` (`general`, `ui`, `security` sections), any `~/.gemini/**/GEMINI.md` |
| pi | `~/.pi/agent/settings.json`, any instructions/memory file under `~/.pi/agent/` |
| amp | `~/.config/amp/**`, `~/.amp/**`, any `AGENTS.md` in home or amp config dir |
| GitHub Copilot CLI | `~/.copilot/copilot-instructions.md`, `~/.config/github-copilot/**` |

Don't hardcode exact filenames beyond the ones above as gospel — `find`/`ls` each tool's config
dir first, since installs vary. Treat freeform `.md` files as the primary source of "preferences"
(coding style, VCS workflow, tool-use rules, workflow conventions). Treat `settings.json`-style
files as secondary — only pull fields a human would call a *preference* (editor, VCS tool, theme,
default model, permission defaults), not secrets, auth tokens, or machine IDs.

## Process (global scan — the default mode)

1. For each of the 5 tools, locate its config location(s) per the table above (glob/find, since
   not all exist on every machine — skip missing ones silently).
2. Read freeform instruction files in full. For settings.json-style files, extract only
   preference-shaped fields.
3. Deduplicate and group by theme, not by tool — e.g. "Version control", "Code style", "Tool-use
   order", "Workflow conventions" — noting which tool(s) each preference came from in parentheses.
   If tools conflict (e.g. one says use `jj`, another has no VCS preference), note the conflict
   rather than silently picking one.
4. Write/overwrite `~/Projects/github.com/corntoole/dotfiles/dev-preferences.md`, organized by
   theme. Under each preference, cite the source tool(s) in parentheses, e.g.
   `- Prefer \`jj\` over \`git\` for VCS (copilot)`.
5. Show a `git status`/`git diff` of the file inside the dotfiles repo and ask before committing —
   never commit or push on the user's behalf without confirmation.
6. Report a short summary of what was found per tool, including any tools where nothing was found.

## Project-folder scan (opt-in only — never run this automatically)

Only run this mode when the user explicitly asks, in the current turn, to scan a specific project
for preference updates (e.g. "scan this repo for preference updates", "check <project> against my
dev preferences"). Do not trigger it as a side effect of the global scan, of opening a project, or
of any other skill. If invoked with no specific project named, ask which one.

1. Within the named project, look for its own agent-instruction files: `CLAUDE.md`, `GEMINI.md`,
   `AGENTS.md`, `.copilot-instructions.md`/`.github/copilot-instructions.md`, or equivalents, plus
   any project-level tool settings (e.g. `.claude/settings.json`).
2. Compare what's there against the current
   `~/Projects/github.com/corntoole/dotfiles/dev-preferences.md`. Look for:
   - New preferences present in the project but missing from the global file (candidates to add).
   - Contradictions between the project and the global file (candidates to flag, not auto-resolve).
3. Present findings as a proposed diff/patch to `dev-preferences.md` — do **not** write the file.
   Wait for explicit user approval before applying, then follow the same commit-confirmation step
   as the global scan.

## Notes

- Both modes are read-only against source config files (global tool configs and project files) —
  never modify them.
- The dotfiles repo file is the single source of truth; re-running the global scan fully
  regenerates it from current state (not append), and project-scan changes go through review
  before being applied to it.
- Always leave committing/pushing to the user's explicit confirmation.
