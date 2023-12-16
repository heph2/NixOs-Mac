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
  };

  outputs = { self, darwin, nixpkgs, home-manager, nur, emacs, nixpkgs-unstable, nixvim, ... }: 
    let
      nixpkgsConfig = {
        config = { allowUnfree = true; };
      };
    in {
      darwinConfigurations."heph" = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [ 
	        ./configuration.nix
          nur.nixosModules.nur
          # nixvim.homeManagerModules.nixvim
	        home-manager.darwinModules.home-manager
	        {
	          nixpkgs = nixpkgsConfig;
	          home-manager.useGlobalPkgs = true;
	          home-manager.useUserPackages = true;
	          home-manager.users.marco = import ./home.nix;
            home-manager.sharedModules = [
              nixvim.homeManagerModules.nixvim
            ];
	        }
        ] ++ [
        {
          nix.settings.substituters = [
            "https://cachix.org/api/v1/cache/emacs"
          ];

          nix.settings.trusted-public-keys = [
            "emacs.cachix.org-1:b1SMJNLY/mZF6GxQE+eDBeps7WnkT0Po55TAyzwOxTY="
          ];
        }
        ];
      };
    };
}
