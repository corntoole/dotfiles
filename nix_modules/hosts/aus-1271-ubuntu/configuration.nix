# Host-specific configuration for aus-1271 (Ubuntu with Nix/Determinate)
# This file is imported by the home-manager configuration in flake.nix.
# It only needs to set host-specific variables; shared settings come from home.nix.

{ config, lib, pkgs, ... }:
{
  # Hostname for this machine (same as the NixOS host name)
  networking.hostName = "aus-1271";

  # Any host-specific home-manager settings can go here
  # For now, we rely on the shared home.nix for most configuration
}