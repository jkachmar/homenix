{
  config,
  pkgs,
  ...
}: let
  inherit (config.lib.file) mkOutOfStoreSymlink;
in {
  imports = [
    ../../config
  ];

  # NOTE: Works w/ the tmux config (below) to set the Okta auth stuff.
  programs.bash.bashrcExtra = ''
    if [ -n "$TMUX" ]; then
      function refresh () {
        eval $(tmux showenv -s)
      }
    else
      function refresh () { :; }
    fi
  '';

  programs.starship.settings = {
    # XXX: Removes trailing space.
    gcloud.symbol = "☁️ ";
    hostname = {
      disabled = false;
      format = "[$hostname-dev-vm](bold red) in ";
      style = "bold green";
    };
  };

  programs.tmux.extraConfig = ''
    set -g update-environment "SFT_AUTH_SOCK SSH_AUTH_SOCK SSH_CONNECTION DISPLAY"
    set -g mouse on
  '';

  xdg.configFile = {
    "containers/policy.json".source =
      mkOutOfStoreSymlink
      "${config.xdg.configHome}/dotfiles/hosts/highway-star/policy.json";
    "containers/registries.conf".source =
      mkOutOfStoreSymlink
      "${config.xdg.configHome}/dotfiles/hosts/highway-star/registries.conf";
  };
}
