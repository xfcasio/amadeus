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

map("n", "va", ":ObsidianNew<CR>", { desc = "New Obsidian note" })
map("n", "vs", ":ObsidianSearch<CR>", { desc = "Search Obsidian notes in vault" })

-- Visual: create a new Obsidian note from selection, replace selection with [[note-id|selection]]
map("v", "x", function()
end, { desc = "Turn selection into linked Obsidian note", silent = true })

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown" },
  callback = function()
    -- Override gd for Obsidian
    vim.keymap.set("n", "gd", function()
      vim.cmd("ObsidianFollowLink")
    end, { buffer = true, noremap = true, desc = "Follow Obsidian link" })
  end,
})

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- Helper: get visual selection text and range
local function get_visual_selection_range()
  local start_pos = vim.fn.getpos("v")
  local end_pos = vim.fn.getpos(".")
  local start_line, start_col = start_pos[2], start_pos[3]
  local end_line, end_col = end_pos[2], end_pos[3]

  -- normalize order (visual could be backward)
  if start_line > end_line or (start_line == end_line and start_col > end_col) then
    start_line, end_line = end_line, start_line
    start_col, end_col = end_col, start_col
  end

  return start_line, start_col, end_line, end_col
end

-- Helper: get selected text
local function get_visual_text()
  local bufnr = 0
  local sline, scol, eline, ecol = get_visual_selection_range()
  local lines = vim.api.nvim_buf_get_text(bufnr, sline - 1, scol - 1, eline - 1, ecol, {})
  return table.concat(lines, "\n"), sline, scol, eline, ecol
end

-- Action: replace selection with Obsidian link
local function link_selected_text_with_obsidian()
  local text, sline, scol, eline, ecol = get_visual_text()
  if not text or text == "" then return end

  -- Sanitize and build link
  local note_name = text:gsub("[%[%]]", ""):gsub("\n", " ")
  local link = string.format("[[%s|%s]]", note_name, text)

  -- Replace the selection with the link
  vim.api.nvim_buf_set_text(0, sline - 1, scol - 1, eline - 1, ecol, { link })

  -- Optional: create the note via Obsidian.nvim API (if installed)
  local ok, obsidian = pcall(require, "obsidian")
  if ok and obsidian and obsidian.api and obsidian.api.create_note then
    obsidian.api.create_note(note_name)
  end

  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
end

-- Keymap: Visual mode "x" → replace selection with Obsidian link
vim.keymap.set("x", "x", link_selected_text_with_obsidian, {
  desc = "Replace selection with Obsidian link",
  silent = true,
})
