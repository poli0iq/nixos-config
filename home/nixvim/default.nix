{ pkgs, ... }:
{
  programs.nixvim = {
    enable = true;

    colorschemes.gruvbox = {
      enable = true;
      settings = {
        transparent_mode = true;
      };
    };

    #highlight = { Normal.bg = "none"; };

    opts = {
      number = true;
      relativenumber = true;
      incsearch = true;
      scrolloff = 3;
      textwidth = 100;
      cursorline = true;
      cursorcolumn = true;
      title = true;
      termguicolors = true;
      #background = "dark";
      showmode = false;
    };

    plugins = {
      nix.enable = true;

      typst-vim.enable = true;

      lualine = {
        enable = true;
        settings.options.icons_enabled = false;
      };

      lsp = {
        enable = true;

        servers = {
          clangd.enable = true;
          gopls.enable = true;

          hls = {
            enable = true;
            installGhc = false;
          };

          rust_analyzer = {
            enable = true;
            installCargo = false;
            installRustc = false;
          };

          pylsp = {
            enable = true;
            settings.plugins = {
              pylint.enabled = true;
              pycodestyle.enabled = true;
              yapf.enabled = true;
            };
          };

          nixd = {
            enable = true;
            settings = {
              formatting.command = [ "${pkgs.nixfmt-rfc-style}/bin/nixfmt" ];
            };
          };

          #texlab = {
          #  enable = true;
          #  extraOptions.settings = {
          #    texlab = {
          #      build = {
          #        onSave = true;
          #        forwardSearchAfter = true;
          #        #args = [ "-xelatex" ];
          #      };
          #      chktex = {
          #        onOpenAndSave = true;
          #      };
          #    };
          #  };
          #};

          tinymist = {
            enable = true;
            settings = {
              formatterMode = "typstyle";
              exportPdf = "onSave";
            };
          };
        };

        keymaps = {
          diagnostic = {
            # Mapped by default to "<C-W>d" in 0.10+, but that one is more convenient
            "<space>e" = "open_float";
            # Added by default in Nvim 0.10
            #"[d" = "goto_prev";
            #"]d" = "goto_next";
            "<space>q" = "setloclist";
          };

          lspBuf = {
            # Added by default in Nvim 0.10
            #K = "hover";
            gD = "declaration";
            gd = "definition";
            gi = "implementation";
            gr = "references";
            "<C-k>" = "signature_help";
            "<space>wa" = "add_workspace_folder";
            "<space>wr" = "remove_workspace_folder";
            #"<space>wl" = ''
            #  function()
            #    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            #  end;
            #'';
            "<space>D" = "type_definition";
            "<space>rn" = "rename";
            "<space>ca" = "code_action";
            "<space>f" = "format";
          };
        };
      };

      cmp = {
        enable = true;

        settings = {
          snippet.expand = "function(args) require'luasnip'.lsp_expand(args.body) end";

          sources = [
            { name = "nvim_lsp"; }
            { name = "path"; }
            { name = "luasnip"; }
            { name = "buffer"; }
            { name = "treesitter"; }
          ];

          mapping = {
            "<CR>" = "cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Replace }";
            "<Tab>" = ''
              cmp.mapping(
                function(fallback)
                  if cmp.visible() then
                    cmp.select_next_item()
                  elseif require'luasnip'.expand_or_jumpable() then
                    require'luasnip'.expand_or_jump()
                  else
                    fallback()
                  end
                end,
                {'i', 's'}
              )
            '';
            "<S-Tab>" = ''
              cmp.mapping(
                function(fallback)
                  if cmp.visible() then
                    cmp.select_prev_item()
                  elseif require'luasnip'.jumpable(-1) then
                    require'luasnip'.jump(-1)
                  else
                    fallback()
                  end
                end,
                {'i', 's'}
              )
            '';
            "<C-e>" = "cmp.mapping.abort()";
            "<C-Space>" = "cmp.mapping.complete";
            "<C-d>" = "cmp.mapping.scroll_docs(-4)";
            "<C-f" = "cmp.mapping.scroll_docs(4)";
          };
        };
      };

      luasnip.enable = true;
      treesitter.enable = true;
      gitsigns.enable = true;
      nvim-autopairs.enable = true;
      illuminate.enable = true;
    };
  };
}
