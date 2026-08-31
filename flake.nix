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

  outputs = { nixpkgs, home-manager, ... }:
    let
      # Define the shared configuration block once
      sharedModules = [
        ./configuration.nix
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
        # 1. Virtual Machine (Testing Environment)
        utm = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = sharedModules ++ [ ./hardware-configuration-utm.nix ];
        };

        # 2. Physical Mac Pro 5,1 (Bare-Metal Environment)
        macpro = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = sharedModules ++ [ ./hardware-configuration-macpro.nix ];
        };
      };
    };
}
