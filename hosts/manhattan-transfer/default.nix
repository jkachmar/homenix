{config, ...}: let
  sshConfigDir = "${config.home.homeDirectory}/.ssh";
  matchFile = "${sshConfigDir}/config.match";
  workFile = "${sshConfigDir}/config.work";
in {
  imports = [
    ../../config
    ../../config/fonts.nix
    ../../config/vscode
  ];

  # XXX: Partial workaround for https://github.com/nix-community/home-manager/issues/2769
  home.file."${matchFile}".text = ''
    Include ${workFile}
  '';
  programs.ssh.extraOptionOverrides."Include" = matchFile;

  # NOTE: No explicit SSH configuration necessary on non-macOS machines.
  # TODO: Evaluate whether this is worth factoring out into a separate
  # config module anyway.
  programs.ssh = {
    enable = true;
    userKnownHostsFile = "${sshConfigDir}/known_hosts";
    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = [
          "${sshConfigDir}/id_github"
        ];
      };
    };
  };

  # Fixes a bug where fish shell doesn't properly set up the PATH on macOS.
  #
  # FIXME: Looks like a clean reinstall of Nix should fix this now that the
  # installer provides a fish config.
  #
  # cf. https://github.com/LnL7/nix-darwin/issues/122#issuecomment-1299764109
  programs.fish.shellInit = ''
    for p in /usr/local/bin /nix/var/nix/profiles/default/bin ~/.nix-profile/bin
      if not contains $p $fish_user_paths
        set -g fish_user_paths $p $fish_user_paths
      end
    end
  '';

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
