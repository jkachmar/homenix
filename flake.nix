{
  description = "jkachmar's dotfiles";

  inputs = {
    # Main development branch; useful for packages that have not made their way
    # through Hydra yet.
    #
    # NOTE: Use this pin sparingly! These packages are likely to not be cached
    # and can potentially result in very long rebuild times.
    unstablePkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    macosPkgs.url = "github:nixos/nixpkgs/nixpkgs-22.11-darwin";
    macosHome = {
      url = "github:nix-community/home-manager/release-22.11";
      inputs.nixpkgs.follows = "macosPkgs";
    };

    nixosPkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    nixosHome = {
      url = "github:nix-community/home-manager/release-22.11";
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
      manhattan-transfer = let
        system = "aarch64-darwin";
      in
        macosHome.lib.homeManagerConfiguration {
          pkgs = mkPkgsFor system macosPkgs;
          modules = [
            # Inject 'inputs' & 'unstable' package set to common module imports.
            {
              _module.args.inputs = inputs;
              _module.args.unstable = mkPkgsFor system unstablePkgs;
            }
            # Common 'home-manager' configuration or Linux hosts.
            #
            # TODO: Abstract this out into a module or function or something.
            {
              home.username = "jkachmar";
              home.homeDirectory = "/Users/jkachmar";
              home.stateVersion = "22.11";
            }
            # Entry point for this machine's config.
            ./hosts/manhattan-transfer
          ];
        };

      # NOTE: $WORK configures my development VM automatically & assigns it a
      # hostname based off of my username, BUT it's important to keep this
      # config's naming scheme consistent (i.e. using JoJo stands).
      jkachmar = let
        system = "x86_64-linux";
      in
        nixosHome.lib.homeManagerConfiguration {
          pkgs = mkPkgsFor system nixosPkgs;
          modules = [
            # Inject 'inputs' & 'unstable' package set to common module imports.
            {
              _module.args.inputs = inputs;
              _module.args.unstable = mkPkgsFor system unstablePkgs;
            }
            # Common 'home-manager' configuration or Linux hosts.
            #
            # TODO: Abstract this out into a module or function or something.
            {
              home.username = "jkachmar";
              home.homeDirectory = "/home/jkachmar";
              home.stateVersion = "22.11";
            }
            # Entry point for this machine's config.
            ./hosts/highway-star
          ];
        };
    };
  };
}
