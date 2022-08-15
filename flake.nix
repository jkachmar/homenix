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
    unstablePkgs,
    ...
  }: let
    # Utility function to construct a package set based on the given system
    # along with the shared `nixpkgs` configuration defined in this repo.
    mkPkgsFor = system: pkgset:
      import pkgset {
        inherit system;
        config = import ./config/nixpkgs/config.nix;
      };
  in {
    homeConfigurations = {
      manhattan-transfer = macosHome.lib.homeManagerConfiguration rec {
        system = "aarch64-darwin";
        pkgs = mkPkgsFor system macosPkgs;
        extraModules = [
          {_module.args.unstable = mkPkgsFor system unstablePkgs;}
        ];

        # NOTE: This changes pretty drastically in 22.11;
        username = "jkachmar";
        homeDirectory = "/Users/jkachmar";
        stateVersion = "22.05";
        configuration.imports = [./hosts/manhattan-transfer];
      };
    };
  };
}
