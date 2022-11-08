{
  config,
  pkgs,
  unstable,
  ...
}: {
  imports = [
    ./cli.nix
    ./neovim
    ./nix
    ./nixpkgs
  ];

  home.packages =
    (with pkgs; [
      starship # XXX: Unclear why it's necessary to manually install this...
    ])
    ++ (with unstable; []);

  programs = {
    # Allow 'home-manager' to manage its own install.
    home-manager.enable = true;

    # Interactive shells.
    bash.enable = true;
    zsh.enable = true;
    fish = {
      enable = true;
    };

    # Misc. dev tools.
    bat = {
      enable = true;
      config.theme = "ansi";
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;

      # Conditionally enable 'direnv' integration for interactive shells
      # managed via home-manager.
      enableBashIntegration = config.programs.bash.enable;
      enableZshIntegration = config.programs.zsh.enable;
    };

    fzf = {
      enable = true;
      # Conditionally enable 'fzf' integration for interactive shells managed
      # via home-manager.
      enableBashIntegration = config.programs.bash.enable;
      enableFishIntegration = config.programs.fish.enable;
      enableZshIntegration = config.programs.zsh.enable;
      tmux.enableShellIntegration = config.programs.tmux.enable;
    };

    git = {
      enable = true;
      package = unstable.git; # git-2.38 (includes `scalar`)
      extraConfig = {
        core.editor = "vim";
        init.defaultBranch = "main";
        pull.rebase = true;
        push.default = "simple";
        rerere.enabled = true;
      };
    };

    htop = {
      enable = true;
      settings = {
        hide_userland_threads = true;
        highlight_base_name = true;
        show_program_path = false;
        tree_view = true;
        vim_mode = true;
      };
    };

    starship = {
      enable = true;
      settings = {
        add_newline = false;
        line_break.disabled = true;
        username.show_always = true;
      };

      # Conditionally enable starship integration for shells that home-manager manages.
      enableBashIntegration = config.programs.bash.enable;
      enableFishIntegration = config.programs.fish.enable;
      enableZshIntegration = config.programs.zsh.enable;
    };

    tmux = {
      enable = true;
      keyMode = "vi";
    };
  };
}
