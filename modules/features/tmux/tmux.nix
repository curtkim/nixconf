{
  wrappers.tmux = {
    wlib,
    pkgs,
    config,
    ...
  }: {
    imports = [wlib.wrapperModules.tmux];

    sourceSensible = false;
    secureSocket = true;

    # The login shell rather than pkgs.vj.environment: that package carries
    # this tmux, so pointing back at it would be a dependency cycle. Naming it
    # also keeps panes on fish inside `nix develop`, which rewrites $SHELL.
    #shell = "/run/current-system/sw/bin/fish";

    terminal = "screen-256color";

    prefix = "C-u";
    baseIndex = 1;
    paneBaseIndex = 1;
    escapeTime = 0;
    mouse = true;
    historyLimit = 5000;

    statusKeys = "vi";
    modeKeys = "vi";

    clock24 = false;
    disableConfirmationPrompt = false;

    allowPassthrough = true;
    visualActivity = false;
    vimVisualKeys = true;

    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator
      yank
      resurrect # prefix + Ctrl+s, prefix + Ctrl+r
    ];

    configAfter = ''
      set -ga terminal-features "*:RGB"

      bind -n C-] copy-mode

      bind "|" split-window -h -c "#{pane_current_path}"
      bind "\\" split-window -fh -c "#{pane_current_path}"
      bind "-" split-window -v -c "#{pane_current_path}"
      bind "_" split-window -fv -c "#{pane_current_path}"

      bind -r "<" swap-window -d -t -1
      bind -r ">" swap-window -d -t +1

      bind -r C-j resize-pane -D 10
      bind -r C-k resize-pane -U 10
      bind -r C-h resize-pane -L 10
      bind -r C-l resize-pane -R 10

      bind -T copy-mode-vi 'C-v' send-keys -X rectangle-toggle \; send-keys -X begin-selection

      bind r source-file ${config.constructFiles.generatedConfig.path} \; display "Reloaded!"

      set-option -g status-position top
      set-window-option -g window-status-current-style bg=#00FF00

      set -g status-left-length 85
      set -g status-left "[#S]  "
      set -g status-right "#{?window_bigger,[#{window_offset_x}#,#{window_offset_y}] ,}\"#{=21:pane_title}\" %H:%M %Y-%m-%d"
      set -g status-justify left
    '';
  };
}
