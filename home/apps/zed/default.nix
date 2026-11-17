{ pkgs, lib, ... }:
{
  programs.zed-editor = {
    enable = true;

    extensions = [
      "nix"
      "typst"
      "wakatime"
    ];

    userSettings = {
      title_bar.show_sign_in = false;
      edit_predictions.allow_data_collection = "no";

      base_keymap = "VSCode";

      telemetry = {
        diagnostics = false;
        metrics = false;
        anthropic_retention = false;
      };

      vim_mode = true;

      languages.Nix.language_servers = [
        "nixd"
        "!nil"
      ];

      lsp = {
        nixd = {
          binary.path = lib.getExe pkgs.nixd;
          settings.formatting.command = [ (lib.getExe pkgs.nixfmt) ];
        };

        clangd.binary = {
          path = lib.getExe' pkgs.clang-tools "clangd";
          # Pick up headers from whatever compiler we have, see nvf/default.nix
          arguments = [ "--query-driver=**" ];
        };

        gopls.binary.path = lib.getExe pkgs.gopls;

        rust-analyzer.binary.path = lib.getExe pkgs.rust-analyzer;

        tinymist = {
          binary.path = lib.getExe pkgs.tinymist;
          settings = {
            formatterMode = "typstyle";
            exportPdf = "onSave";
          };
        };

        bash-language-server.binary = {
          # The nixpkgs wrapper already has shellcheck in PATH
          path = lib.getExe pkgs.bash-language-server;
          # An explicit path drops the adapter's default arguments
          arguments = [ "start" ];
        };
      };
    };
  };
}
