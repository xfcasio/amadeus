vim.g.base46_cache = vim.fn.stdpath "data" .. "/nvchad/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

vim.o.shell = "fish"

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
    config = function()
      require "options"
    end,
  },

  --{
  --  "neoclide/coc.nvim",
  --  lazy = false,
  --  build = "npm ci"
  --},

  { import = "plugins" },
}, lazy_config)

function Center_cursor()
    local pos = vim.fn.getpos('.')
    vim.cmd('normal! zz')
    vim.fn.setpos('.', pos)
end

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "nvchad.autocmds"

vim.schedule(function()
  require "mappings"
end)

-- vim.api.nvim_exec2([[
--   autocmd CursorMoved,CursorMovedI * lua Center_cursor()
-- ]], { output = false })

require("nvim-tree").setup({
  view = {
    width = 24,
  },

  hijack_directories = {
    enable = true,
    auto_open = true,
  },
})

-- clangd for C/C++
vim.lsp.config('clangd', {
  cmd = { "clangd", "--completion-style=detailed" },
  init_options = {
    clangdFileStatus = true,
    fallbackFlags = {
      "-I/nix/store/qs54xir5n4vhhbi22aydbkvyyq4v8p0l-gcc-14.2.1.20250322/include/",
      "-I/nix/store/qs54xir5n4vhhbi22aydbkvyyq4v8p0l-gcc-14.2.1.20250322/include/c++/14.2.1.20250322/x86_64-unknown-linux-gnu/"
    }
  }
})
vim.lsp.enable('clangd')

-- rust-analyzer for Rust
vim.lsp.config('rust_analyzer', {
  filetypes = { "rust" },
  root_markers = { "Cargo.toml" },
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        allFeatures = true,
      },
      diagnostics = {
        enable = true,
        disabled = { "unresolved-proc-macro" },
        severity = { min = "error" }
      },
    },
  },
})
vim.lsp.enable('rust_analyzer')

-- zls for Zig
vim.g.zig_fmt_autosave = 0
vim.lsp.config('zls', {
  root_markers = { 'build.zig' },
  cmd = { '/usr/local/bin/zls' },
  filetypes = { "zig" },
  settings = {
    zls = {
      semantic_tokens = "partial",
      zig_exe_path = '/usr/bin/zig'
    }
  }
})
vim.lsp.enable('zls')

-- c3_lsp for C3
vim.lsp.config('c3_lsp', {
  cmd = { "/usr/local/bin/c3lsp" },
  filetypes = { "c3", "c3i" },
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    on_dir(
      vim.fs.root(fname, { "project.json" })
        or vim.fs.dirname(fname)
    )
  end,
  settings = {},
})
vim.lsp.enable('c3_lsp')

-- Diagnostic configuration (unchanged)
vim.diagnostic.config({
  severity_sort = true,
  signs = {
    severity = { min = vim.diagnostic.severity.ERROR }
  },
  virtual_text = {
    severity = { min = vim.diagnostic.severity.ERROR }
  },
  float = {
    severity = { min = vim.diagnostic.severity.ERROR }
  },
  underline = {
    severity = { min = vim.diagnostic.severity.ERROR }
  },
})


-- NvimTree :Open command (with xdg-open)
vim.api.nvim_create_user_command("Open", function()
  local api = require("nvim-tree.api")
  local node = api.tree.get_node_under_cursor()

  if not node then
    print("No file selected.")
    return
  end
  local path = node.absolute_path
  vim.fn.jobstart({ "xdg-open", path }, { detach = true })
end, {})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.conceallevel = 2
  end,
})

vim.treesitter.language.register('c', 'cpp')


require('render-markdown').setup({
  bullet = {
    icon = "•",
    highlight = 'MarkdownListDot',
  },
})

--require('neoscroll').setup({
--  mappings = {                 -- Keys to be mapped to their corresponding default scrolling animation
--    '<C-u>', '<C-d>',
--    '<C-b>', '<C-f>',
--    '<C-y>', '<C-e>',
--    'zt', 'zz', 'zb',
--  },
--  hide_cursor = true,          -- Hide cursor while scrolling
--  stop_eof = true,             -- Stop at <EOF> when scrolling downwards
--  respect_scrolloff = false,   -- Stop scrolling when the cursor reaches the scrolloff margin of the file
--  cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
--  duration_multiplier = 1.0,   -- Global duration multiplier
--  easing = 'linear',           -- Default easing function
--  pre_hook = nil,              -- Function to run before the scrolling animation starts
--  post_hook = nil,             -- Function to run after the scrolling animation ends
--  performance_mode = false,    -- Disable "Performance Mode" on all buffers.
--  ignored_events = {           -- Events ignored while scrolling
--      'WinScrolled', 'CursorMoved'
--  },
--})

vim.api.nvim_set_hl(0, 'MarkdownListDot', { fg = '#5F87D7' })

vim.cmd("set numberwidth=4")
vim.cmd("set relativenumber")
vim.o.wrap = false

vim.o.list = true
vim.o.listchars = "extends:⟩,precedes:⟨"

vim.cmd [[highlight NonText guifg=#333B3F gui=nocombine]]

local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- map('n', 'p', 'k', opts)  -- w to move up
-- map('n', 'a', 'h', opts)  -- a to move left
-- map('n', 's', 'j', opts)  -- s to move down
-- map('n', 'd', 'l', opts)  -- d to move right

-- Move selected chunk up/down with alt
map("v", "<S-down>", ":m '>+1<CR>gv=gv", opts)
map("v", "<S-up>", ":m '<-2<CR>gv=gv", opts)

map("n", "<C-x>", "<C-e>", opts)
map("n", "<C-m>", "<C-y>", opts)
map("n", "<C-c>", "norm", opts)

-- Neovide
vim.g.neovide_padding_top = 10
vim.g.neovide_padding_bottom = 10
vim.g.neovide_padding_right = 10
vim.g.neovide_padding_left = 10

vim.g.neovide_transparency = 1.0

vim.opt.winblend = 30
vim.opt.pumblend = 30

vim.opt.list = false
