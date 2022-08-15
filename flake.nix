{
  description = "jkachmar's dotfiles";

  inputs = {
    unstablePkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    macosPkgs.url = "github:nixos/nixpkgs/nixpkgs-22.05-darwin";
    macosHome = {
      url = "github:nix-community/home-manager/release-22.05";
      inputs.nixpkgs.follows = "macosPkgs";
    };

    nixosPkgs.url = "github:nixos/nixpkgs/nixos-22.05";
    nixosHome = {
      url = "github:nix-community/home-manager/release-22.05";
      inputs.nixpkgs.follows = "nixosPkgs";
    };
  };

  outputs = inputs @ {
    macosPkgs,
    macosHome,
    nixosPkgs,
    nixosHome,
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
          {
            _module.args.inputs = inputs;
            _module.args.unstable = mkPkgsFor system unstablePkgs;
          }
        ];

        # NOTE: This changes pretty drastically in 22.11;
        username = "jkachmar";
        homeDirectory = "/Users/jkachmar";
        stateVersion = "22.05";
        configuration.imports = [./hosts/manhattan-transfer];
      };

      # NOTE: $WORK configures my development VM automatically & assigns it a
      # hostname based off of my username, BUT it's important to keep this
      # config's naming scheme consistent (i.e. using JoJo stands).
      jkachmar = nixosHome.lib.homeManagerConfiguration rec {
        system = "x86_64-linux";
        pkgs = mkPkgsFor system nixosPkgs;
        extraModules = [
          {
            _module.args.inputs = inputs;
            _module.args.unstable = mkPkgsFor system unstablePkgs;
          }
        ];

        # NOTE: This changes pretty drastically in 22.11;
        username = "jkachmar";
        homeDirectory = "/Users/jkachmar";
        stateVersion = "22.05";
        configuration.imports = [./hosts/highway-star];
      };
    };
  };
}
