{
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) optionals;
  inherit (pkgs.stdenv.targetPlatform) isDarwin isLinux;

  # TODO: Abstract this out into its own module.
  caches = [
    # NixOS default cache.
    {
      url = "https://cache.nixos.org";
      key = "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=";
    }
  ];
  substituters = builtins.map (cache: cache.url) caches;
  trustedPublicKeys = builtins.map (cache: cache.key) caches;
in {
  home.sessionVariables = {
    NIX_PATH = lib.concatStringsSep ":" ([
        "unstable=${inputs.unstablePkgs}"
      ]
      ++ optionals isDarwin [
        "nixpkgs=${inputs.macosPkgs}"
      ]
      ++ optionals isLinux [
        "nixpkgs=${inputs.nixosPkgs}"
      ]);
  };
  xdg.configFile."nix/nix.conf".text = ''
    build-users-group = nixbld
    experimental-features = nix-command flakes
    substituters = ${lib.concatStringsSep " " substituters}
    trusted-public-keys = ${lib.concatStringsSep " " trustedPublicKeys}
  '';
}
