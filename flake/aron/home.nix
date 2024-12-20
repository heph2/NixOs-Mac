{ config, pkgs, lib, ... }:
with lib; {
  imports = [
    ./fish.nix
    ./home-pkgs.nix
  ];

  home.stateVersion = "22.05";
  home.sessionVariables = {
    EDITOR = "mg";
    LIMA_HOME = "$HOME/env/colima";
    LEDGER_FILE = "~/env/finance/2024.journal";
    GRANTED_ALIAS_CONFIGURED = "true";
  };

  programs = {
    direnv.enable = true;
    direnv.nix-direnv.enable = true;
    htop.enable = true;
    msmtp.enable = true;
    zsh = {
      enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        ll = "ls -l";
        update = "sudo nixos-rebuild switch";
        assume = "source ${pkgs.granted}/bin/assume";
        dw = "darwin-rebuild switch --flake '.#aron'";
        k = "kubectl";
      };
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "thefuck" ];
        theme = "robbyrussell";
      };
    };
    tmux = {
      enable = true;
      shell = "/etc/profiles/per-user/marco/bin/fish";
      extraConfig = "setw -g mouse on";
    };
    fzf = {
      enable = true;
      enableFishIntegration = true;
    };
    git = {
      enable = true;
      aliases = {
        gp = "add -p";
        co = "checkout";
        s = "switch";
      };
      extraConfig = {
        pull.ff = "only";
        core.pager = "delta";
        interactive.diffFilter = "delta --color-only";
        delta = {
          navigate = true;
          light = false;
          side-by-side = true;
        };
      };
      userEmail = "srht@mrkeebs.eu";
      userName = "heph";
    };
    spicetify =
      # let
      #   spicePkgs = spicetify-nix.legacyPackages.${pkgs.system};
      # in
      {
        enable = true;
        # enabledExtensions = with spicePkgs.extensions; [
        #   adblock
        #   hidePodcasts
        #   shuffle
        # ];
        # theme = spicePkgs.themes.catppuccin;
        colorScheme = "mocha";
      };
  };

  accounts.email.accounts."work" = {
    address = "m.bauce@davinci.care";
    maildir.path = "/Users/marco/.maildir/work";
    mu.enable = true;
    primary = true;
  };
}
