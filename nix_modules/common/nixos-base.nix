# Shared NixOS base module for all NixOS host configurations
# Contains common system settings, user accounts, and packages shared across NixOS hosts.

{ config, lib, pkgs, ... }:
{
  # ---------------------------------------------------------------------------
  # Users
  # ---------------------------------------------------------------------------
  users.users.ctoole = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" "libvirtd" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMWYuxugh5gNpc0xrAZgRDfEWi/oa+Y/tJIitjhdqMm5 197863+corntoole@users.noreply.github.com"
    ];
  };

  # ---------------------------------------------------------------------------
  # Core system packages (shared across all NixOS hosts)
  # ---------------------------------------------------------------------------
  environment.systemPackages = with pkgs; [
    neovim
    nixd
    tree
    starship
  ];

  # ---------------------------------------------------------------------------
  # Nix settings
  # ---------------------------------------------------------------------------
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # ---------------------------------------------------------------------------
  # Timezone and locale (consistent across all NixOS hosts)
  # ---------------------------------------------------------------------------
  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.UTF-8";
}
