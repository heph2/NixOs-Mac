{ pkgs, ... }:
{
  flake.nixosConfigurations.aron = pkgs.lib.darwinSystem {
    system = "aarch64-darwin";
    modules = [ 
	    ./configuration.nix
      nur.nixosModules.nur
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
    ]    
  };
}
