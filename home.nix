{ config, pkgs, lib, ... }:
with lib;
{
  home.stateVersion = "22.05";

#  home.activation = mkIf pkgs.stdenv.isDarwin {
#      copyApplications = let
#        apps = pkgs.buildEnv {
#          name = "home-manager-applications";
#          paths = config.home.packages;
#          pathsToLink = "/Applications";
#        };
#      in lib.hm.dag.entryAfter [ "writeBoundary" ] ''
#        baseDir="$HOME/Applications/Home Manager Apps"
#        if [ -d "$baseDir" ]; then
#          rm -rf "$baseDir"
#        fi
#        mkdir -p "$baseDir"
#        for appFile in ${apps}/Applications/*; do
#          target="$baseDir/$(basename "$appFile")"
#          $DRY_RUN_CMD cp ''${VERBOSE_ARG:+-v} -fHRL "$appFile" "$baseDir"
#          $DRY_RUN_CMD chmod ''${VERBOSE_ARG:+-v} -R +w "$target"
#        done
#      '';
#  };

  home.sessionVariables = {
    EDITOR = "mg";
    DOCKER_HOST = "tcp://192.168.1.4:2375";
  };

  programs = {
    direnv.enable = true;
    direnv.nix-direnv.enable = true;

    htop.enable = true;
    msmtp.enable = true;
    emacs =  {
      enable = true;
#      package = config.services.emacs.package;
      extraPackages = epkgs: [
        pkgs.mu
        pkgs.notmuch
        pkgs.irony-server
      ];
    };
 
    tmux = {
      enable = true;
      shell = "/etc/profiles/per-user/marco/bin/fish";
      extraConfig = ''setw -g mouse on'';
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
      };
      extraConfig = {
        pull.ff = "only";
      };
      userEmail = "srht@mrkeebs.eu";
      userName = "heph";
    };

    fish = {
      enable = true;
      plugins = [
        {
          name = "foreign-env";
          src = pkgs.fetchFromGitHub {
            owner = "oh-my-fish";
            repo = "plugin-foreign-env";
            rev = "dddd9213272a0ab848d474d0cbde12ad034e65bc";
            sha256 = "00xqlyl3lffc5l0viin1nyp819wf81fncqyz87jx8ljjdhilmgbs";
          };
        }

        {
          name = "bobthefish";
          src = pkgs.fetchFromGitHub {
            owner = "oh-my-fish";
            repo = "theme-bobthefish";
            rev = "a2ad38aa051aaed25ae3bd6129986e7f27d42d7b";
            sha256 = "1fssb5bqd2d7856gsylf93d28n3rw4rlqkhbg120j5ng27c7v7lq";
          };
        }
      ];

      loginShellInit = ''
      if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
        fenv source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
      end

      if test -e /nix/var/nix/profiles/default/etc/profile.d/nix.sh
        fenv source /nix/var/nix/profiles/default/etc/profile.d/nix.sh
      end
      source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.fish.inc"
      eval (direnv hook fish)
      set -gx PATH $PATH $HOME/.krew/bin
      '';
      shellAliases = {
        dw = "darwin-rebuild switch --flake '.#heph'";
	porte = "sudo lsof -nP -i4TCP:$PORT | grep LISTEN";
        wake-fenrir = "wakeonlan 00:d8:61:d8:be:d1";
        d = "docker";
        k = "kubectl";
        c = "cargo";
        sat = "__fish_saturn";
        plass-fish = "__fish_plass";
        plass-fish-edit = "__fish_plass-edit";
	k-argo = "kubectl port-forward svc/argocd-server -n argocd 8080:443";
	pod-start = "podman machine start";
        k-prod = "k config use-context gke_davinci-1eea1_europe-west3_cluster-production";
        k-dev = "k config use-context gke_davinci-1eea1_europe-west3_cluster-dev";
        k-staging = "k config use-context gke_davinci-1eea1_europe-west3_cluster-staging";
        k-innovators = "k config use-context gke_davinci-1eea1_europe-west3_cluster-innovators";
        k-test = "k config use-context gke_davinci-1eea1_europe-west1_autopilot-cluster-1";
        k-get-image = "kubectl get pods --all-namespaces -o jsonpath='{.items[*].spec.containers[*].image}' |\
tr -s '[[:space:]]' '\n' |\
sort |\
uniq -c";
      };
      functions = {
          __fish_saturn = {
            body = ''
              set -l options (fish_opt -s h -l help)
              set options $options (fish_opt -s m -l mode --required-val)
              set options $options (fish_opt -s n -l num --required-val)
              argparse $options -- $argv

              if set -q _flag_help
                 saturn -help
                 return 0
              end

              if set -q _flag_mode and set -q _flag_num
                 if set x (saturn -search $argv | fzf)
                    saturn -fetch $x $_flag_mode $_flag_num
                 end
              else
                 if set x (saturn -search $argv | fzf)
                    set num_ep (saturn -fetch $x | fzf -m | grep -oP 'ID:\s*\K\d+' | tr ' ' '-')
		    set sanitized_num_ep (echo $num_ep | tr ' ' '-')
	            saturn -fetch $x $_flag_mode $sanitized_num_ep
                    return 0
                 end
              end
            '';
          };
          __fish_plass = {
            body = ''
              if set x (plass find $argv | fzf)
                 plass cat $x | while read -f field
                    echo $field
                 end | fzf | pbcopy
              end
            '';
          };
         __fish_plass-edit = {
           body = ''
             if set x (plass find $argv | fzf)
                plass edit $x
             end
           '';
         };
         __fish_kubectl_ns_remover = {
           body = ''
             for i in (kubectl get ns | awk '{ print $1 }')
                 if set target_ns (string match -r $argv $i)
                    kubectl delete ns $target_ns
                 end
             end
           '';
         };
      };
    };
  };

  xdg.configFile."fish/conf.d/plugin-bobthefish.fish".text = lib.mkAfter ''
    for f in $plugin_dir/*.fish
      source $f
    end
    '';
  
  accounts.email.accounts."work" = {
    address = "m.bauce@davinci.care";
    maildir.path = "/Users/marco/.maildir/work";
    mu.enable = true;
    primary = true;
  };

  home.packages = with pkgs; [
    cowsay
    imagemagick
    clojure
    dive
    tree
    act
    bitwarden-cli
    cmake
    netcat
    catgirl
    zathura
    jq
    youtube-dl
    ytfzf
    gitflow
    got
    wget
    terraform
    kubernetes-helm
    kubeseal
    kustomize
    k9s
    kubectl
    krew
    argocd
    kubernetes-helm
    openssl    
    yamllint
    neovim
#    ncdu
    mg
    nodePackages.npm
    nodePackages.npm-check-updates
    nodejs
    yarn
    python39
    perl
    openstackclient
    alacritty
  ];
}
