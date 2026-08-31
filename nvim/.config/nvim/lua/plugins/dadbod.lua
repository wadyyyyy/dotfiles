return {
  {
    "tpope/vim-dadbod",
    ft = { "sql", "mysql", "plsql" },
    keys = {
      {
        "<leader>DE",
        "<cmd>%DB<cr>",
        mode = "n",
        desc = "Execute whole SQL file",
      },
      {
        "<leader>DE",
        ":'<,'>DB<cr>",
        mode = "x",
        desc = "Execute selected SQL",
      },
    },
    init = function()
      vim.g.db_ui_execute_on_save = false
    end,
  },
  {
    "kristijanhusak/vim-dadbod-completion",
    -- enabled = false,
  },
}
