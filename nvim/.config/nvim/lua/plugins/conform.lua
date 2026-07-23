return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      sql = { "sql_formatter" },
      sh = { "shfmt" },
      bash = { "shfmt" },
    },
    formatters = {
      sql_formatter = {
        args = { "--config", '{"keywordCase": "upper"}' },
      },
      shfmt = {
        args = {
          "-i",
          "4",
          "-ci",
          "-bn",
        },
      },
    },
  },
}
