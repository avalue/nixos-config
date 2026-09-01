{
  description = "Aurimas' Mac Pro 5,1 NixOS Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    openlogi.url = "github:AprilNEA/OpenLogi";
  };

  outputs = { nixpkgs, home-manager, openlogi, ... }:
    let
      sharedModules = [
        ./configuration.nix
        openlogi.nixosModules.default
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.avalue = import ./home.nix;
        }
      ];
    in
    {
      nixosConfigurations = {
        utm = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = sharedModules ++ [ ./hardware-configuration-utm.nix ];
        };

        macpro = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = sharedModules ++ [ ./hardware-configuration-macpro.nix ];
        };
      };
    };
}