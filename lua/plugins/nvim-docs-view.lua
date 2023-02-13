return {
  "amrbashir/nvim-docs-view",
  opt = true,
  cmd = { "DocsViewToggle" },
  config = function()
    require("docs-view").setup({
      position = "right",
      width = 85,
      update_mode = "manual",
    })
  end,
}
