{ config, lib, pkgs, ... }:

{
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/disk/by-id/ata-Micron_M600_MTFDDAK256MBF_15190F86ED13";
  boot.loader.grub.efiSupport = false;

  boot.initrd.services.lvm.enable = true;
  # Required for the vg0/vmpool LVM thin pool (VM/container storage) to activate.
  boot.kernelModules = [ "dm-thin-pool" ];

  networking.hostName = "aus-1271";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Chicago";

  i18n.defaultLocale = "en_US.UTF-8";

  users.users.ctoole = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" "libvirtd" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMWYuxugh5gNpc0xrAZgRDfEWi/oa+Y/tJIitjhdqMm5 197863+corntoole@users.noreply.github.com"
    ];
  };

  # Local (console/getty) login uses password auth via PAM by default.
  # Set/change it with `passwd` after first boot; not stored in this file.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  security.sudo.wheelNeedsPassword = true;

  # TODO: FIDO2/U2F auth (security.pam.u2f) for local + sudo, once a key is provisioned.

  virtualisation.libvirtd.enable = true;
  virtualisation.docker.enable = true;
  programs.virt-manager.enable = true;

  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-curses;
  };

  environment.systemPackages = with pkgs; [
    vim
    git
    curl
    wget
    gnupg
    thin-provisioning-tools
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "26.05";
}
