{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  # Overlay so our allowUnfree applies.
  nixpkgs.overlays = [ inputs.nix-vscode-extensions.overlays.default ];

  programs.vscode = {
    enable = true;
    mutableExtensionsDir = true;
    argvSettings.enable-crash-reporter = false;

    profiles.default = {
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = true;

      extensions = with pkgs.vscode-marketplace; [
        vscodevim.vim
        piousdeer.adwaita-theme

        jnoortheen.nix-ide
        llvm-vs-code-extensions.vscode-clangd
        rust-lang.rust-analyzer
        myriad-dreamin.tinymist
        mads-hartmann.bash-ide-vscode
        dbaeumer.vscode-eslint

        wakatime.vscode-wakatime

        mkhl.direnv
        datakurre.devenv
      ];

      # Ctrl+0 focuses the primary side bar, ctrl+alt+b toggles the secondary one
      keybindings = [
        {
          key = "ctrl+alt+0";
          command = "workbench.action.focusAuxiliaryBar";
        }
      ];

      userSettings = {
        "extensions.autoCheckUpdates" = true;
        "extensions.autoUpdate" = "on";

        "telemetry.telemetryLevel" = "off";
        "telemetry.feedback.enabled" = false;
        "workbench.enableExperiments" = false;
        "chat.disableAIFeatures" = true;

        # UI settings
        # 1.2^zoom = 11pt * (96/72) / 13px: match GNOME at an integer font size.
        "window.zoomLevel" = 0.661622190539646;
        "window.titleBarStyle" = "custom";
        "window.menuBarVisibility" = "compact";
        "window.commandCenter" = true;
        "window.autoDetectColorScheme" = true;
        "workbench.preferredDarkColorTheme" = "Adwaita Dark";
        "workbench.preferredLightColorTheme" = "Adwaita Light";
        "workbench.productIconTheme" = "adwaita";
        "workbench.iconTheme" = null;
        "workbench.tree.indent" = 12;

        # Mimic Adwaita
        "editor.fontFamily" = "'Adwaita Mono', monospace";
        "editor.fontSize" = 13;
        "terminal.integrated.fontFamily" = "'Adwaita Mono'";
        "terminal.integrated.fontSize" = 13;
        "markdown.preview.fontFamily" = "'Adwaita Sans', sans-serif";
        "markdown.preview.fontSize" = 16;

        "editor.inertialScroll" = true;
        "editor.lineNumbers" = "relative";
        "editor.cursorSurroundingLines" = 3;
        "editor.rulers" = [ 100 ];
        "editor.renderLineHighlight" = "all";
        "editor.formatOnSave" = false;

        "git.blame.editorDecoration.enabled" = true;

        # Close the tab instead of vim's window-command prefix
        "vim.normalModeKeyBindingsNonRecursive" = [
          {
            before = [ "<C-w>" ];
            commands = [ "workbench.action.closeActiveEditor" ];
          }
        ];

        "nix.enableLanguageServer" = true;
        "nix.serverPath" = lib.getExe pkgs.nixd;
        "nix.formatterPath" = lib.getExe pkgs.nixfmt;
        "nix.serverSettings".nixd.formatting.command = [ (lib.getExe pkgs.nixfmt) ];

        "clangd.path" = lib.getExe' pkgs.clang-tools "clangd";
        # Pick up headers from whatever compiler we have, see nvf/default.nix
        "clangd.arguments" = [ "--query-driver=**" ];

        "go.toolsManagement.autoUpdate" = false;
        "go.alternateTools" = {
          gopls = lib.getExe pkgs.gopls;
          dlv = lib.getExe pkgs.delve;
        };

        "rust-analyzer.server.path" = lib.getExe pkgs.rust-analyzer;

        # basedpyright provides the LSP, ms-python only handles run/debug
        "python.languageServer" = "None";

        "tinymist.serverPath" = lib.getExe pkgs.tinymist;
        "tinymist.formatterMode" = "typstyle";
        "tinymist.exportPdf" = "onSave";

        "bashIde.shellcheckPath" = lib.getExe pkgs.shellcheck;
      };
    };
  };
}
