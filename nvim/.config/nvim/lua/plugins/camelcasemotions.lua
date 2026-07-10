return {
  {
    "bkad/CamelCaseMotion",
    config = function()
      vim.keymap.set({ "n", "x", "o" }, "w", "<Plug>CamelCaseMotion_w")
      vim.keymap.set({ "n", "x", "o" }, "b", "<Plug>CamelCaseMotion_b")
      vim.keymap.set({ "n", "x", "o" }, "e", "<Plug>CamelCaseMotion_e")
    end,
  },
}
