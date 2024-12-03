{ config, lib, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "Europe/Rome";

  services = {
     openssh = {
        enable = true;
        settings = {
          PermitRootLogin = "prohibit-password";
        };
     };
  };

  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "${pkgs.sway}/bin/sway";
        user = "heph";
      };
      default_session = initial_session;
    };
  };


  services.gnome.gnome-keyring.enable = true;
  users.users = {
    root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILCmIz2Selg5eJ77lvpJHgDJiRIOZbucMjDK5zrhTEWK heph@fenrir"
    ];
    heph.isNormalUser = true;
  };

  nix.package = pkgs.nixVersions.latest;
  nix.extraOptions = "experimental-features = nix-command flakes";

  environment.systemPackages = with pkgs; [
    home-manager
    grim
    slurp
    wl-clipboard
    mako
  ];

  hardware.graphics = {
    enable = true;
  };

  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 2375 50022 ];
  security.polkit.enable = true;
  system.stateVersion = "22.11";
}
