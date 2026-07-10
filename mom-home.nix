{
  config,
  pkgs,
  pkgs-stable,
  lib,
  ...
}:

let
  username = "uynx"; # <-- CHANGE THIS to your macOS username
  gitName = "Brandon Alexander"; # <-- CHANGE THIS to your Git name
  gitEmail = "brandonwalex@pm.me"; # <-- CHANGE THIS to your Git email
  gitKey = "~/.ssh/id_ed25519.pub"; # <-- SSH public key used for git auth and commit signing (git key)
in
{
  imports = [ ];

  home = {
    username = username;
    homeDirectory = "/Users/${username}";
    stateVersion = "26.05";
    sessionVariables = {
      EDITOR = "micro";
      VISUAL = "micro";
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
    micro



    (neovim.override {
      withPerl = true;
      withNodeJs = true;
      withPython3 = true;
      withRuby = true;
    })

    tree-sitter
    nodejs
    (python3.withPackages (
      ps: with ps; [
        pip
        setuptools
      ]
    ))
    uv
    ast-grep

    nil
    nixfmt
    statix

    proton-pass
    qbittorrent
    whatsapp-for-mac

    tmux
    tmuxPlugins.sensible
    tmuxPlugins.vim-tmux-navigator
    tmuxPlugins.resurrect
    tmuxPlugins.continuum
  ];

  home.file = {
    ".config/nvim".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nvim";
    ".local/share/nvim/site/parser/norg.so".source =
      "${pkgs.tree-sitter-grammars.tree-sitter-norg}/parser";

    ".config/ghostty/config".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/ghostty_config";

    ".config/tmux".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/tmux";

    ".agents/skills".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/skills";

    ".agents/AGENTS.md".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/AGENTS.md";

    ".gemini/antigravity-cli/settings.json" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/antigravity-cli-settings.json";
      force = true;
    };
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

    fastfetch.enable = true;
    bun.enable = true;
    lazydocker.enable = true;
    java.enable = true;
    cargo.enable = true;



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
        set -g fish_greeting "Welcome! To update system packages, run:
  1. 'update' (fetches latest packages)
  2. 'reb'    (applies configurations and rebuilds system)"
      '';

      functions = {
        reb = {
          body = ''
            set -l target "mom"
            if test (count $argv) -gt 0
                set target $argv[1]
            end
            sudo darwin-rebuild switch --flake ~/nix-config#$target
          '';
        };
      };

      shellAliases = {
        update = "nix flake update --flake ~/nix-config";
        unb = "xattr -d com.apple.quarantine";

        word = "open -a LibreOffice --args --writer";
        powerpoint = "open -a LibreOffice --args --impress";

        gen = "nix-env --list-generations";

        wt = "git worktree list";
        wta = "git worktree add";
        wtr = "git worktree remove";

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
        command_timeout = 3000;
      };
    };

    fzf = {
      enable = true;
      enableFishIntegration = true;
      changeDirWidget.command = "fd --type d --hidden --strip-cwd-prefix --exclude .git";
      historyWidget.command = "";
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
          name = gitName;
          email = gitEmail;
          signingkey = gitKey;
        };
        init.defaultBranch = "main";
        pull.rebase = true;
        push.autoSetupRemote = true;
        core = {
          editor = "micro";
          fsmonitor = true;
          untrackedCache = true;
        };
        gpg.format = "ssh";
        commit.gpgsign = false;
        tag.gpgsign = false;
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
        printf '{\n  "github.com": {\n    "oauth_token": "%s"\n  }\n}\n' "$TOKEN" > "$HOSTS_JSON"
        chmod 600 "$HOSTS_JSON"
      fi
    fi
  '';

  home.activation.createAiBrainDirs = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "$HOME/ai_memory/concepts"
    mkdir -p "$HOME/ai_memory/journal"
  '';
}
