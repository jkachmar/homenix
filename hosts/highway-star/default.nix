{config, ...}: let
  inherit (config.lib.file) mkOutOfStoreSymlink;
in {
  imports = [
    ../../config
  ];

  # NOTE: True color detectio needs to be forced when editing over SSH.
  #
  # cf. https://github.com/helix-editor/helix/issues/2292#issuecomment-1110179773
  programs.helix.settings.editor.true-color = true;

  xdg.configFile = {
    "containers/policy.json".source =
      mkOutOfStoreSymlink
      "${config.xdg.configHome}/dotfiles/hosts/highway-star/policy.json";
    "containers/registries.conf".source =
      mkOutOfStoreSymlink
      "${config.xdg.configHome}/dotfiles/hosts/highway-star/registries.conf";
  };
}
