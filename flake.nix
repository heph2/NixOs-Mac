{ 
  description = "Marco's darwin system";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-23.11-darwin";
    nixpkgs-unstable.url = github:NixOS/nixpkgs/nixpkgs-unstable;
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    emacs.url = "github:cmacrae/emacs";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nur.url = "github:nix-community/NUR";
    devenv.url = "github:cachix/devenv";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    cachix-deploy-flake.url = "github:cachix/cachix-deploy-flake";
    cachix-deploy-flake.inputs.darwin.follows = "darwin";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

outputs = inputs@{ flake-parts, ... }:
  flake-parts.lib.mkFlake { inherit inputs; } {
    imports = [
      ./flake/aron/default.nix
    ];
    systems = [
      # systems for which you want to build the `perSystem` attributes
      "x86_64-linux"
      "aarch64-darwin"
    ];
  };
}
