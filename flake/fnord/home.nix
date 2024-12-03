{ inputs, config, pkgs, lib, ... }: {
  imports = [
  ];

  home.stateVersion = "22.11";
  home.username = "heph";
  home.homeDirectory = "/home/heph";
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    config = rec {
      modifier = "Mod4";
      terminal = "foot";
      # startup = [
      #   {command = "firefox";}
      # ];
    };
  };

  home.packages = with pkgs; [
    swaylock
    swayidle
    alacritty
    foot
    wofi
    waybar
  ];
}
