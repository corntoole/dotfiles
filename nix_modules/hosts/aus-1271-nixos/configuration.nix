# Archived NixOS configuration for the same machine (aus-1271).
# This was originally the NixOS host config. It is kept here for reference
# and potential future use, but the active configuration now runs on Ubuntu.

{ config, lib, pkgs, ... }:
{
  # Hostname (same machine, same name)
  networking.hostName = "aus-1271";

  # NetworkManager (same as the old NixOS config)
  networking.networkmanager.enable = true;

  # Boot configuration (same as the old NixOS config)
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/disk/by-id/ata-Micron_M600_MTFDDAK256MBF_15190F86ED13";
  boot.loader.grub.efiSupport = false;

  # LVM thin pool support (same as the old NixOS config)
  boot.initrd.services.lvm.enable = true;
  boot.kernelModules = [ "dm-thin-pool" ];

  # Timezone (same as the old NixOS config)
  time.timeZone = "America/Chicago";

  # Locale (same as the old NixOS config)
  i18n.defaultLocale = "en_US.UTF-8";

  # SSH settings (same as the old NixOS config)
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  # Virtualization (same as the old NixOS config)
  virtualisation.libvirtd.enable = true;
  virtualisation.docker.enable = true;
  programs.virt-manager.enable = true;

  # GNUPG agent (same as the old NixOS config)
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-curses;
  };

  # System packages (same as the old NixOS config)
  environment.systemPackages = with pkgs; [
    vim
    git
    curl
    wget
    gnupg
    thin-provisioning-tools
  ];

  # Nix settings (same as the old NixOS config)
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # System state version (same as the old NixOS config)
  system.stateVersion = "26.05";
}