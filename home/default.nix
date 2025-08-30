{ pkgs, config, ... }:
{
  programs.home-manager.enable = true;

  imports = [
    ./nixvim

    ./starship

    ./apps
  ];

  home = {
    username = "poli";
    homeDirectory = "/home/poli";

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };

  home.packages = with pkgs; [
    # utils
    libqalculate
    jq
    ripgrep
    pdfgrep
    file
    xdg-utils
    wl-clipboard

    # dev
    gcc
    gnumake
    cargo
    rustc
    (python3.withPackages (
      ps: with ps; [
        ipython
      ]
    ))
    valgrind
    gdb
    strace

    # ctf
    nmap
    netcat-gnu
    (rizin.withPlugins (
      ps: with ps; [
        rz-ghidra
        sigdb
      ]
    ))
  ];

  # nicely reload system units when changing configs
  # and also set global session variables in a way
  # that they will also be available to user services and all started programs,
  # not just those that was started via shell
  systemd.user = {
    startServices = "sd-switch";
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  services.ssh-agent.enable = true;

  programs.git = {
    enable = true;
    userName = "Polina Vishneva";
    userEmail = "poli@0iq.dev";
    extraConfig = {
      rebase = {
        autosquash = true;
      };
      sendemail = {
        smtpserver = "0iq.dev";
        smtpuser = "poli@0iq.dev";
        smtpencryption = "tls";
        smtpserverport = 587;
      };

      # Unbreak mouse scrolling
      core.pager = "less -+X";
    };
  };

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
    };
  };

  programs.tmux = {
    enable = true;

    mouse = true;
    keyMode = "vi";
    baseIndex = 1;
    clock24 = true;
    escapeTime = 1;
    historyLimit = 20000;
    terminal = "tmux-256color";

    extraConfig = ''
      set -g repeat-time 0

      bind -r h select-pane -L
      bind -r j select-pane -D
      bind -r k select-pane -U
      bind -r l select-pane -R

      bind -r H resize-pane -L 2
      bind -r J resize-pane -D 2
      bind -r K resize-pane -U 2
      bind -r L resize-pane -R 2

      bind Tab last-window
    '';
  };

  programs.htop = {
    enable = true;
    settings =
      {
        color_scheme = 0;
        cpu_count_from_one = 0;
        delay = 15;

        highlight_base_name = 1;
        highlight_megabytes = 1;
        highlight_threads = 1;

        show_cpu_frequency = 1;
        show_cpu_temperature = 1;
      }
      // (
        with config.lib.htop;
        leftMeters [
          (bar "AllCPUs2")
        ]
      )
      // (
        with config.lib.htop;
        rightMeters [
          (bar "Memory")
          (bar "Swap")
          (text "Tasks")
          (text "LoadAverage")
          (text "Uptime")
          (text "Systemd")
          (text "DiskIO")
          (text "NetworkIO")
        ]
      );
  };

  home.stateVersion = "23.05";

  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      set fish_cursor_default block
      set fish_cursor_insert line
      set fish_cursor_replace_one underscore
      set fish_cursor_visual block

      # Disable greeting
      set fish_greeting
    '';

    functions = {
      # Render the short version of the prompt
      # TODO: maybe show the command status (would have to use a postexec hook)
      starship_transient_prompt_func = ''
        starship module character
      '';
    };
  };

  programs.rbw = {
    enable = true;
    settings = {
      email = "poli0iq@disroot.org";
      pinentry = pkgs.pinentry.gnome3;
    };
  };

  # E.g. for "command not found"
  programs.nix-index.enable = true;

  programs.fastfetch = {
    enable = true;

    settings = {
      logo = {
        source = "nixos_old_small";
        padding = {
          top = 1;
          left = 2;
        };
      };

      display = {
        separator = "";
        key.width = 10;
      };

      modules = [
        "title"
        "break"
        {
          type = "os";
          key = "os";
          format = "{3}";
        }
        {
          type = "host";
          key = "host";
        }
        {
          type = "kernel";
          key = "kernel";
        }
        {
          type = "uptime";
          key = "uptime";
        }
        {
          type = "packages";
          key = "pkgs";
        }
        {
          type = "shell";
          key = "shell";
        }
        {
          type = "display";
          key = "video";
        }
        {
          type = "de";
          key = "de";
        }
        {
          type = "wm";
          key = "wm";
          format = "{1}";
        }
        {
          type = "terminal";
          key = "term";
        }
        "break"
        {
          type = "cpu";
          key = "cpu";
          format = "{1}";
        }
        {
          type = "gpu";
          key = "gpu";
          format = "{2}";
        }
        {
          type = "memory";
          key = "memory";
          format = "{1} / {2}";
        }
        {
          type = "disk";
          key = "disk";
          format = "{1} / {2} ({9})";
        }
        {
          type = "battery";
          key = "bat";
        }
        {
          type = "poweradapter";
          key = "pwr";
        }
      ];
    };
  };
}
