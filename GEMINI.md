# Gemini Context: Dotfiles

This repository contains personal dotfiles for macOS and Nix environments, forked from Mathias Bynens and maintained by Cornelius Toole. It combines traditional dotfile management with modern declarative configuration via Nix.

## Project Overview

- **Purpose:** Personal development environment configuration for macOS.
- **Main Technologies:** Bash, Nix (nix-darwin, home-manager), Homebrew.
- **Architecture:**
    - **Nix Layer:** Uses `flake.nix` to define system-level configurations (`nix-darwin`) and user-level configurations (`home-manager`).
    - **Classic Dotfiles:** Traditional shell and tool configuration files (e.g., `.bash_profile`, `.vimrc`) located in the root.
    - **Installation Scripts:** `bootstrap.sh` for traditional sync and `.macos` for system defaults.

## Key Files & Directories

- `flake.nix`: Entry point for Nix configurations. Defines hosts: `aus-2226-ml`, `hyperlight`, `krakoa`.
- `nix_modules/`:
    - `home/home.nix`: User-level configuration via Home-Manager, linking root dotfiles to the home directory.
    - `hosts/`: Host-specific Nix configurations.
- `bootstrap.sh`: Shell script that uses `rsync` to copy/sync dotfiles to `~`.
- `.macos`: Script containing a collection of sensible macOS system defaults.
- `brew.sh` & `Brewfile`: Traditional Homebrew package management (partially superseded by the `homebrew` module in `flake.nix`).
- `.bash_profile`: Main shell initialization script, sourcing other modular files (`.aliases`, `.functions`, etc.).
- `dot_config/`: Directory for modern application configurations (e.g., `starship.toml`, `jj/config.toml`).

## Usage & Commands

### Nix-based Configuration (Recommended)
To apply the declarative system and user configuration:
```bash
# Replace <hostname> with one of: aus-2226-ml, hyperlight, krakoa
darwin-rebuild switch --flake .#<hostname>
```

### Traditional Installation
To sync dotfiles to your home directory:
```bash
./bootstrap.sh --force
```

### macOS Defaults
To set system-wide preferences:
```bash
./.macos
```

### Homebrew (Manual)
To install packages via the `brew.sh` script:
```bash
./brew.sh
```

## Development Conventions

- **Modularity:** Shell configurations are split into `.aliases`, `.exports`, `.functions`, and `.extra` (for local overrides).
- **Nix Integration:** Prefer adding system packages and Homebrew formulae to `flake.nix` for declarative management.
- **Dotfile Linking:** `home-manager` is used to symlink dotfiles from this repository to the home directory as defined in `nix_modules/home/home.nix`.
