-- Dap Keybindings

vim.keymap.set("n", "<leader>dh", function()
  require("dap").toggle_breakpoint()
end)
vim.keymap.set("n", "<leader>dH", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
vim.keymap.set({ "n", "t" }, "<A-k>", function()
  require("dap").step_out()
end)
vim.keymap.set({ "n", "t" }, "<A-l>", function()
  require("dap").step_into()
end)
vim.keymap.set({ "n", "t" }, "<A-j>", function()
  require("dap").step_over()
end)
vim.keymap.set({ "n", "t" }, "<A-h>", function()
  require("dap").continue()
end)
vim.keymap.set("n", "<leader>dn", function()
  require("dap").run_to_cursor()
end)
vim.keymap.set("n", "<leader>dc", function()
  require("dap").terminate()
end)
vim.keymap.set("n", "<leader>dR", function()
  require("dap").clear_breakpoints()
end)
vim.keymap.set("n", "<leader>de", function()
  require("dap").set_exception_breakpoints({ "all" })
end)
vim.keymap.set("n", "<leader>da", function()
  require("debugHelper").attach()
end)
vim.keymap.set("n", "<leader>dA", function()
  require("debugHelper").attachToRemote()
end)
vim.keymap.set("n", "<leader>di", function()
  require("dap.ui.widgets").hover()
end)
vim.keymap.set("n", "<leader>d?", function()
  local widgets = require("dap.ui.widgets")
  widgets.centered_float(widgets.scopes)
end)
vim.keymap.set("n", "<leader>dk", ':lua require"dap".up()<CR>zz')
vim.keymap.set("n", "<leader>dj", ':lua require"dap".down()<CR>zz')
vim.keymap.set("n", "<leader>dr", ':lua require"dap".repl.toggle({}, "vsplit")<CR><C-w>l')
vim.keymap.set("n", "<leader>du", ':lua require"dapui".toggle()<CR>')

-- nvim-telescope/telescope-dap.nvim
require("telescope").load_extension("dap")
vim.keymap.set("n", "<leader>ds", ":Telescope dap frames<CR>")
vim.keymap.set("n", "<leader>dc", ":Telescope dap commands<CR>")
vim.keymap.set("n", "<leader>db", ":Telescope dap list_breakpoints<CR>")

-- DocsViewToggle Keubinds
vim.keymap.set("n", "<leader>ee", ":DocsViewToggle<CR>")
vim.keymap.set("n", "<leader>er", ":DocsViewUpdate<CR>")

-- Whichkey mappings
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
