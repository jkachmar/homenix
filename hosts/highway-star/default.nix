{config, ...}: let
  inherit (config.lib.file) mkOutOfStoreSymlink;
in {
  imports = [
    ../../config
  ];

  xdg.configFile = {
    "containers/policy.json".source =
      mkOutOfStoreSymlink
      "${config.xdg.configHome}/dotfiles/hosts/highway-star/policy.json";
    "containers/registries.conf".source =
      mkOutOfStoreSymlink
      "${config.xdg.configHome}/dotfiles/hosts/highway-star/registries.conf";
  };
}
