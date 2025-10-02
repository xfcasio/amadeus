require "nvchad.mappings"

-- add yours here
require("nvterm").setup()

local map = vim.keymap.set

local terminal = require("nvterm.terminal")

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map('n', 'gd', vim.lsp.buf.definition)
map('n', 'gr', vim.lsp.buf.references)

map({'n', 't'}, '<A-k>', function ()
  require("nvchad.term").toggle {
    pos = "float",
    float_opts = {
      row = 0.01, col = 0.045,
      width = 0.9, height = 0.86
    }
  }
end)

map({'n', 't'}, '<A-l>', function ()
  require("nvchad.term").toggle { pos = "vsp", size = 0.5 }
end)


-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
