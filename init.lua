--------------------------
-- Load Astrovim and setup
--------------------------
for _, source in ipairs {
  "astronvim.bootstrap",
  "astronvim.options",
  "astronvim.lazy",
  "astronvim.autocmds",
  "astronvim.mappings",
} do
  local status_ok, fault = pcall(require, source)
  if not status_ok then vim.api.nvim_err_writeln("Failed to load " .. source .. "\n\n" .. fault) end
end

if astronvim.default_colorscheme then
  if not pcall(vim.cmd.colorscheme, astronvim.default_colorscheme) then
    require("astronvim.utils").notify(
      "Error setting up colorscheme: " .. astronvim.default_colorscheme,
      vim.log.levels.ERROR
    )
  end
end

-- -------------------------
-- nightfox colorscheme setup
-- -------------------------
require('nightfox').setup({
  options = {
    -- Compiled file's destination location
    compile_path = vim.fn.stdpath("cache") .. "/duskfox",
    compile_file_suffix = "_compiled", -- Compiled file suffix
    transparent = true,                -- Disable setting background
    terminal_colors = false,           -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
    dim_inactive = false,              -- Non focused panes set to alternative background
    module_default = true,             -- Default enable value for modules
    colorblind = {
      enable = false,                  -- Enable colorblind support
      simulate_only = false,           -- Only show simulated colorblind colors and not diff shifted
      severity = {
        protan = 0,                    -- Severity [0,1] for protan (red)
        deutan = 0,                    -- Severity [0,1] for deutan (green)
        tritan = 0,                    -- Severity [0,1] for tritan (blue)
      },
    },
    styles = {
      -- Style to be applied to different syntax groups
      comments = "NONE", -- Value is any valid attr-list value `:help attr-list`
      conditionals = "NONE",
      constants = "NONE",
      functions = "NONE",
      keywords = "NONE",
      numbers = "NONE",
      operators = "NONE",
      strings = "NONE",
      types = "NONE",
      variables = "NONE",
    },
    inverse = {
      -- Inverse highlight for different types
      match_paren = false,
      visual = false,
      search = false,
    },
    modules = { -- List of various plugins and additional options
      -- ...
    },
  },
  palettes = {},
  specs = {},
  groups = {},
})

---------------------------
-- Nordic colorscheme setup
---------------------------
require 'nordic'.setup {
  -- Available themes: 'nordic', 'onedark'.
  -- Onedark is WIP.
  theme = 'nordic',
  -- Enable bold keywords.
  bold_keywords = false,
  -- Enable italic comments.
  italic_comments = true,
  -- Enable general editor background transparency.
  transparent_bg = true,
  -- Enable brighter float border.
  bright_border = true,
  -- Nordic specific options.
  -- Set all to false to use original Nord colors.
  -- Adjusts some colors to make the theme a bit nicer (imo).
  nordic = {
    -- Reduce the overall amount of blue in the theme (diverges from base Nord).
    reduced_blue = false,
  },
  -- Onedark specific options.
  -- Set all to false to keep original onedark colors.
  -- Adjusts some colors to make the theme a bit nicer (imo).
  -- WIP.
  onedark = {
    -- Brighten the whites to fit the theme better.
    brighter_whites = true,
  },
  -- Override the styling of any highlight group.
  override = {},
  cursorline = {
    -- Enable bold font in cursorline.
    bold = false,
    -- Avialable styles: 'dark', 'light'.
    theme = 'light',
    -- Hide the cursorline when the window is not focused.
    hide_unfocused = true,
  },
  noice = {
    -- Available styles: `classic`, `flat`.
    style = 'classic',
  },
  telescope = {
    -- Available styles: `classic`, `flat`.
    style = 'classic',
  },
  leap = {
    -- Dims the backdrop when using leap.
    dim_backdrop = false,
  },
}

require("astronvim.utils").conditional_func(astronvim.user_opts("polish", nil, false), true)

-----------------------------
-- Null-ls setup
-----------------------------
local null_ls = require("null-ls")

local group = vim.api.nvim_create_augroup("lsp_format_on_save", { clear = false })
local event = "BufWritePre" -- or "BufWritePost"
local async = event == "BufWritePost"

null_ls.setup({
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.keymap.set("n", "<Leader>f", function()
        vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
      end, { buffer = bufnr, desc = "[lsp] format" })

      -- format on save
      vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })
      vim.api.nvim_create_autocmd(event, {
        buffer = bufnr,
        group = group,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr, async = async })
        end,
        desc = "[lsp] format on save",
      })
    end

    if client.supports_method("textDocument/rangeFormatting") then
      vim.keymap.set("x", "<Leader>f", function()
        vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
      end, { buffer = bufnr, desc = "[lsp] format" })
    end
  end,
})

----------------------------
-- Prettier setup
----------------------------
local prettier = require("prettier")

prettier.setup({
  bin = 'prettier', -- or `'prettierd'` (v0.23.3+)
  filetypes = {
    "css",
    "graphql",
    "html",
    "javascript",
    "javascriptreact",
    "json",
    "less",
    "markdown",
    "scss",
    "typescript",
    "typescriptreact",
    "yaml",
  },
  ["null-ls"] = {
    condition = function()
      return prettier.config_exists({
        -- if `false`, skips checking `package.json` for `"prettier"` key
        check_package_json = true,
      })
    end,
    runtime_condition = function(params)
      -- return false to skip running prettier
      return true
    end,
    timeout = 5000,
  },
  cli_options = {
    config_preference = "prefer_file",
    tab_width = 4,
    semi = true,
    trailing_comma = "es5",
    single_quote = true
  }
})


---------------------------
-- Sonarlint Config
---------------------------
require('sonarlint').setup({
   server = {
      cmd = { 
         'sonarlint-language-server',
         -- Ensure that sonarlint-language-server uses stdio channel
         '-stdio',
         '-analyzers',
         -- paths to the analyzers you need, using those for python and java in this example
         vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarpython.jar"),
         vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarcfamily.jar"),
         vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarjava.jar"),   
         -- vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarjava.jar"),
      }
   },
   filetypes = {
      'python',
      'cpp',
      'javascript',
      'typescript',
      'terraform',
      'html',
   }
})

---------------------------
-- Formatter Config
---------------------------
vim.keymap.set("n", "<leader>s", ":Prettier<CR>")

return {
  lsp = {
    formatting = {
      format_on_save = {
        enabled = true, -- enable format on save
      }
    }
  }
}
