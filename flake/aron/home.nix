{ config, pkgs, lib, ... }:
with lib; {
  imports = [ ./fish.nix ];

  home.stateVersion = "22.05";
  home.sessionVariables = {
    EDITOR = "mg";
    LIMA_HOME = "$HOME/env/colima";
  };

  programs = {
    direnv.enable = true;
    direnv.nix-direnv.enable = true;

    htop.enable = true;
    msmtp.enable = true;
    kakoune = {
        enable = true;
        plugins = with pkgs.kakounePlugins; [
            kak-lsp kak-fzf auto-pairs-kak byline-kak
        ];
        config = {
            colorScheme = "tomorrow-night";
            scrollOff.columns = 3;
            scrollOff.lines = 5;
            ui.assistant = "dilbert";
        };
        extraConfig = ''
        map global normal <c-v> ':comment-line<ret>'
        map global normal <c-p> ':fzf-mode<ret>'
        eval %sh{kak-lsp --kakoune -s $kak_session}
        hook global WinSetOption filetype=(rust|go|python) %{
            lsp-enable-window
        }
        '';
    };    
    #    ssh = {
    #      enable = true;
    #      agent = {
    #        enable = true;
    #        enableAutoStart = true;
    #      };
    #      matchBlocks = {
    #        fooServer = {
    #          port = 1022;
    #          hostname =  "example.com";
    #          user = "me";
    #        };
    #    };
    # emacs = {
    #   enable = true;
    #   package = pkgs.emacs-git;
    #   extraPackages = epkgs: [ pkgs.mu pkgs.notmuch pkgs.irony-server ];
    # };
#    nixvim = {
#      enable = true;
#      colorschemes.gruvbox.enable = true;
#      plugins.lightline.enable = true;
#    };
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
  };

    accounts.email.accounts."work" = {
      address = "m.bauce@davinci.care";
      maildir.path = "/Users/marco/.maildir/work";
      mu.enable = true;
      primary = true;
    };
  
    home.packages = with pkgs; [
      (pkgs.emacsWithPackagesFromUsePackage {
        config = ./emacs.el;
        defaultInitFile = true;
        package = pkgs.emacs-git;
        alwaysEnsure = true;
        # alwaysTangle = true;
        extraEmacsPackages = epkgs: [
          # epkgs.mu epkgs.notmuch
          epkgs.vterm
          epkgs.notmuch
          epkgs.mu4e
          epkgs.pdf-tools
          (epkgs.treesit-grammars.with-grammars (grammars:
            with grammars; [
              tree-sitter-bash
              tree-sitter-css
              tree-sitter-dockerfile
              tree-sitter-elisp
              tree-sitter-elixir
              tree-sitter-heex
              tree-sitter-html
              tree-sitter-javascript
              tree-sitter-json
              tree-sitter-nix
              tree-sitter-ruby
              tree-sitter-rust
              tree-sitter-toml
              tree-sitter-tsx
              tree-sitter-typescript
              tree-sitter-yaml
          ]))
        ];
      })
      aerc
#      turbo
      ### LSP
      gopls
#      rust-analyzer
      poppler
      ffmpegthumbnailer
      mediainfo
      imagemagick
      yubikey-manager
      clojure
      colima
      delta
      starship
      bat
      fd
      swc
      dive
      tree
      tshark
      act
      bitwarden-cli
      cmake
      netcat
      catgirl
      zathura
      docker-client
      jq
      youtube-dl
      ytfzf
      gitflow
      got
      wget
      postgresql
      coreutils
      terraform
      caddy
      bun
      nest-cli
      kubernetes-helm
      kubeseal
      packer
      qemu
      kustomize
      k9s
      kubectl
      krew
      mblaze
      argocd
      kubernetes-helm
      cowsay
      hexedit
      spicetify-cli
      ffmpeg
      untrunc-anthwlock
      ansible
      openssl
      yamllint
      kubo
      gnumake42
      libqalculate
      lazygit
      mg
      k6
      swaks
      ngrok
      nodePackages.npm
      nodePackages.pnpm
      nodePackages.typescript
      nodePackages.npm-check-updates
      nodejs
      yarn
      python39
      python39Packages.pip
      perl
      openstackclient
      alacritty
      innernet
      wireguard-go
      wireguard-tools
      openvpn
      easyrsa
#      ncdu
      nginx
      nmap
      meld
      android-tools
      tailscale
    ];
}
