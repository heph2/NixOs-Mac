{ pkgs, lib, nur, config,  ... }:
{
    nix.extraOptions = ''
    auto-optimise-store = true
    experimental-features = nix-command flakes
'' + lib.optionalString (pkgs.system == "aarch64-darwin") ''
    extra-platforms = x86_64-darwin aarch64-darwin
'';

  users.users.marco.home = "/Users/marco";

  programs.zsh.enable = true;

  services.nix-daemon.enable = true;
  nix.distributedBuilds = true;

  services.dnsmasq = {
    enable = true;
    addresses = {
      localhost = "127.0.0.1";
      # lan = "192.168.1.30";
    };
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
      "vagrant"
      "yacreader"
      "rustrover"
      "joplin"
      "logisim-evolution"
      "vagrant-vmware-utility"
      "lagrange"
      "qtspim"
      "citra"
      "spotify"
      "firefox"
      "openlens"
      "nvidia-geforce-now"
      "shortcat"
      "xournal-plus-plus"
      "transmission"
      "rectangle"
      "logi-options-plus"
      "vlc"
      "mattermost"
      "cog"
      "balenaetcher"
      "cyberduck"
      "syncthing"
      "zotero"
      "vmware-fusion"
      "gimp"
      "chromium"
      "element"
      "wireshark"
      "iterm2"
      "mumble"
      "koodo-reader"
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
      "anydesk"
      "obsidian"
      "raycast"
      "intellij-idea-ce"
      "utm"
      "chiaki"
      "logseq"
      "karabiner-elements"
      "vscodium"
      "webstorm"
      "thunderbird"
    ];
    brews = [
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
      "k6"
      "mongodb-atlas-cli"
      "minidlna"
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
