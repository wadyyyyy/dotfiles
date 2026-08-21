return {
  -- 1. Базовый плагин (здесь мы просто регистрируем наши базы)
  {
    "tpope/vim-dadbod",
    config = function()
      -- Словарь с твоими базами. Сюда добавляешь новые по мере необходимости
      vim.g.dbs = {
        sqlb3 = "postgres://postgres@localhost:5432/sqlb3",
        kaki = "postgres://postgres@localhost:5432/kaki",
      }
    end,
  },

  -- 2. UI и бинды
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = { "tpope/vim-dadbod" },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
    end,
    keys = {
      -- Явно указываем группу для which-key + добавляем иконку БД для красоты
      { "<leader>D", group = "Manage DBs", icon = "󰆼 " },

      -- Стандартный тогл боковой панели
      { "<leader>DT", "<cmd>DBUIToggle<cr>", desc = "Toggle DBUI" },

      -- Наш кастомный селект глобальной базы
      {
        "<leader>DS",
        function()
          local dbs = vim.g.dbs

          -- Защита от дурака, если забыл прописать базы
          if not dbs or vim.tbl_isempty(dbs) then
            vim.notify("Сначала пропиши подключения в vim.g.dbs!", vim.log.levels.ERROR)
            return
          end

          -- Достаем ключи (sqlb3, day01 и т.д.)
          local names = vim.tbl_keys(dbs)

          -- Вызываем стандартное меню выбора (в LazyVim оно откроется через Telescope)
          vim.ui.select(
            names,
            { prompt = "󰆼 Выбери базу для всех буферов:" },
            function(choice)
              -- choice будет nil, если ты нажал Esc и закрыл меню
              if choice then
                vim.g.db = dbs[choice]
                vim.notify(
                  "Успешно! Глобальная БД переключена на: " .. choice,
                  vim.log.levels.INFO
                )
              end
            end
          )
        end,
        desc = "Select Global DB",
      },
    },
  },
}
