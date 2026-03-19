# Copilot Instructions

Personal macOS dotfiles combining declarative Nix configuration (nix-darwin + home-manager) with classic shell dotfiles, maintained by Cornelius Toole.

## Applying Configuration

```bash
# Apply full system + user config (preferred)
darwin-rebuild switch --flake .#<hostname>

# Hosts: aus-2226-ml (x86_64), hyperlight (aarch64), krakoa (aarch64)

# Classic rsync install (fallback, no Nix required)
./bootstrap.sh --force

# Apply macOS system defaults
./.macos
```

## Architecture

Two layers coexist:

**Nix layer (preferred)** — `flake.nix` is the entry point. It wires together:
- `configuration` block: system-level packages and Homebrew (brews, casks, MAS apps)
- `nix_modules/home/home.nix`: home-manager config that **symlinks repo dotfiles into `~`**
- `nix_modules/hosts/<hostname>/configuration.nix`: per-host overrides (username, home path, architecture)

**Classic layer** — `bootstrap.sh` uses `rsync` to copy dotfiles directly to `~`. Used when Nix isn't available.

## Adding a New Dotfile

When adding a config file that should be managed by home-manager, you must register it in `nix_modules/home/home.nix` under `home.file`:

```nix
".myconfig".source = ../../.myconfig;
```

Files under `dot_config/` map to `~/.config/`:
```nix
".config/mytool/config".source = ../../dot_config/mytool/config;
```

## Shell Config Layout

`.bash_profile` is the main entry point — it is symlinked to `~/.bashrc_extra` and sourced by home-manager's bash config. It sources these modular files at startup:
- `.aliases` — shell aliases
- `.exports` — environment variables
- `.functions` — shell functions
- `.extra` — local machine overrides (not committed, gitignored)

`.extra` is the correct place for secrets, machine-specific paths, or anything that shouldn't be committed.

## Package Management

Prefer adding packages to `flake.nix` over `brew.sh`/`Brewfile`. The `homebrew` block in `flake.nix` manages brews, casks, and MAS apps declaratively and is applied on `darwin-rebuild switch`.

`brew.sh` and `Brewfile` are legacy and partially superseded.

## Version Control

This repo uses `jj` (jujutsu) in colocated mode (`jj git init --colocate`). See `dot_config/jj/config.toml` for aliases and revset definitions. Key custom aliases: `jj pull`, `jj push`, `jj pr`, `jj open`, `jj tug`, `jj reheat`, `jj retrunk`.

Prefer `jj` commands over `git` for all VCS operations.
