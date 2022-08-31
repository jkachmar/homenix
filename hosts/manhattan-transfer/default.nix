{...}: {
  imports = [
    ../../config
    ../../config/fonts.nix
    ../../config/vscode
  ];

  # NOTE: macOS version upgrades reset '/etc/zshrc', which means that the shell
  # no longer "knows" how to source all Nix-related stuff.
  #
  # Hopefully this is a reasonable workaround, but if not then switching to
  # 'fish' works in a pinch (i.e. how i've avoided running into this problem on
  # other macOS machines so far.
  #
  # cf. https://discourse.nixos.org/t/nix-commands-missing-after-macos-12-1-version-upgrade/16679
  programs.zsh.initExtraFirst = ''
    # Nix
    if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
      . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
    fi
    # End Nix
  '';
}
