{ pkgs, lib, ... }:

{
  programs.nvf = {
    enable = true;
    enableManpages = true;

    settings.vim = {
      options = {
        number = true;
        relativenumber = true;
        incsearch = true;
        scrolloff = 3;
        textwidth = 100;
        cursorline = true;
        cursorcolumn = true;
        title = true;
        termguicolors = true;
        showmode = false;
      };

      lsp = {
        enable = true;
        formatOnSave = true;
        lightbulb.enable = true;
        trouble.enable = true;
        lspSignature.enable = true;

        servers = {
          # nvf sets it up only for conform-nvim which lacks a keybind
          nixd.settings.nixd.formatting.command = [ (lib.getExe pkgs.nixfmt) ];

          tinymist.settings = {
            formatterMode = "typstyle";
            exportPdf = "onSave";
          };
        };
      };

      languages = {
        enableTreesitter = true;
        enableFormat = true;
        enableExtraDiagnostics = true;

        nix = {
          enable = true;
          lsp.servers = [ "nixd" ];
          format.type = [ "nixfmt" ];
        };

        clang.enable = true;
        go.enable = true;
        rust.enable = true;
        python.enable = true;
        haskell.enable = true;
        typst.enable = true;
      };

      visuals = {
        nvim-cursorline.enable = true;

        fidget-nvim = {
          enable = true;
          # Conflicts with backgroud transparency
          setupOpts.notification.window.winblend = 0;
        };

        highlight-undo.enable = true;
        indent-blankline.enable = true;
      };

      statusline.lualine.enable = true;

      theme.enable = false;

      autopairs.nvim-autopairs.enable = true;

      autocomplete.nvim-cmp.enable = true;

      snippets.luasnip.enable = true;

      #tabline.nvimBufferline.enable = true;

      treesitter.context.enable = true;

      binds = {
        whichKey.enable = true;
        cheatsheet.enable = true;
      };

      git = {
        enable = true;
        gitsigns.enable = true;
        # Throws an annoying debug message
        gitsigns.codeActions.enable = false;
      };

      notify.nvim-notify.enable = true;

      ui = {
        borders.enable = true;
        noice = {
          enable = true;
          # Conflicts with fidget-nvim
          setupOpts.lsp.progress.enabled = false;
        };
        colorizer.enable = true;
        modes-nvim.enable = true;
        illuminate.enable = true;
        smartcolumn.enable = true;
        fastaction.enable = true;
      };

      comments.comment-nvim.enable = true;

      startPlugins = with pkgs.vimPlugins; [
        adwaita-nvim
        vim-nix
      ];

      luaConfigRC.adwaita = ''
        vim.g.adwaita_transparent = true
        vim.cmd.colorscheme("adwaita")
      '';
    };
  };
}
