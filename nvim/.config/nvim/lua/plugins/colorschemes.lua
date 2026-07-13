return {
  -- set default theme
  {
    "LazyVim/LazyVim",
    opts = {
      -- colorscheme = "catppuccin-macchiato",
      colorscheme = "gruvbox",
    },
  },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    -- priority = 1000, -- set priority only for theme used rn
    opts = {
      transparent_background = true,
    },
  },
  { "rebelot/kanagawa.nvim" },
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    opts = {
      transparent_mode = true,
    },
  },
}
