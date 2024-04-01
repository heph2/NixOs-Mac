{ pkgs, inputs, ... }:
{
  flake.darwinConfigurations.aron = inputs.darwin.lib.darwinSystem {
    system = "aarch64-darwin";
    modules = [ 
	    ./configuration.nix
      {
	nixpkgs.config.allowUnfree = true;
        nixpkgs.overlays = [ inputs.emacs-overlay.overlay ];
      }
      inputs.nur.nixosModules.nur
	    inputs.home-manager.darwinModules.home-manager
	    {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.marco = import ./home.nix;
        home-manager.sharedModules = [
#          inputs.nixvim.homeManagerModules.nixvim
        ];
      }
    ];
  };
}
