# TODO: Upgrade State Versions

- [ ] **`nixosConfigurations.aus-1271-nixos`**: `system.stateVersion` in `nix_modules/common/nixos-base.nix` should be reviewed. The old NixOS config used `"26.05"`. Confirm if a newer version is needed.
- [ ] **`home.stateVersion`**: Currently `"23.05"` in `nix_modules/home/home.nix`. Consider upgrading to match the current home-manager flake input version.
- [ ] **macOS darwin configs**: `system.stateVersion = 5` — review for upcoming macOS releases.

Reference: <https://nixos.org/manual/nixos/stable/#sec-upgrading-releasing>
