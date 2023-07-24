return {
  "b0o/SchemaStore.nvim",
  {
    "folke/neodev.nvim",
    opts = {
      override = function(root_dir, library)
        for _, astronvim_config in ipairs(astronvim.supported_configs) do
          if root_dir:match(astronvim_config) then
            library.plugins = true
            break
          end
        end
        vim.b.neodev_enabled = library.enabled
      end,
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "williamboman/mason-lspconfig.nvim",
        cmd = { "LspInstall", "LspUninstall" },
        opts = function(_, opts)
          if not opts.handlers then opts.handlers = {} end
          opts.handlers[1] = function(server) require("astronvim.utils.lsp").setup(server) end
          -- opts.handlers[2] = function(server) require('sonarlint').setup({
          --   server = {
          --     cmd = {
          --       'sonarlint-language-server',
          --       -- Ensure that sonarlint-language-server uses stdio channel
          --       '-stdio',
          --       '-analyzers',
          --       -- paths to the analyzers you need, using those for python and java in this example
          --       vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarpython.jar"),
          --       vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarcfamily.jar"),
          --       vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarjava.jar"),
          --     }
          --   },
          --   filetypes = {
          --     -- Tested and working
          --     'python',
          --     'cpp',
          --     -- Requires nvim-jdtls, otherwise an error message will be printed
          --     'java',
          --   }
          -- })
        end,
        config = require "plugins.configs.mason-lspconfig",
      },
    },
    event = "User AstroFile",
    config = require "plugins.configs.lspconfig",
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = {
      {
        "jay-babu/mason-null-ls.nvim",
        cmd = { "NullLsInstall", "NullLsUninstall" },
        opts = { handlers = {} },
      },
    },
    event = "User AstroFile",
    opts = function() return { on_attach = require("astronvim.utils.lsp").on_attach } end,
  },
  {
    "stevearc/aerial.nvim",
    event = "User AstroFile",
    opts = {
      attach_mode = "global",
      backends = { "lsp", "treesitter", "markdown", "man" },
      layout = { min_width = 28 },
      show_guides = true,
      filter_kind = false,
      guides = {
        mid_item = "├ ",
        last_item = "└ ",
        nested_top = "│ ",
        whitespace = "  ",
      },
      keymaps = {
        ["[y"] = "actions.prev",
        ["]y"] = "actions.next",
        ["[Y"] = "actions.prev_up",
        ["]Y"] = "actions.next_up",
        ["{"] = false,
        ["}"] = false,
        ["[["] = false,
        ["]]"] = false,
      },
    },
  },
}
