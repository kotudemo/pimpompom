{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    home-manager.url = "github:nix-community/home-manager/";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    stylix.url = "github:danth/stylix";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    chaotic,
    stylix,
    ...
  } @ inputs: {
    nixosConfigurations = {
      goidapc = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          chaotic.nixosModules.default
          home-manager.nixosModules.default
          stylix.nixosModules.stylix
          ./default.nix
        ];
      };
    };
  };
}
