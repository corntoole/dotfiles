# Home-manager configuration for aus-1271 (Ubuntu with Nix/Determinate)
# This replaces the previous NixOS configuration for this machine.
# Keep the hostname as the same machine name for consistency.

{ config, lib, pkgs, ... }:
{
  # Hostname (keep the same for this machine)
  networking.hostName = "aus-1271";

  # User-level packages (mirrors the NixOS config)
  # These are now home-manager packages, not system packages
  home.packages = with pkgs; [
    vim
    git
    curl
    wget
    gnupg
    thin-provisioning-tools
  ];

  # Home-manager state version (matches the shared home.nix)
  home.stateVersion = "23.05";

  # Additional home-manager configuration can go here
  # (e.g., environment variables, program settings)
}