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

      mappings = {
        -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
        ["gf"] = {
          action = function()
            return require("obsidian").util.gf_passthrough()
          end,
          opts = { noremap = false, expr = true, buffer = true },
        },
        -- Toggle check-boxes.
        ["<leader>ch"] = {
          action = function()
            return require("obsidian").util.toggle_checkbox()
          end,
          opts = { buffer = true },
        },
        -- Smart action depending on context, either follow link or toggle checkbox.
        ["<cr>"] = {
          action = function()
            return require("obsidian").util.smart_action()
          end,
          opts = { buffer = true, expr = true },
        }
      },

      follow_url_func = function(url)
        -- Open the URL in the default web browser.
        -- vim.fn.jobstart({ "xdg-open", url })
        vim.ui.open(url) -- need Neovim 0.10.0+
      end,

      -- Optional, by default when you use `:ObsidianFollowLink` on a link to an image
      -- file it will be ignored but you can customize this behavior here.
      ---@param img string
      follow_img_func = function(img)
        vim.fn.jobstart({"feh", url})
      end,

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

  {
    "sphamba/smear-cursor.nvim",
    lazy = false,
    opts = {
      never_draw_over_target = true,

      -- Smear cursor when switching buffers or windows.
      smear_between_buffers = true,

      -- Smear cursor when moving within line or to neighbor lines.
      -- Use `min_horizontal_distance_smear` and `min_vertical_distance_smear` for finer control
      smear_between_neighbor_lines = true,

      -- Draw the smear in buffer space instead of screen space when scrolling
      scroll_buffer_space = true,

      -- Set to `true` if your font supports legacy computing symbols (block unicode symbols).
      -- Smears and particles will look a lot less blocky.
      legacy_computing_symbols_support = true,

      -- Smear cursor in insert mode.
      -- See also `vertical_bar_cursor_insert_mode` and `distance_stop_animating_vertical_bar`.
      smear_insert_mode = true,

      gradient_exponent = 0,
      particles_enabled = false,
      particle_spread = 1,
      particles_per_second = 100,
      particles_per_length = 100,
      particle_max_lifetime = 2000,
      particle_max_initial_velocity = 10,
      particle_velocity_from_cursor = 0,
      particle_random_velocity = 500,
      particle_damping = 0.1,
      particle_gravity = 100,
    },
  },

  {
    "karb94/neoscroll.nvim",
    opts = {
      performance_mode = true,
      duration_multiplier = 2.0,
      easing = "quadratic",
    },
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
  },
}
