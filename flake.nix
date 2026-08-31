{
  description = "Aurimas' Mac Pro 5,1 NixOS Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    # Add Home Manager and link it to your Nixpkgs branch
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }: {
    nixosConfigurations = {

      # 1. Virtual Machine (Testing Environment)
      utm = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          ./hardware-configuration-utm.nix # Uses the UTM hardware map

          # Inject Home Manager into the NixOS build
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            # Point to your dedicated user configuration file
            home-manager.users.avalue = import ./home.nix;
          }
        ];
      };

      # 2. Physical Mac Pro 5,1 (Bare-Metal Environment)
      macpro = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          ./hardware-configuration-macpro.nix # You will generate this on the live USB

          # Inject Home Manager into the NixOS build
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            # Point to your dedicated user configuration file
            home-manager.users.avalue = import ./home.nix;
          }
        ];
      };
    };
  };
}
