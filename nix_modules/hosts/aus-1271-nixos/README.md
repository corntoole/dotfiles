# Archived NixOS Configuration for aus-1271

This directory contains the archived NixOS configuration for the **aus-1271** machine.

## Why is this archived?

The **aus-1271** host is now running **Ubuntu** with Nix installed via the
[Determinate Systems](https://determinate.systems) installer. The active
configuration for this machine is managed by **home-manager** and lives in:

```
nix_modules/hosts/aus-1271-ubuntu/configuration.nix
```

This archived copy is kept for reference and potential future conversion back
to NixOS. It documents:

- The LVM volume group layout (`vg0`)
- The GRUB configuration (BIOS mode, not EFI)
- Kernel modules (Intel CPU, AHCI, USB, etc.)
- The file system layout

## Applying this configuration

If you ever want to reinstall NixOS on this machine:

```bash
sudo nixos-rebuild switch --flake .#aus-1271-nixos
```
