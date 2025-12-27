-- This file needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/ui/blob/v2.5/lua/nvconfig.lua

---@type ChadrcConfig
local M = {}

M.ui = {
  statusline = {
    theme = 'minimal',
    separator_style = 'block',
    transparency = false,
  },

  cmp = {
    icons = true,
    lspkind_text = true,
    style = "atom_colored",
  },

  telescope = { style = "bordered" },
  lsp = { signature = true },

  hl_override = {
    Comment = { italic = true },
    Keyword = { italic = true },
    Statement = { italic = true },
    Variable = { italic = true },
    Type = { italic = true },
    Include = { italic = true },
    TSKeyword = { italic = true },
    TSDefine = { italic = true },
    TSKeyword = { italic = true },
    TSMethod = { italic = true },
    TSVariable = { italic = true },
    SpecialComment = { italic = true },
  }
}

M.nvdash = {
  load_on_startup = true,

  header = {
    "⢵⣆⣾⣶⣶⠖⠌⡟⠻⡿⢟⡥⡻⣿⣿⣿⣶⢩⠺⣿⣿⣿⣿⣿⡿⢏⣋⢺⣷⢨⣄⢵⣘⢿⣿⣿⣿⣿⣿⣷⣡⡻⣿⣡⡳⡍⠻⡋⠙⠝⣛⠋⠱⠞⠋⢂⠩⢙⣽⣘⢿⣿⣿⣿⣿",
    "⣾⣦⣩⣭⡡⠰⠐⣬⡛⢡⣼⣾⣿⢿⣿⣿⣷⣽⣧⣿⣿⣿⣿⠍⣻⣌⣻⢣⠣⣠⣧⠄⣙⢧⣝⣻⣿⣿⣷⡄⣠⠓⠌⢁⠄⠝⢠⣡⠐⡆⡀⠱⡂⡇⠄⡞⢐⠢⢁⡝⢷⣿⣿⣿⣿",
    "⣿⣿⣷⡝⠛⣴⡏⠙⣿⣾⣿⣿⣿⢣⡜⢻⣿⣿⣿⣿⣿⣿⡍⠀⢣⢱⢸⣿⡇⣿⣿⣧⠉⢰⣽⣿⣭⢻⣷⠙⠈⢢⠑⠒⡖⢣⣤⠐⡍⣯⠑⢸⡇⢰⠈⢢⢣⢲⣭⢩⠈⣬⡝⣿⣿",
    "⢭⡙⡟⢡⣞⢿⣦⣳⣝⢯⣿⣿⡿⢏⢤⣡⣍⢿⣿⣿⣿⢟⣟⢣⣌⣨⡘⡿⡏⢛⠟⣱⢮⡱⣜⡻⣿⣶⡜⠨⢅⢓⡚⡢⡦⢑⣄⣇⡎⣆⠣⣧⠸⢨⢉⢒⠱⣌⡥⠗⡡⢻⣶⣽⡿",
    "⣿⣿⡷⠊⣿⣿⣭⣻⠏⡃⠴⠋⠙⠀⠑⠛⠛⠈⠉⠛⣩⡍⡅⢶⣿⣿⣿⣶⣔⡰⢴⣮⡍⡳⣬⠋⢽⡿⢟⠀⠏⢢⣪⡿⠾⣮⡻⢯⣿⣬⣧⣊⠆⠸⢠⠔⣎⠡⠖⡱⡤⢄⠢⢻⣽",
    "⠛⠍⠷⣆⠉⡍⠙⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⣰⣯⣽⣿⣿⣿⣿⣎⢾⣿⣷⣶⣸⢦⢻⡿⠟⢈⣴⣾⣿⢧⣐⠀⠹⣊⢿⣿⣿⣿⣧⢋⠰⡭⠮⣌⢩⠑⠠⠚⣰⣷⣾",
    "⡞⠛⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠋⠈⠙⠥⣍⣥⣜⣿⣿⣿⠿⣧⣨⠉⣤⢄⣻⣿⣿⣿⣿⣶⣧⣀⡿⣨⣿⣟⡿⣿⢷⡵⢌⠦⢒⠕⢌⡓⠥⠡⠉⣿",
    "⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠻⢿⣿⠿⢖⠔⡀⡗⠀⠛⠓⠿⢿⣿⣿⡿⢫⣕⣏⣿⡭⢍⡹⡸⡮⣽⡑⢭⣫⠻⠎⠹⠜⡜⢿⣿",
    "⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⠱⣁⢁⠈⠀⠀⣀⠶⣁⡀⠉⢿⣿⡿⣏⣾⡿⢀⡀⣱⡀⢇⡷⠆⢆⢹⡎⠷⡉⢉⡰⢱⣏",
    "⣃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡔⣰⠇⠀⢴⣞⡡⣥⣆⠀⢻⣿⠉⣿⠇⠈⠠⡔⢻⡨⢷⠂⡐⣘⠸⠙⣊⠈⣾⡽⣽",
    "⣿⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢐⡚⢋⣀⢠⣴⠂⠻⣿⣿⠞⠉⠀⠀⠁⠘⣎⡄⢪⢈⢳⣶⠿⠃⠂⠥⠒⠊⢱⡊⣃⠈⡲⢿",
    "⢿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡾⡵⠁⣿⣄⡠⠘⠁⠀⠀⠌⠀⢄⢰⣥⣅⣤⠮⠛⠁⠀⡌⡐⠬⣒⡐⠭⡹⠘⠎⢸⣷",
    "⠃⠀⠀⢠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⡋⣾⠁⢄⣘⣿⡷⠊⣔⠀⠀⠀⠠⠂⠼⠛⠟⠉⢀⣀⠂⠅⣐⡬⠷⢻⣽⢣⢕⠡⣅⡋⣽",
    "⠈⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⢍⣈⣍⣭⣽⣶⣟⣙⠀⠘⣡⣠⣾⣬⣭⣤⡑⢳⣽⡻⣴⣦⡵⠩⠶⣟⢷⠖⡫⠌⠐⣿",
    "⠀⠀⠀⠀⠀⠀⠀⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠻⢛⠃⢄⣸⣿⡟⠀⡟⣼⣿⣿⣿⣿⣿⣿⣼⡛⢻⣋⢟⠿⣄⡛⢹⣿⡀⣀⢸⣿⢟",
    "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠙⠛⠋⠀⠀⢸⣿⣿⣿⣿⣿⣻⣿⣿⣿⣿⣮⣷⣯⡚⠻⣿⣿⣿⡖⢶⣵⡮",
    "⠐⠀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⠿⣿⣿⣿⠯⣾⣿⣿⣿⣿⣿⣿⣿⡯⣲⢿⣿⣇⢮⣻⣿",
    "                                                                 ",
    "                                                                 ",
    "                                                                 ",
    "                                                                 ",
    "                                                                 ",
  },
}

M.override = {
}

M.base46 = {
  theme = 'rxyhn',

  hl_override = {
    ["Function"] = { fg = "#BC83E3" },
    ["Statement"] = { fg = "#7F98E8" },
    ["@variable"] = { fg = "#E6930C" },
    ["@Type"] = { fg = "#FA967E" },
    ["Type"] = { fg = "#FA967E" },
    ["Special"] = { fg = "#BC83E3" },
    ["Repeat"] = { fg = "#BC83E3" },
    ["PreProc"] = { fg = "#BC83E3" },
    ["Macro"] = { fg = "#BC83E3" },
    ["@constant"] = { fg = "#F7A41D" },

    Normal = {
      bg = "none",
      fg = "#A9A9A9", 
    },

    LineNr = { fg = "#767B7D" },
    CursorLineNr = { fg = "#ff9e64" },

    NvimTreeNormal = { bg = 'none' },
    NvimTreeNormalNC = { bg = 'none' },
  },
}

return M
