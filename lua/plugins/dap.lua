return {
  {
    "mfussenegger/nvim-dap",
    -- opt = true,
    -- event = "BufReadPre",
    -- module = { "dap" },
    -- wants = { "nvim-dap-virtual-text", "DAPInstall.nvim", "nvim-dap-ui", "nvim-dap-python", "which-key.nvim" },
    -- requires = {
    --   "Pocco81/DAPInstall.nvim",
    --   "theHamsta/nvim-dap-virtual-text",
    --   "rcarriga/nvim-dap-ui",
    --   "mfussenegger/nvim-dap-python",
    --   "nvim-telescope/telescope-dap.nvim",
    --   { "leoluz/nvim-dap-go", module = "dap-go" },
    --   { "jbyuki/one-small-step-for-vimkind", module = "osv" },
    -- },
    -- config = function()
    --   require("dap.init").setup()
    -- end,
  },
  {
    "Pocco81/DAPInstall.nvim",
  },
  {
    "theHamsta/nvim-dap-virtual-text",
  },
  {
    "nvim-telescope/telescope-dap.nvim",
  },
  {
    "mfussenegger/nvim-dap-python",
  },
  { "leoluz/nvim-dap-go", module = "dap-go" },
  { "jbyuki/one-small-step-for-vimkind", module = "osv" },
  { "rcarriga/nvim-dap-ui" },
  { "puremourning/vimspector" },
  { "mxsdev/nvim-dap-vscode-js" },
  {
    "microsoft/vscode-node-debug2",
    -- lazy = true,
    build = "npm install && NODE_OPTIONS=--no-experimental-fetch npm run build",
  },
  {
    "microsoft/vscode-js-debug",
    -- lazy = true,
    build = "npm install --legacy-peer-deps && npm run compile",
  },
}
