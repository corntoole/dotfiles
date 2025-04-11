{ lib, pkgs, ...}:
{
  # this is internal compatibility configuration
  # for home-manager, don't change this!
  home.stateVersion = "23.05";
  # Let home-manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    pkgs.neovim
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
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.bash.enable = true;

  programs.bash = {
    bashrcExtra = lib.mkDefault ''
        [ -n "$PS1" ] && source ~/.bashrc_extra
    '';
  };
}
