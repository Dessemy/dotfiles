-- lua/plugins/colorscheme.lua
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false, -- load at startup since it's the default theme
    priority = 1000, -- load before other plugins
    opts = {
      flavour = "mocha", -- hardcoded: always mocha, never "auto"
      transparent_background = false,
      term_colors = true,
      styles = {
        comments = { "italic" },
        keywords = { "italic" },
        functions = {},
        strings = {},
        variables = {},
      },
      integrations = {
        cmp = true,
        gitsigns = true,
        telescope = true,
        treesitter = true,
        notify = true,
        mason = true,
        which_key = true,
        indent_blankline = { enabled = true },
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
          },
          underlines = {
            errors = { "underline" },
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
          },
        },
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin-mocha")
    end,
  },
}
