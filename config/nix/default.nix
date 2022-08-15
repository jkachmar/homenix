{lib, pkgs, unstable, ...}: let
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
    NIX_PATH = lib.concatStringsSep ":" [
      "nixpkgs=${pkgs.path}"
      "unstable=${unstable.path}"
    ];
  };
  xdg.configFile."nix/nix.conf".text = ''
    build-users-group = nixbld
    experimental-features = nix-command flakes
    substituters = ${lib.concatStringsSep " " substituters}
    trusted-public-keys = ${lib.concatStringsSep " " trustedPublicKeys}
  '';
}
