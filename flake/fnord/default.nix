{ pkgs, inputs, ... }: {
  flake.nixosConfigurations.fnord = inputs.nixpkgs.lib.nixosSystem {
    system = "aarch64-linux";
    modules = [
      ./configuration.nix
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.heph = import ./home.nix;
        home-manager.sharedModules = [
        ];
      }
    ];
  };
}
