# Host-specific configuration for aus-1271 (Ubuntu with Nix/Determinate)
# This file is imported by the home-manager configuration in flake.nix.
# It only needs to set host-specific variables; shared settings come from home.nix.

{ config, lib, pkgs, ... }:
{

  # Any host-specific home-manager settings can go here
  # For now, we rely on the shared home.nix for most configuration
  home.username = "ctoole";
  home.homeDirectory = "/home/ctoole";

  home.packages = with pkgs; [
    # shell / terminal
    atuin
    autojump
    blesh
    fzf
    starship
    zellij

    # core tools
    bat
    difftastic
    fd
    gawk
    gnumake
    helix
    httpie
    jq
    ripgrep
    tree
    wget
    yq

    # git & dev tools
    asciinema
    buf
    gh
    git
    git-branchless
    hub
    jless
    lazydocker
    lazygit

    # k8s
    k9s
    kubectx
    kustomize

    # security / crypto
    gnupg
    gnutls

    # languages & build
    nixd
    rustup
    shfmt
    tree-sitter

    # misc
    neovim
  ];
}
