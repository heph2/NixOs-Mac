{ pkgs, lib, nur, config, ... }: {

  imports = [
    ./brew.nix
    ./wm.nix
  ];

  nix.extraOptions = ''
    auto-optimise-store = true
    experimental-features = nix-command flakes
  '' + lib.optionalString (pkgs.system == "aarch64-darwin") ''
    extra-platforms = x86_64-darwin aarch64-darwin
  '';

  nix.configureBuildUsers = true;
  nix.distributedBuilds = true;
  nixpkgs.config.allowBroken = true;
  ids.uids.nixbld = 350;
  nix.settings = {
    trusted-users = [ "marco" "root" ];
    substituters = [
      "https://cache.nixos.org"
      "https://cache.nixos.org/"
      "https://nix-community.cachix.org"
      "https://devenv.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
    ];
  };

  users.users.marco.home = "/Users/marco";

  programs.zsh.enable = true;
  programs.nix-index.enable = true;
  services.nix-daemon.enable = true;
  services.dnsmasq = {
    enable = true;
    addresses = {
      localhost = "127.0.0.1";
      # lan = "192.168.1.30";
    };
  };
  services.synapse-bt = { enable = false; }; # Current using Barrier
  services.tailscale = { enable = false; }; # This doesn't ship with Tray

  # Apps
  # `home-manager` currently has issues adding them to `~/Applications`
  # Issue: https://github.com/nix-community/home-manager/issues/1341
  environment.systemPackages = with pkgs; [
    cachix
    granted
    nixfmt-classic
    pass
    gnupg
    pinentry_mac
    pinentry-curses
    isync
    mutt
    mu
    notmuch
    terminal-notifier
    go
    gradle
    jdk
  ];

  # https://github.com/nix-community/home-manager/issues/423
  environment.variables = { };

  # Fonts
  fonts.packages = with pkgs; [ recursive nerdfonts ];

  # Keyboard
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;
  system.defaults.trackpad.TrackpadRightClick = true;

  # Add ability to used TouchID for sudo authentication
  security.pam.enableSudoTouchIdAuth = true;
  system.stateVersion = 4;
}
