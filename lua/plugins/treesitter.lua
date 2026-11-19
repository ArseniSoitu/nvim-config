return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local ts = require("nvim-treesitter")

      ts.install({ "lua", "vim", "vimdoc", "python", "rust", "cpp", "c" })

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true }),
        pattern = { "lua", "vim", "help", "python", "rust", "cpp", "c" },
        callback = function(event)
          -- On first startup, the parser may still be installing.
          local ok = pcall(vim.treesitter.start, event.buf)
          if ok then
            vim.bo[event.buf].indentexpr =
              "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
}
