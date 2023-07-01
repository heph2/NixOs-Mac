{ pkgs, lib, nur, config,  ... }:
{
    nix.extraOptions = ''
    auto-optimise-store = true
    experimental-features = nix-command flakes
  '' + lib.optionalString (pkgs.system == "aarch64-darwin") ''
    extra-platforms = x86_64-darwin aarch64-darwin
  '';

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix.distributedBuilds = true;

  services.emacs = {
    enable = false;
  };

  services.synapse-bt = {
    enable = true;
  };

  services.tailscale = {
    enable = false;
  };
   
  homebrew = {
    enable = true;
    casks = [
      "telegram-desktop"
      "firefox"
      "openlens"
      "xournal-plus-plus"
      "transmission"
      "vlc"
      "mattermost"
      "cog"
      "balenaetcher"
      "cyberduck"
      "epic-games"
      "chiaki"
      "syncthing"
      "zotero"
      "gimp"
      "chromium"
      "wireshark"
      "iterm2"
      "mumble"
      "koodo-reader"
      "docker"
      "insomnia"
      "android-platform-tools"
      "slack"
      "blackhole-64ch"
      "google-cloud-sdk"
      "notion"
      "mpv"
      "airflow"
      "mumble"
      "soulseek"
      "tunnelblick"
      "syncplay"
      "emacs"
      "anydesk"
      "raycast"
      "steam"
      "intellij-idea-ce"
      "utm"
      "chiaki"
      "logseq"
      "karabiner-elements"
      "vscodium"
      "thunderbird"
    ];
    brews = [
      "docker-compose"
      "qemu"
      "wimlib"
      "spice-protocol"
      "podman"
      "wakeonlan"
      "platformio"
      "alpine"
      "esphome"
      "qt"
      "magic-wormhole"
    ];
    taps = [
      {
        name = "null-dev/firefox-profile-switcher";
        clone_target = "https://github.com/null-dev/firefox-profile-switcher";
        force_auto_update = true;
      }
    ];
  };
  # Apps
  # `home-manager` currently has issues adding them to `~/Applications`
  # Issue: https://github.com/nix-community/home-manager/issues/1341
  environment.systemPackages = with pkgs; [
    cachix
    pass gnupg pinentry pinentry-curses
    isync mutt mu notmuch
    terminal-notifier
    go
    gradle
    jdk
    #    config.nur.repos.heph2.google-cloud-sdk-auth-plugin
  ];

  # https://github.com/nix-community/home-manager/issues/423
  environment.variables = {
  };
  programs.nix-index.enable = true;

  # Fonts
  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [
     recursive
     nerdfonts
   ];

  nixpkgs.config.allowBroken = true;
  # Keyboard
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;
  system.defaults.trackpad.TrackpadRightClick = true;

  # Add ability to used TouchID for sudo authentication
  security.pam.enableSudoTouchIdAuth = true;

}
