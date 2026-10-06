{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    yazi-flavors = {
      url = "github:yazi-rs/flavors";
      flake = false;
    };
  };

  outputs = inputs@{ nixpkgs, home-manager, ... }: {
    overlays.default = final: prev: {
      plannotator = final.callPackage ./pkgs/plannotator.nix { };
    };

    packages.x86_64-linux = let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [ inputs.self.overlays.default ];
      };
    in {
      inherit (pkgs) plannotator;
      plannotator-skills = pkgs.plannotator.skills;
      default = pkgs.plannotator;
    };

    homeManagerModules.plannotator = import ./modules/plannotator.nix;

    nixosConfigurations.desktop =
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          home-manager.nixosModules.default
          {
            nixpkgs.overlays = [ inputs.self.overlays.default ];
            home-manager.useGlobalPkgs = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.fys = import ./home.nix;
          }
        ];
      };
  };
}
