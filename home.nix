{
  config,
  pkgs,
  pkgs-stable,
  inputs,
  lib,
  ...
}:

{
  imports = [
    inputs.nix-index-database.homeModules.nix-index
  ];

  home = {
    username = "uynx";
    homeDirectory = "/Users/uynx";
    stateVersion = "26.05";
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };

  targets.darwin.copyApps.enable = false;
  targets.darwin.linkApps.enable = true;

  home.packages = with pkgs; [
    coreutils
    wget
    dust
    duf
    procs
    sd
    gping
    doggo
    obsidian
    tokei
    hyperfine
    bandwhich

    (neovim.override {
      withPerl = true;
      withNodeJs = true;
      withPython3 = true;
      withRuby = true;
    })

    tree-sitter
    rustc
    nodejs
    (python3.withPackages (
      ps: with ps; [
        pip
        setuptools
      ]
    ))
    clang
    ast-grep
    lua5_1
    luarocks
    julia-bin
    php
    php.packages.composer
    ruby
    uv

    imagemagick
    ghostscript
    mermaid-cli

    nil
    nixfmt
    statix

    (pkgs-stable.texlive.combine {
      inherit (pkgs-stable.texlive)
        scheme-full
        biber
        ;
    })

    melonds
    proton-pass
    qbittorrent
    wireshark

    lima
    devpod
    dive

    swi-prolog
  ];

  home.file = {
    ".config/nvim".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/dotfiles/nvim";
    ".local/share/nvim/site/parser/norg.so".source =
      "${pkgs.tree-sitter-grammars.tree-sitter-norg}/parser";

    ".config/ghostty/config".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/dotfiles/ghostty_config";

    ".aerospace.toml".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/dotfiles/aerospace.toml";
  };

  services.colima = {
    enable = true;
    bashPackage = pkgs.bash;
    dockerPackage = pkgs.docker;
  };

  programs = {
    gh = {
      enable = true;
      settings = {
        git_protocol = "ssh";
        editor = "nvim";
      };
    };

    ghostty = {
      enable = true;
      package = pkgs.ghostty-bin;
    };

    antigravity-cli.enable = true;

    fastfetch.enable = true;
    bun.enable = true;
    lazydocker.enable = true;
    java.enable = true;
    cargo.enable = true;

    aerospace = {
      enable = true;
      package = pkgs.aerospace;
      launchd = {
        enable = true;
        keepAlive = true;
      };
    };

    vscodium = {
      enable = true;
      package = pkgs.vscodium;
    };

    discord = {
      enable = true;
    };

    man = {
      enable = true;
      generateCaches = true;
      package = pkgs-stable.man;
    };

    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };

    yazi = {
      enable = true;
      enableFishIntegration = true;
      shellWrapperName = "y";
      settings = {
        manager = {
          show_hidden = true;
          sort_by = "modified";
          sort_dir_first = true;
        };
      };
    };

    bat = {
      enable = true;
    };

    eza = {
      enable = true;
      enableFishIntegration = true;
      icons = "auto";
      git = true;
      extraOptions = [
        "--group-directories-first"
        "--header"
      ];
    };

    btop.enable = true;

    fd = {
      enable = true;
      hidden = true;
    };

    tealdeer = {
      enable = true;
      settings.updates.auto_update = true;
    };

    atuin = {
      enable = true;
      enableFishIntegration = true;
    };

    fish = {
      enable = true;

      interactiveShellInit = ''
        fish_add_path /opt/homebrew/bin
        set -g fish_greeting ""
        fish_vi_key_bindings
      '';

      shellAliases = {
        update = "nix flake update --flake ~/nix-config";
        reb = "sudo darwin-rebuild switch --flake ~/nix-config#macos";
        unb = "xattr -d com.apple.quarantine";

        word = "open -a LibreOffice --args --writer";
        powerpoint = "open -a LibreOffice --args --impress";

        gen = "nix-env --list-generations";

        wt = "git worktree list";
        wta = "git worktree add";
        wtr = "git worktree remove";

        cat = "bat";
        grep = "rg";
        find = "fd";
        sed = "sd";
        ping = "gping";
        top = "btop";
        htop = "btop";
        dig = "doggo";
        du = "dust";
        df = "duf";
        ps = "procs";
        cd = "z";
        zi = "z -i";
        vi = "nvim";
        vim = "nvim";
        tree = "eza --tree --icons";
        ll = "eza -la --icons --group-directories-first --header --git-ignore";
      };

      plugins = [
        {
          name = "sudope";
          src = pkgs.fishPlugins.plugin-sudope;
        }
      ];
    };

    starship = {
      enable = true;
      enableFishIntegration = true;
      settings = {
        add_newline = false;
        command_timeout = 1000;
      };
    };

    fzf = {
      enable = true;
      enableFishIntegration = true;
      changeDirWidgetCommand = "fd --type d --hidden --strip-cwd-prefix --exclude .git";
    };

    ripgrep = {
      enable = true;
      arguments = [
        "--max-columns=150"
        "--max-columns-preview"
        "--hidden"
        "--glob=!.git/*"
        "--smart-case"
      ];
    };

    lazygit = {
      enable = true;
      settings = {
        gui.showIcons = true;
        git.paging = {
          colorArg = "always";
          pager = "bat --style=plain";
        };
      };
    };

    chromium = {
      enable = true;
      package = pkgs.brave;
    };

    jq.enable = true;
    go.enable = true;
    sioyek.enable = true;
    nix-index.enable = true;
    nix-index-database.comma.enable = true;

    direnv = {
      enable = true;
      package = pkgs.direnv.overrideAttrs (_: {
        doCheck = false;
      });
      nix-direnv.enable = true;
      enableFishIntegration = true;
    };

    tmux = {
      enable = true;
      clock24 = true;
      keyMode = "vi";
      prefix = "C-a";
      mouse = true;
      plugins = with pkgs; [
        tmuxPlugins.sensible
        tmuxPlugins.vim-tmux-navigator
        {
          plugin = tmuxPlugins.resurrect;
          extraConfig = "set -g @resurrect-strategy-nvim 'session'";
        }
        {
          plugin = tmuxPlugins.continuum;
          extraConfig = ''
            set -g @continuum-restore 'on'
            set -g @continuum-save-interval '10'
          '';
        }
      ];
      extraConfig = ''
        # True color and undercurl support for Ghostty
        set -g default-terminal "xterm-256color"
        set -ag terminal-overrides ",xterm-256color:RGB"
        set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'
        set -as terminal-overrides ',*:Setcx=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'

        # Keyboard repeat rate safety
        set -s escape-time 0

        # Start window numbering at 1
        set -g base-index 1
        setw -g pane-base-index 1
        set -g renumber-windows on

        # pbcopy integration for macOS
        bind-key -T copy-mode-vi v send-keys -X begin-selection
        bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "pbcopy"
        bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "pbcopy"

        # Flexoki Dark Aesthetic Status Line
        set -g status-style "bg=#100f0f,fg=#cecdc3"
        set -g status-left "#[fg=#205ea6,bold] #S #[fg=#343331]| "
        set -g status-left-length 20
        set -g status-right "#[fg=#878580]%Y-%m-%d #[fg=#66800d,bold]%H:%M "
        set -g status-right-length 50
        set -g window-status-format "#[fg=#878580] #I: #W "
        set -g window-status-current-format "#[fg=#bc5215,bold,bg=#282726] #I: #W* "
        set -g pane-border-style "fg=#282726"
        set -g pane-active-border-style "fg=#205ea6"
      '';
    };

    delta = {
      enable = true;
      enableGitIntegration = true;
      options = {
        navigate = true;
        side-by-side = true;
        line-numbers = true;
        theme = "Nord";
      };
    };

    git = {
      enable = true;
      settings = {
        user = {
          name = "Brandon Alexander";
          email = "brandonwalex@pm.me";
          signingkey = "~/.ssh/id_ed25519.pub";
        };
        init.defaultBranch = "main";
        pull.rebase = true;
        push.autoSetupRemote = true;
        core.editor = "nvim";
        core.fsmonitor = true;
        core.untrackedCache = true;
        gpg.format = "ssh";
        commit.gpgsign = true;
        tag.gpgsign = true;
        merge.conflictstyle = "zdiff3";
        rerere.enabled = true;
      };
    };
  };

  home.activation.copilotBridge = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    AUTH_DB="$HOME/.config/github-copilot/auth.db"
    HOSTS_JSON="$HOME/.config/github-copilot/hosts.json"
    if [ -f "$AUTH_DB" ]; then
      TOKEN=$(${pkgs.sqlite}/bin/sqlite3 "$AUTH_DB" "SELECT cast(token_ciphertext as text) FROM oauth_tokens LIMIT 1;" 2>/dev/null)
      if [ -n "$TOKEN" ]; then
        mkdir -p "$(dirname "$HOSTS_JSON")"
        cat > "$HOSTS_JSON" <<EOF
{
  "github.com": {
    "oauth_token": "$TOKEN"
  }
}
EOF
        chmod 600 "$HOSTS_JSON"
      fi
    fi
  '';
}
