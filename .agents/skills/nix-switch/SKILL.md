---
name: nix-switch
description: Rebuild, switch, or debug Nix, nix-darwin, and Home Manager configurations across hosts. Use when the user wants to rebuild or switch nix config, mentions "darwin-rebuild", "nixos-rebuild", or encounters friction like missing identity files, untracked flake files, or Home Manager collisions.
---

# Rebuilding & Switching Nix Configuration

Discipline and workflow for rebuilding and switching `nix-darwin`, `nixpkgs`, and `home-manager` configurations in this repository without friction.

Primary script: [`bin/nix-switch`](file:///Users/corntoole/Project/Git/dotfiles/bin/nix-switch)

## Workflow

### 1. Pre-flight Audit

Before triggering a rebuild, confirm the target environment:

1. **Identify the host**:
   Check `hostname -s`. Flake hosts are:
   - macOS: `krakoa`, `hyperlight`, `aus-2226-ml`
   - Linux: `nixos-vm`
2. **Audit untracked files**:
   Nix flakes ignore files not tracked by Git. Run:
   ```bash
   git status --porcelain
   ```
   If new `.nix` or config files exist under `nix_modules/` or `dot_config/`, stage them:
   ```bash
   git add -N <file>
   ```
3. **Verify SSH identities & cross-host leakage**:
   Ensure keys declared in `programs.ssh.matchBlocks` or `dot_config/jj/config.toml` exist on the target host:
   ```bash
   ./bin/nix-switch verify
   ```
   *Rule: Never configure host-specific keys (e.g. `id_vm_ed25519`) in shared `nix_modules/home/home.nix` without scoping or `lib.mkDefault`.*

**Completion criterion**: Host identified, untracked nix files staged, and `./bin/nix-switch verify` reports no missing identity files.

---

### 2. Build Verification (Dry-run / Check)

Never run `switch` directly when touching core system options or flake inputs. Evaluate first:

```bash
# For macOS hosts
./bin/nix-switch check <hostname>

# Or manually:
/run/current-system/sw/bin/darwin-rebuild check --flake .#<hostname>
```

**Completion criterion**: Derivation builds/checks without Nix syntax, type, or evaluation errors.

---

### 3. Switch & Activate

Execute the switch with appropriate privileges:

```bash
# macOS
./bin/nix-switch switch <hostname>

# Or manually:
darwin-rebuild switch --flake .#<hostname>
```

```bash
# NixOS VM
./bin/nix-switch switch nixos-vm

# Or manually:
sudo nixos-rebuild switch --flake .#nixos-vm
```

*Note on macOS PATH: `darwin-rebuild` lives in `/run/current-system/sw/bin/darwin-rebuild`. If running in a restricted subshell, use the absolute path.*

**Completion criterion**: Activation scripts finish and exit code is 0.

---

### 4. Post-Switch Verification

Verify that generated configurations and symlinks work as expected:

1. **Check SSH configuration**:
   ```bash
   ssh -G github.com | grep identityfile
   ```
   Confirm all listed identity files exist on the host filesystem.
2. **Test Git SSH authentication**:
   ```bash
   git fetch --dry-run origin
   ```
   Ensure no `no such identity` warnings appear on stderr.
3. **Check Home Manager links**:
   Verify symlinks in `~/.ssh/config`, `~/.config/`, and dotfiles point to the active nix store generation.

**Completion criterion**: Git fetch succeeds without stderr warnings and user symlinks resolve.

---

## Friction Playbook

### 1. `no such identity: ...: No such file or directory`
- **Cause**: Shared `programs.ssh.matchBlocks` in `nix_modules/home/home.nix` references a key that exists on only one host (e.g. VM key).
- **Remedy**:
  - In `nix_modules/home/home.nix`, use `identityFile = lib.mkDefault [ "~/.ssh/id_ed25519" ];`.
  - In the host-specific configuration (e.g. `nix_modules/hosts/nixos-vm/configuration.nix`), override using `home-manager.users.<user>.programs.ssh.matchBlocks."github.com".identityFile = lib.mkForce [ ... ];`.

### 2. Flake ignores modified/added file (`getting status of '...': No such file or directory`)
- **Cause**: Nix Flakes only evaluate files that are tracked in Git.
- **Remedy**:
  Run `git add -N <file>` so Git tracks the path without requiring an immediate commit.

### 3. Home Manager file collision (`Existing file '...' would be overwritten by merge`)
- **Cause**: A target file already exists as a physical file or unmanaged symlink.
- **Remedy**:
  Rename or remove the physical file (`mv ~/.target ~/.target.backup`), then re-run switch. Home Manager will manage it as a symlink to `/nix/store/...`.

### 4. `darwin-rebuild: command not found`
- **Cause**: `/run/current-system/sw/bin` is not yet in the active shell's `$PATH`.
- **Remedy**:
  Invoke `/run/current-system/sw/bin/darwin-rebuild` or use `./bin/nix-switch`. Ensure `.bash_profile` includes:
  ```bash
  if [ -d "/run/current-system/sw/bin" ]; then
    prepend_to_path /run/current-system/sw/bin
  fi
  ```

### 5. `error: Unexpected files in /etc, aborting activation`
- **Cause**: macOS system updates or installers created physical files in `/etc` (typically `/etc/zshrc` or `/etc/zprofile`). `nix-darwin` requires managing these as symlinks to `/etc/static/` and refuses to overwrite unmanaged physical files.
- **Remedy**:
  Back up the conflicting files to `.before-nix-darwin`:
  ```bash
  sudo mv /etc/zshrc /etc/zshrc.before-nix-darwin
  sudo mv /etc/zprofile /etc/zprofile.before-nix-darwin
  ```
  Then re-run `./bin/nix-switch switch`.
