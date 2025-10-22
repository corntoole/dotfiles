{
  description = "My System Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/0.1";
    nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, determinate, nix-darwin, home-manager }:
  let
    configuration = { lib, pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ pkgs.vim
          pkgs.nixd
        ];

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = lib.mkDefault "x86_64-darwin";

      nix = {
        enable = false;
      };

      homebrew = {
        enable = true;

        taps = [
          "bufbuild/buf"
          "homebrew/bundle"
          "homebrew/services"
          "jesseduffield/lazydocker"
          #"jorgelbg/tap"
          #"txn2/tap"
          #"withgraphite/tap"
        ];

        brews = [
          "asciinema"
          #"atuin", restart_service: :changed
          "atuin"
          "autojump"
          #"bash"
          #"bash-completion@2"
          #"bat"
          "cfssl"
          #"cmake"
          #"coreutils"
          "difftastic"
          "fd"
          "fzf"
          "gawk"
          "gh"
          #"git"
          "git-branchless"
          #"gitui"
          #"glow"
          "gnutls"
          "gnupg"
          #"go"
          #"golangci-lint"
          #"grpc"
          #"helix"
          #"htop"
          #"httpie", link: false
          "hub"
          "jless"
          "jq"
          "k9s"
          "kubectx"
          "kustomize"
          "lazygit"
          #"llvm@17"
          #"make"
          "mas"
          #"node"
          #"mongosh"
          #"tree-sitter"
          #"neovim"
          "pinentry-mac"
          #"protoc-gen-go"
          #"protoc-gen-go-grpc"
          "ripgrep"
          "rust"
          #"stgit"
          #"tree"
          #"wget"
          #"yarn"
          #"yq"
          "zellij"
          #"bradleyjkemp/formulae/grpc-tools"
          "bufbuild/buf/buf"
          #"grpcmd/tap/grpcmd"
          "jesseduffield/lazydocker/lazydocker"
          # "jorgelbg/tap/pinentry-touchid"
          #"withgraphite/tap/graphite"
        ];

        casks = [
          "1password"
          "1password-cli"
          "alfred"
          "arc"
          "caffeine"
          #"font-hack-nerd-font"
          #"font-monaspace"
          # "gpg-suite-pinentry"
          "httpie"
          "jetbrains-toolbox"
          "kitty"
          #"libreoffice"
          "licecap"
          "logi-options+"
          "logseq"
          "mongodb-compass"
          "orbstack"
          #"rancher"
          "rectangle"
          "viscosity"
          "warp"
          "zed"
          "zoom"
        ];

        masApps = {
         "1Password for Safari" = 1569813296;
         "Boop" = 1518425043;
         "Bumpr" = 1166066070;
         "Dato" = 1470584107;
         "Pastebot" = 1179623856;
         #"Session Pal" = 1515213004;
         "Slack" = 803453959;
         "Soulver 3" = 1508732804;
         "Vinegar" = 1591303229;
        };
      };
    };
    homeconfig = import ./nix_modules/home/home.nix;
    globalModulesMacos =  {
      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "x86_64-darwin";
      security.pam.services.sudo_local.touchIdAuth = true;
    };
    globalModulesMacosArm = {
      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
      security.pam.services.sudo_local.touchIdAuth = true;
      homebrew.brewPrefix = "/opt/homebrew/bin";
    };
  in
  {
    darwinConfigurations = {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#aus-2226-ml
      "aus-2226-ml" = nix-darwin.lib.darwinSystem {
        modules = [
          determinate.darwinModules.default
          configuration
          ( globalModulesMacos // ( import ./nix_modules/hosts/aus-2226-ml/configuration.nix ) )
          home-manager.darwinModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.verbose = true;
            home-manager.users.ctoole = homeconfig;
            home-manager.backupFileExtension = "backup";
          }
        ];
      };
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#krakoa
      "krakoa" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          ( globalModulesMacosArm // ( import ./nix_modules/hosts/krakoa/configuration.nix ) )
          home-manager.darwinModules.home-manager {
            # users.users.corntoole.home = /Users/corntoole;
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.verbose = true;
            home-manager.users.corntoole = homeconfig;
            home-manager.backupFileExtension = "backup";
          }
        ];
      };
    };
  };
}
