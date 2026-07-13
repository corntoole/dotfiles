{ config, lib, pkgs, ...}:

let
  dotfiles = "${config.home.homeDirectory}/.dotfiles";
in

{
  # this is internal compatibility configuration
  # for home-manager, don't change this!
  home.stateVersion = "23.05";
  # Let home-manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    pkgs.neovim
    pkgs.blesh
    pkgs.shfmt
  ];
  home.file = {
    ".aliases".source = ../../.aliases;
    ".bashrc_extra".source = ../../.bash_profile;
    ".bash_prompt".source = ../../.bash_prompt;
    ".curlrc".source = ../../.curlrc;
    ".editorconfig".source = ../../.editorconfig;
    ".exports".source = ../../.exports;
    ".extra".source = ../../.extra;
    ".functions".source = ../../.functions;
    ".gdbinit".source = ../../.gdbinit;
    ".gitattributes".source = ../../.gitattributes;
    ".gitconfig".source = ../../.gitconfig;
    ".gitignore".source = ../../.gitignore;
    ".gvimrc".source = ../../.gvimrc;
    ".hgignore".source = ../../.hgignore;
    ".hushlogin".source = ../../.hushlogin;
    ".inputrc".source = ../../.inputrc;
    ".macos".source = ../../.macos;
    ".osx".source = ../../.osx;
    ".screenrc".source = ../../.screenrc;
    ".tmux.conf".source = ../../.tmux.conf;
    ".vimrc".source = ../../.vimrc;
    ".wgetrc".source = ../../.wgetrc;
    ".config/starship.toml".source = ../../dot_config/starship.toml;
    ".config/jj/config.toml".source = ../../dot_config/jj/config.toml;
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/dot_config/nvim";
    ".config/lazyvim".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/dot_config/lazyvim";
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.bash.enable = true;

  programs.bash = {
    bashrcExtra = lib.mkDefault ''
        [ -n "$PS1" ] && [[ $- == *i* ]] && source -- "$(blesh-share)"/ble.sh --attach=none
        [ -n "$PS1" ] && source ~/.bashrc_extra
        [[ ! ''${BLE_VERSION-} ]] || ble-attach
    '';
  };
}
