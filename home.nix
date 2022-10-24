{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "yuxi";
  home.homeDirectory = "/Users/yuxi";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  home.packages = with pkgs; [
    unzip

    # editors
    neovim
    nodejs # for coc.vim
    nixpkgs-fmt
    yarn
    shellcheck
    ripgrep

    # tmux
    tmux-mem-cpu-load
    xclip

    # utilities
    htop
    bc
    zip
    sshfs
    parallel
    google-cloud-sdk
    cloud-sql-proxy

    # ocaml
    opam
  ];

  programs.git = {
    enable = true;
    userName = "crvdgc";
    userEmail = "ubikium@gmail.com";
    extraConfig = {
      merge.tool = "fugitive";
      mergetool.keepBackup = false;
      mergetool.fugitive.cmd = ''nvim -f -c "Gvdiffsplit!" "$MERGED"'';

      # stop git from changing line endings
      core.autocrlf = false;
      core.whitespace = "cr-at-eol";

      # let git display utf-8 characters
      core.quotepath = false; # git status utf-8
      gui.encoding = "utf-8"; # git GUI utf-8
      i18n.commit.encoding = "utf-8"; # commit utf-8
      i18n.logoutputencoding = "utf-8"; # log utf-8

    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.tmux = {
    enable = true;
    clock24 = true;
    historyLimit = 20000;
    keyMode = "vi";
    aggressiveResize = true;
    terminal = "screen-256color";
    # modified from
    # https://github.com/samoshkin/tmux-config/blob/master/tmux/tmux.conf
    extraConfig = ''
      set -g mouse on
      set -s escape-time 0

      # paste
      setw -g mode-keys vi
      bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'xclip -in -selection clipboard'

      # new window and retain cwd
      bind c new-window -c "#{pane_current_path}"
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      unbind l    # last-window
      bind l select-pane -R


      # Prompt to rename window right after it's created
      set-hook -g after-new-window 'command-prompt -I "#{window_name}" "rename-window '%%'"'

      # theme
      # Feel free to NOT use this variables at all (remove, rename)
      # this are named colors, just for convenience
      color_orange="colour166" # 208, 166
      color_purple="colour134" # 135, 134
      color_green="colour076" # 070
      color_blue="colour32"
      color_yellow="colour220"
      color_red="colour160"
      color_black="colour232"
      color_white="white" # 015
      color_gray="colour244"

      # This is a theme CONTRACT, you are required to define variables below
      # Change values, but not remove/rename variables itself
      color_dark="$color_black"
      color_light="$color_white"
      color_session_text="$color_white"
      color_status_text="colour245"
      color_main="$color_blue"
      color_secondary="$color_blue"
      color_level_ok="$color_green"
      color_level_warn="$color_yellow"
      color_level_stress="$color_red"
      color_window_off_indicator="colour088"
      color_window_off_status_bg="colour238"
      color_window_off_status_current_bg="colour254"

      # status bar
      # Hide status bar on demand
      bind C-s if -F '#{s/off//:status}' 'set status off' 'set status on'
      set -g status on
      set -g status-interval 5
      set -g status-position top
      set -g status-justify left
      set -g status-right-length 100

      set -g mode-style "fg=default,bg=$color_main"

      # command line style
      set -g message-style "fg=$color_white,bg=$color_dark"

      # status line style
      set -g status-style "fg=$color_status_text,bg=$color_dark"

      set -g window-status-separator ""
      separator_powerline_left=""
      separator_powerline_right=""
      setw -g window-status-format " #I:#W "
      setw -g window-status-current-style "fg=$color_white,bold,bg=$color_main"
      setw -g window-status-current-format "#[fg=$color_dark,bg=$color_main]$separator_powerline_right#[default] #I:#W# #[fg=$color_main,bg=$color_dark]$separator_powerline_right#[default]"

      wg_session="#[fg=$color_session_text] #S #[default]"
      wg_is_zoomed="#[fg=$color_blue,bg=$color_dark]#{?window_zoomed_flag,[Z],}#[default]"
      # tmux-mem-cpu-load
      wg_mem_cpu="#[fg=$color_white,bg=$color_black]#(tmux-mem-cpu-load --interval 5)#[default]"
      wg_user_host="#[fg=$color_secondary]#(whoami)#[default]@#H"
      wg_date="#[fg=$color_secondary]%m-%d %H:%M#[default]"
      set -g status-left "$wg_session"
      set -g status-right "$wg_is_zoomed $wg_mem_cpu | $wg_user_host $wg_date"
    '';
    plugins = with pkgs.tmuxPlugins; [
    ];
  };

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };

  home.file = {
    ".local/share/nvim/site/autoload/plug.vim".source = ./vim/plug.vim;

    ".config/nvim/init.vim".source = ./vim/init.vim;
    ".config/nvim/colors/molokai.vim".source = ./vim/molokai.vim;
    ".config/nvim/coc-settings.json".source = ./vim/coc-settings.json;
    ".config/nvim/syntax/ipl.vim".source = ./vim/syntax/ipl.vim;

    ".bashrc".source = ./bash/bashrc;
    ".git-prompt.sh".source = pkgs.fetchurl {
      url = "https://github.com/git/git/raw/094b5409eadd064110f3e74d880fad91e9ca0f0b/contrib/completion/git-prompt.sh";
      sha256 = "XvptvCjYHcDa2YWlhVMhK3oziE3aUAb6uYV0CuJvfl8=";
    };
    ".inputrc".text = ''
      # https://wiki.archlinux.org/index.php/Readline
      set editing-mode vi
      set show-mode-in-prompt on
      set vi-ins-mode-string \1\e[34;1m\2[I]\1\e[0m\2
      set vi-cmd-mode-string \1\e[33;1m\2[N]\1\e[0m\2
    '';

    ".direnvrc".source = ./direnvrc.sh;

    ".bash_profile".text = ''
      # if running bash
      if [ -n "$BASH_VERSION" ]; then
          # include .bashrc if it exists
          if [ -f "$HOME/.bashrc" ]; then
          . "$HOME/.bashrc"
          fi
      fi
      # Set PATH, MANPATH, etc., for Homebrew.
      eval "$(/opt/homebrew/bin/brew shellenv)"
    '';

    ".gitconfig".text = ''
      [filter "strip-notebook-output"]
        clean = "jupyter nbconvert --ClearOutputPreprocessor.enabled=True --to=notebook --stdin --stdout --log-level=ERROR"
    '';
  };
}
