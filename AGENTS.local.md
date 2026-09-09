# Role & Philosophy: Git-Compatible Jujutsu (`jj`) Workflow
You are an AI developer operating in a repository controlled by Jujutsu (`jj`), a Git-compatible version control system. The repository is colocated, meaning you will use `jj` commands locally to manage changes, but your final work will automatically sync to an underlying Git repository for pull requests, CI/CD, and team collaboration.

## Core Guardrails
1. NEVER run interactive commands (e.g., do not omit the message flag in `jj describe`). Interactive prompts will cause the terminal session to hang.
2. NEVER use Git commands (`git add`, `git commit`, `git rebase`) unless explicitly asked. Always use `jj`.
3. Target revisions using Change IDs (e.g., `rwvqtnlk`), not Commit IDs. Change IDs are stable across history rewrites.

## 1. Inspecting the Repository
Before making changes, always inspect the state of the repository using non-interactive visualization commands.
* View repository layout: `jj log` (or `jj log -r "all()"`)
* Check current workspace status: `jj status`

## 2. Managing the Working Copy (`@`)
In `jj`, your working directory is a live commit designated as `@`. You do not need to stage files. Every change you save is automatically snapshotted into `@`.
* Document your current work: `jj describe -m "feat: your commit message"`
* Create a brand new, empty change on top of the current one: `jj new`
* Move to a different parent revision: `jj new <change_id>`

## 3. History Manipulation (No Interactivity)
Instead of interactive rebasing, use direct, explicit commands targeting specific files or paths.
* Squash specific files into a target change: `jj squash --paths <file_path>` (Never use `jj squash -i`)
* Split a mixed commit by paths: `jj split -r <change_id> --paths <file_path>`
* Discard changes to specific files: `jj restore --paths <file_path>`

## 4. Working with Bookmarks (Git Branches)
Bookmarks are pointer handles for Git remote synchronization; they do not require you to "checkout" a branch to work on it. Bookmarks do not automatically move with your commits unless explicitly tracked.
* Create a bookmark on your active change: `jj bookmark create <name> -r @`
* Advance a bookmark to your latest work: `jj bookmark move <name> --to @`
* Pull remote changes safely: `jj git fetch` followed by an explicit `jj rebase -d <target_change_id>`

## 5. Conflict Resolution & Recovery
* First-Class Conflicts: If a rebase results in a conflict, `jj` will NOT block or halt execution. It will successfully commit the conflict markers directly into the file. Edit the conflict markers programmatically inside the file, save, and type `jj describe` or `jj new` to move forward.
* The Ultimate Safety Net: If you make a mistake, break the commit tree, or accidentally delete history, use the operation log.
  * View history of your commands: `jj op log`
  * Undo the immediate last action: `jj undo`
  * Restore the repo to an exact prior state: `jj op restore <operation_id>`
