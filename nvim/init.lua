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
  hijack_directories = {
    enable = true,
    auto_open = true,
  },
})

local lspconfig = require "lspconfig"

-- Enable ccls for C/C++
lspconfig.clangd.setup{
  cmd = { "clangd", "--completion-style=detailed" },
  init_options = {
    clangdFileStatus = true,
    fallbackFlags = {
      "-std=c++23",
      "-I/nix/store/qs54xir5n4vhhbi22aydbkvyyq4v8p0l-gcc-14.2.1.20250322/include/",
      "-I/nix/store/qs54xir5n4vhhbi22aydbkvyyq4v8p0l-gcc-14.2.1.20250322/include/c++/14.2.1.20250322/x86_64-unknown-linux-gnu/"
    }
  }
}

-- Enable rust-analyzer for Rust
lspconfig.rust_analyzer.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "rust" },
  root_dir = lspconfig.util.root_pattern("Cargo.toml"),
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        allFeatures = true, -- Enable all features for analysis
      },
      diagnostics = {
        enable = true,
        disabled = { "unresolved-proc-macro" },
        severity = { min = "error" }
      },
    },
  },
})

lspconfig.c3_lsp.setup({
  cmd = { "/usr/local/bin/c3lsp" },
  filetypes = { "c3", "c3i" },
  root_dir = function(fname)
    return lspconfig.util.root_pattern("project.json")(fname)
        or lspconfig.util.path.dirname(fname)
  end,
  settings = {},
  name = "c3_lsp"
})

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

vim.treesitter.language.register('c', 'cpp')

vim.cmd("set numberwidth=4")
vim.cmd("set relativenumber")

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

vim.g.neovide_transparency = 0.5

vim.opt.winblend = 30
vim.opt.pumblend = 30
