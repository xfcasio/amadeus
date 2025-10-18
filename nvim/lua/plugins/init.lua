return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    config = function()
      require "configs.conform"
    end,
  },

  {
    "NvChad/nvterm",
    config = function ()
      require("nvterm").setup({
        terminals = {
          shell = vim.o.shell,
          list = {},
          type_opts = {
            float = {
              relative = 'editor',
              row = 4.3,
              col = 4.25,
              width = 3.5,
              height = 3.4,
              border = "single",
            },
            horizontal = { location = "rightbelow", split_ratio = .3, },
            vertical = { location = "rightbelow", split_ratio = .5 },
          }
        },
        behavior = {
          autoclose_on_quit = {
            enabled = false,
            confirm = true,
          },
          close_on_exit = true,
          auto_insert = true,
        },
      })
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup {
        ensure_installed = { "clangd", "rust_analyzer" }
      }
    end
  },

  {
    "neovim/nvim-lspconfig",
  },

  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "lua-language-server", "stylua",
        "html-lsp", "css-lsp" , "prettier",
        "clang", "rust-analyzer"
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "lua", "rust", "cpp" },
      highlight = { enable = true },
    },
  },

  {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = false,
    ui = { enable = true },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "lukas-reineke/headlines.nvim",
    },
    opts = {
      workspaces = {
        { name = "Cerebrum", path = "~/vaults/Cerebrum" },
      },

      note_id_func = function(title)
        if title ~= nil and title ~= "" then
          return title
        else
          return os.date("%Y%m%d-%H%M%S")
        end
      end,
    },
    config = function(_, opts)
      require("obsidian").setup(opts)
      require("headlines").setup({ markdown = { fat_headlines = true } })
    end,
  },

  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' },
    opts = {},
  },

  {
    "chaoren/vim-wordmotion",
    lazy = false,
  },

  {
    "folke/which-key.nvim",
    enabled = false,
  },

  {
    "ziglang/zig.vim",
    enabled = true,
  },

--  {
--    "IogaMaster/neocord",
--    event = "VeryLazy",
--    config = {
--      main_image = "language",
--      show_time = true,
--      workspace_text = function()
--        return "doing something"
--      end,
--    },
--  },

  {
    "nvzone/typr",
    dependencies = "nvzone/volt",
    opts = {},
    cmd = { "Typr", "TyprStats" },
  }
}
