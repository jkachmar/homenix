{
  description = "jkachmar's dotfiles";

  inputs = {
    unstablePkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    macosPkgs.url = "github:nixos/nixpkgs/nixpkgs-22.05-darwin";
    macosHome = {
      url = "github:nix-community/home-manager/release-22.05";
      inputs.nixpkgs.follows = "macosPkgs";
    };
  };

  outputs = {
    macosPkgs,
    macosHome,
    ...
  }: {
    homeConfigurations = {
      manhattan-transfer = macosHome.lib.homeManagerConfiguration rec {
        system = "aarch64-darwin";
        pkgs = macosPkgs.legacyPackages."${system}";

        # NOTE: This changes pretty drastically in 22.11;
        username = "jkachmar";
        homeDirectory = "/Users/jkachmar";
        stateVersion = "22.05";
        configuration.imports = [./hosts/manhattan-transfer];
      };
    };
  };
}
