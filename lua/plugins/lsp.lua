return {
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      vim.diagnostic.config({
        virtual_text = {
		current_line = true,
	},
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "󱈸",
            [vim.diagnostic.severity.HINT] = "󰌵 ",
            [vim.diagnostic.severity.INFO] = "i",
          },
        },
        update_in_insert = false,
        underline = true,
        severity_sort = true,
        float = {
          focusable = false,
          style = "minimal",
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
      })

      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })

      vim.lsp.config("*", {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspKeymaps", { clear = true }),
        callback = function(event)
          local function map(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, {
              buffer = event.buf,
              desc = desc,
            })
          end

          map("n", "gd", vim.lsp.buf.definition, "LSP: Go to definition")
          map("n", "gD", vim.lsp.buf.declaration, "LSP: Go to declaration")
          map("n", "K", vim.lsp.buf.hover, "LSP: Hover documentation")
          map("n", "gr", vim.lsp.buf.references, "LSP: List references")
          map("n", "<leader>vws", vim.lsp.buf.workspace_symbol, "LSP: Workspace symbols")
          map("i", "<C-h>", vim.lsp.buf.signature_help, "LSP: Signature help")

          map("n", "<leader>vd", vim.diagnostic.open_float, "Diagnostics: Show details")
          map("n", "[d", function()
            vim.diagnostic.jump({ count = -1 })
          end, "Diagnostics: Previous")
          map("n", "]d", function()
            vim.diagnostic.jump({ count = 1 })
          end, "Diagnostics: Next")

          map("n", "<leader>ca", vim.lsp.buf.code_action, "LSP: Code action")
          map("n", "<leader>rn", vim.lsp.buf.rename, "LSP: Rename symbol")
          map("n", "<leader>cf", function()
            vim.lsp.buf.format({ bufnr = event.buf, async = true })
          end, "LSP: Format buffer")
        end,
      })

      local servers = { "rust_analyzer", "clangd" }

      require("mason-lspconfig").setup({
        ensure_installed = servers,
        automatic_enable = servers,
      })
    end,
  },
}
