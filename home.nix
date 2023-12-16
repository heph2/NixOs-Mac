{ config, pkgs, lib, ... }:
with lib;
{
  home.stateVersion = "22.05";

  home.sessionVariables = {
    EDITOR = "mg";
#    DOCKER_HOST = "tcp://127.0.0.1:2375";
  };

  programs = {
    direnv.enable = true;
    direnv.nix-direnv.enable = true;

    htop.enable = true;
    msmtp.enable = true;
    emacs =  {
      enable = true;
      extraPackages = epkgs: [
        pkgs.mu
        pkgs.notmuch
        pkgs.irony-server
      ];
    };
    nixvim = {
      enable = true;
      colorschemes.gruvbox.enable = true;
      plugins.lightline.enable = true;
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
        s  = "switch";
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
        { name = "fzf"; src = pkgs.fishPlugins.fzf-fish.src; }
        {
          name = "z";
          src = pkgs.fetchFromGitHub {
          owner = "jethrokuan";
          repo = "z";
          rev = "e0e1b9dfdba362f8ab1ae8c1afc7ccf62b89f7eb";
          sha256 = "0dbnir6jbwjpjalz14snzd3cgdysgcs3raznsijd6savad3qhijc";
          };
        }
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
      #source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.fish.inc"
      #eval (direnv hook fish)
      set -gx PATH $PATH $HOME/.krew/bin
      set -gx PATH $PATH $HOME/.cargo/bin
      set -gx PATH $PATH $HOME/.spicetify
      '';
      shellAliases = {
        imp = "mdirs ~/.maildir/personal | mlist -st | mthread -r | mseq -S; mless";
        smp = "mdirs ~/.maildir/personal";
        dw = "darwin-rebuild switch --flake '.#heph'";
	porte = "sudo lsof -nP -i4TCP:$PORT | grep LISTEN";
        wake-fenrir = "wakeonlan 00:d8:61:d8:be:d1";
        d = "docker";
        d-prune-containers = "docker rm $(docker ps -q --filter \"status=exited\")";
        d-prune-images = "docker image rm -a";
        k = "kubectl";
        c = "cargo";
        sat = "__fish_saturn";
        clbin = "__fish_clbin";
        vs = "codium";
        plass-fish = "__fish_plass";
        plass-fish-edit = "__fish_plass-edit";
        webhook-inclinic = "curl -X POST -H 'Authorization: token $GH_PAT_WH' -H 'Accept: application/vnd.github.everest-preview+json' -d '{\"event_type\": \"webhook\"}' https://api.github.com/repos/DavinciSalute/davinci-test/dispatches";
	pod-start = "podman machine start";
        cloudsql-staging= "cloud_sql_proxy -credential_file=/Users/marco/certs/gcp/key-cloudsql.json -instances=davinci-1eea1:europe-west3:postgres-staging=tcp:0.0.0.0:5432";
        t = "tailscale";
        tempo = "curl https://wttr.in/NOVA_MILANESE";
        k-prod = "k config use-context gke_davinci-1eea1_europe-west3_cluster-production";
        k-dev = "k config use-context gke_dev-project-00ad_europe-west1_gke-cluster";
        k-staging = "k config use-context gke_davinci-1eea1_europe-west3_cluster-staging";
        k-innovators = "k config use-context gke_davinci-1eea1_europe-west3_cluster-innovators";
        k-mgmt = "k config use-context gke_mgmt-project-00ad_europe-west1_gke-cluster-mgmt";
        k-test = "k config use-context gke_davinci-1eea1_europe-west1_autopilot-cluster-1";
        k-fr = "k config use-context gke_fr-agola-debf_europe-west1_gke-cluster-fr";
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
         __fish_win_iso_creater = {
           body = ''
             if test (count $argv) -lt 2
                echo "You need to provide disk location (first arg) and iso location (second arg)"
             else
                echo "erasing disk..."
                diskutil eraseDisk MS-DOS WINDOWS10 GPT $argv[1]
                echo "mounting iso volume..."
                set iso_volume (hdiutil mount $argv[2] | awk '{ print $2 }')
                echo "copy files..."
                rsync -exclude=sources/install.wim $iso_volume/* /Volumes/WINDOWS10
                echo "still copying..."
                wimlib-imagex split $iso_volume/sources/install.wim /Volumes/WINDOWS10/sources/install.swm 3000
                echo "Done!"
             end
           '';
         };
         __fish_get_secret = {
           body = ''
             kubectl -n staging get secrets $argv[1] -o yaml | grep $argv[2] | awk '{ print $2 }' | base64 -d
           '';
         };
         __fish_clbin = {
           body = ''
             cat $argv[1] | curl -F 'clbin=<-' https://clbin.com | pbcopy
           '';
         };
         __fish_test = {
           body = ''
             if test (count $argv) -lt 2
                echo "missing argv"
             else
                echo "this is first argv: $argv[1], this is the second: $argv[2]"
             end
           '';
         };
         __fish_generate-openssl-crt = {
           body = ''
             echo 'basicConstraints=CA:true' > /tmp/android_options.txt
             openssl genrsa -out /tmp/priv_and_pub.key 2048
             openssl req -new -days 3650 -key /tmp/priv_and_pub.key -out /tmp/CA.pem
             openssl x509 -req -days 3650 -in /tmp/CA.pem -signkey /tmp/priv_and_pub.key -extfile /tmp/android_options.txt -out /tmp/CA.crt
             openssl x509 -inform PEM -outform DER -in /tmp/CA.crt -out /tmp/CA.der.crt
             echo "Certificate generated!"
           '';
         };
         __fish_iap_grant = {
           body = ''
             set BACKEND_SERVICE (gcloud compute backend-services list --filter="name~'myargo-argocd-server'" --format="value(name)")
             set SA_ACCOUNT m.bauce@davinci.care
             set USER_EMAIL $argv[1]
             gcloud iap web add-iam-policy-binding \
                    --resource-type=backend-services \
                    --service $BACKEND_SERVICE \
                    --member=user:$USER_EMAIL \
                    --role='roles/iap.httpsResourceAccessor' \
                    --account=$SA_ACCOUNT
           '';
         };
         __fish_random_line = {
           body = ''
             set NUM_LINES (cat $arvg[1] | wc -l)
             set RANDOM_NUM (shuf -i 1-$NUM_LINES -n 1)
             cat $argv[1] | sed -n $RANDOM_NUMp
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
    aerc
    imagemagick
    clojure
    colima
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
    kubernetes-helm
    kubeseal
    packer
    qemu
    kustomize
    k9s
    kubectl
    krew
    # himalaya
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
    # kakoune
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
    ncdu
    nginx
    nmap
    meld
    android-tools
    tailscale
  ];
}
