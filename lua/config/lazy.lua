local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require("lazy").setup({
  spec = {
    -- add LazyVim and import its plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- import any extras modules here
    -- { import = "lazyvim.plugins.extras.lang.typescript" },
    -- { import = "lazyvim.plugins.extras.lang.json" },
    -- { import = "lazyvim.plugins.extras.ui.mini-animate" },
    -- import/override with your plugins
    { import = "plugins" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = { enabled = true }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

-- Dap Setup
local dap, dapui = require("dap"), require("dapui")
require("dap-vscode-js").setup({
  adapters = {
    "pwa-node",
    "pwa-chrome",
    "pwa-msedge",
    "node-terminal",
    "pwa-extensionHost",
  },
})

-- Node
dap.adapters.node2 = {
  type = "executable",
  command = "node",
  args = { os.getenv("HOME") .. "/dev/microsoft/vscode-node-debug2/out/src/nodeDebug.js" },
}
dap.configurations.javascript = {
  {
    name = "Launch",
    type = "node2",
    request = "launch",
    program = "${file}",
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = "inspector",
    console = "integratedTerminal",
  },
  {
    -- For this to work you need to make sure the node process is started with the `--inspect` flag.
    name = "Attach to process",
    type = "node2",
    request = "attach",
    processId = require("dap.utils").pick_process,
  },
}

-- Dotnet

dap.adapters.coreclr = {
  type = "executable",
  command = "netcoredbg",
  args = { "--interpreter=vscode" },
}

vim.g.dotnet_build_project = function()
  local default_path = vim.fn.getcwd() .. "/"
  if vim.g["dotnet_last_proj_path"] ~= nil then
    default_path = vim.g["dotnet_last_proj_path"]
  end
  local path = vim.fn.input("Path to your *proj file", default_path, "file")
  vim.g["dotnet_last_proj_path"] = path
  local cmd = "dotnet build -c Debug " .. path .. " > /dev/null"
  print("")
  print("Cmd to execute: " .. cmd)
  local f = os.execute(cmd)
  if f == 0 then
    print("\nBuild: ✔️ ")
  else
    print("\nBuild: ❌ (code: " .. f .. ")")
  end
end

vim.g.dotnet_get_dll_path = function()
  local request = function()
    return vim.fn.input("Path to dll", vim.fn.getcwd() .. "/bin/Debug/", "file")
  end

  if vim.g["dotnet_last_dll_path"] == nil then
    vim.g["dotnet_last_dll_path"] = request()
  else
    if
      vim.fn.confirm("Do you want to change the path to dll?\n" .. vim.g["dotnet_last_dll_path"], "&yes\n&no", 2) == 1
    then
      vim.g["dotnet_last_dll_path"] = request()
    end
  end

  return vim.g["dotnet_last_dll_path"]
end

local config = {
  {
    type = "coreclr",
    name = "launch - netcoredbg",
    request = "launch",
    program = function()
      if vim.fn.confirm("Should I recompile first?", "&yes\n&no", 2) == 1 then
        vim.g.dotnet_build_project()
      end
      return vim.g.dotnet_get_dll_path()
    end,
  },
}

dap.configurations.cs = config
dap.configurations.fsharp = config
-- require('dap').set_log_level('INFO')
dap.defaults.fallback.terminal_win_cmd = "20split new"

vim.fn.sign_define("DapBreakpoint", { text = "🟥", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointRejected", { text = "🟦", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "🟨", texthl = "", linehl = "", numhl = "" })

dapui.setup()
vim.keymap.set("n", "<leader>do", function()
  require("dapui").open()
end)
vim.keymap.set("n", "<leader>dC", function()
  require("dapui").close()
end)
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end
--
-- local M = {}
--
-- function M.setup()
--   local wk = require("which-key")
--
--   local n_opts = {
--     mode = "n",
--     prefix = "<leader>",
--     buffer = nil, -- nil implies global buffer
--     silent = true,
--     noremap = true,
--     nowait = false,
--   }
--
--   local n_mappings = {
--     d = {
--       name = "DAP",
--       R = { "<cmd>lua require'dap'.run_to_cursor()<cr>", "Run to Cursor" },
--       E = { "<cmd>lua require'dapui'.eval(vim.fn.input '[Expression] > ')<cr>", "Evaluate Input" },
--       C = { "<cmd>lua require'dap'.set_breakpoint(vim.fn.input '[Condition] > ')<cr>", "Conditional Breakpoint" },
--       U = { "<cmd>lua require'dapui'.toggle()<cr>", "Toggle UI" },
--       b = { "<cmd>lua require'dap'.step_back()<cr>", "Step Back" },
--       c = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
--       d = { "<cmd>lua require'dap'.disconnect()<cr>", "Disconnect" },
--       e = { "<cmd>lua require'dapui'.eval()<cr>", "Evaluate" },
--       g = { "<cmd>lua require'dap'.session()<cr>", "Get Session" },
--       h = { "<cmd>lua require'dap.ui.widgets'.hover()<cr>", "Hover Variables" },
--       S = { "<cmd>lua require'dap.ui.widgets'.scopes()<cr>", "Scopes" },
--       i = { "<cmd>lua require'dap'.step_into()<cr>", "Step Into" },
--       o = { "<cmd>lua require'dap'.step_over()<cr>", "Step Over" },
--       p = { "<cmd>lua require'dap'.pause.toggle()<cr>", "Pause" },
--       q = { "<cmd>lua require'dap'.close()<cr>", "Quit" },
--       r = { "<cmd>lua require'dap'.repl.toggle()<cr>", "Toggle Repl" },
--       s = { "<cmd>lua require'dap'.continue()<cr>", "Start" },
--       t = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Toggle Breakpoint" },
--       x = { "<cmd>lua require'dap'.terminate()<cr>", "Terminate" },
--       u = { "<cmd>lua require'dap'.step_out()<cr>", "Step Out" },
--     },
--   }
--
--   wk.register(n_mappings, n_opts)
-- end
--
-- return M
