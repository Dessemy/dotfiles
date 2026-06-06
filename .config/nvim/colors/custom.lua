local colors = {
  bg        = "#101315",
  bg_alt    = "#1a1e21",
  bg_dim    = "#343d41",
  border    = "#4b4e55",
  muted     = "#565d60",
  fg        = "#cacccc",
  fg_dim    = "#9fa5a9",
  fg_bright = "#d9dbdc",
  accent    = "#798186",
  warm      = "#de6145",
  mid       = "#707070",
  silver    = "#aeaeae",
  light     = "#a5aeb4",
  beige     = "#cbc2be",
}

vim.cmd("highlight clear")
vim.o.background = "dark"
vim.g.colors_name = "solitude"

local function hi(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- Editor
hi("Normal",        { fg = colors.fg,       bg = colors.bg })
hi("NormalFloat",   { fg = colors.fg,       bg = colors.bg_alt })
hi("NormalNC",      { fg = colors.fg_dim,   bg = colors.bg })
hi("ColorColumn",   { bg = colors.bg_alt })
hi("Cursor",        { fg = colors.bg,       bg = colors.fg })
hi("CursorLine",    { bg = colors.bg_alt })
hi("CursorLineNr",  { fg = colors.accent,   bold = true })
hi("LineNr",        { fg = colors.border })
hi("SignColumn",    { fg = colors.border,   bg = colors.bg })
hi("VertSplit",     { fg = colors.border,   bg = colors.bg })
hi("WinSeparator",  { fg = colors.border })
hi("Folded",        { fg = colors.muted,    bg = colors.bg_alt })
hi("FoldColumn",    { fg = colors.muted,    bg = colors.bg })
hi("StatusLine",    { fg = colors.fg_dim,   bg = colors.bg_alt })
hi("StatusLineNC",  { fg = colors.muted,    bg = colors.bg })
hi("TabLine",       { fg = colors.muted,    bg = colors.bg_alt })
hi("TabLineFill",   { bg = colors.bg })
hi("TabLineSel",    { fg = colors.fg,       bg = colors.bg,  bold = true })
hi("Pmenu",         { fg = colors.fg_dim,   bg = colors.bg_alt })
hi("PmenuSel",      { fg = colors.fg,       bg = colors.bg_dim })
hi("PmenuSbar",     { bg = colors.bg_dim })
hi("PmenuThumb",    { bg = colors.accent })
hi("WildMenu",      { fg = colors.fg,       bg = colors.bg_dim })
hi("Visual",        { bg = colors.bg_dim })
hi("VisualNOS",     { bg = colors.bg_dim })
hi("Search",        { fg = colors.bg,       bg = colors.accent })
hi("IncSearch",     { fg = colors.bg,       bg = colors.fg_bright })
hi("MatchParen",    { fg = colors.fg_bright, bold = true, underline = true })
hi("NonText",       { fg = colors.border })
hi("SpecialKey",    { fg = colors.border })
hi("Whitespace",    { fg = colors.border })
hi("EndOfBuffer",   { fg = colors.border })
hi("Directory",     { fg = colors.accent })
hi("Title",         { fg = colors.fg_bright, bold = true })
hi("Question",      { fg = colors.accent })
hi("MoreMsg",       { fg = colors.accent })
hi("ModeMsg",       { fg = colors.fg_dim })
hi("ErrorMsg",      { fg = colors.warm })
hi("WarningMsg",    { fg = colors.fg_bright })
hi("SpellBad",      { sp = colors.warm,     undercurl = true })
hi("SpellCap",      { sp = colors.accent,   undercurl = true })
hi("SpellLocal",    { sp = colors.silver,   undercurl = true })
hi("SpellRare",     { sp = colors.mid,      undercurl = true })

-- Syntax
hi("Comment",       { fg = colors.muted,    italic = true })
hi("Constant",      { fg = colors.fg_bright })
hi("String",        { fg = colors.fg_dim })
hi("Character",     { fg = colors.fg_dim })
hi("Number",        { fg = colors.fg_bright })
hi("Boolean",       { fg = colors.accent,   bold = true })
hi("Float",         { fg = colors.fg_bright })
hi("Identifier",    { fg = colors.fg })
hi("Function",      { fg = colors.accent,   bold = true })
hi("Statement",     { fg = colors.silver })
hi("Conditional",   { fg = colors.silver })
hi("Repeat",        { fg = colors.silver })
hi("Label",         { fg = colors.silver })
hi("Operator",      { fg = colors.mid })
hi("Keyword",       { fg = colors.silver,   italic = true })
hi("Exception",     { fg = colors.warm })
hi("PreProc",       { fg = colors.fg_dim })
hi("Include",       { fg = colors.fg_dim })
hi("Define",        { fg = colors.fg_dim })
hi("Macro",         { fg = colors.fg_dim })
hi("PreCondit",     { fg = colors.fg_dim })
hi("Type",          { fg = colors.light })
hi("StorageClass",  { fg = colors.silver })
hi("Structure",     { fg = colors.light })
hi("Typedef",       { fg = colors.light })
hi("Special",       { fg = colors.beige })
hi("SpecialChar",   { fg = colors.beige })
hi("Tag",           { fg = colors.accent })
hi("Delimiter",     { fg = colors.muted })
hi("SpecialComment",{ fg = colors.muted,    italic = true })
hi("Debug",         { fg = colors.warm })
hi("Underlined",    { underline = true })
hi("Error",         { fg = colors.warm })
hi("Todo",          { fg = colors.bg,       bg = colors.accent, bold = true })

-- Diff
hi("DiffAdd",       { fg = colors.fg_dim,   bg = colors.bg_alt })
hi("DiffChange",    { fg = colors.accent,   bg = colors.bg_alt })
hi("DiffDelete",    { fg = colors.warm,     bg = colors.bg_alt })
hi("DiffText",      { fg = colors.fg,       bg = colors.bg_dim })

-- Git signs (gitsigns.nvim)
hi("GitSignsAdd",     { fg = colors.fg_dim })
hi("GitSignsChange",  { fg = colors.accent })
hi("GitSignsDelete",  { fg = colors.warm })

-- Diagnostics
hi("DiagnosticError",       { fg = colors.warm })
hi("DiagnosticWarn",        { fg = colors.fg_bright })
hi("DiagnosticInfo",        { fg = colors.accent })
hi("DiagnosticHint",        { fg = colors.muted })
hi("DiagnosticUnderlineError", { sp = colors.warm,       undercurl = true })
hi("DiagnosticUnderlineWarn",  { sp = colors.fg_bright,  undercurl = true })
hi("DiagnosticUnderlineInfo",  { sp = colors.accent,     undercurl = true })
hi("DiagnosticUnderlineHint",  { sp = colors.muted,      undercurl = true })

-- Treesitter
hi("@variable",             { fg = colors.fg })
hi("@variable.builtin",     { fg = colors.silver,  italic = true })
hi("@constant",             { fg = colors.fg_bright })
hi("@constant.builtin",     { fg = colors.fg_bright, bold = true })
hi("@string",               { fg = colors.fg_dim })
hi("@string.escape",        { fg = colors.beige })
hi("@number",               { fg = colors.fg_bright })
hi("@boolean",              { fg = colors.accent,  bold = true })
hi("@function",             { fg = colors.accent,  bold = true })
hi("@function.builtin",     { fg = colors.accent })
hi("@function.call",        { fg = colors.accent })
hi("@method",               { fg = colors.accent })
hi("@method.call",          { fg = colors.accent })
hi("@keyword",              { fg = colors.silver,  italic = true })
hi("@keyword.return",       { fg = colors.silver,  italic = true })
hi("@keyword.function",     { fg = colors.silver })
hi("@keyword.operator",     { fg = colors.mid })
hi("@operator",             { fg = colors.mid })
hi("@punctuation",          { fg = colors.muted })
hi("@punctuation.bracket",  { fg = colors.muted })
hi("@punctuation.delimiter",{ fg = colors.muted })
hi("@type",                 { fg = colors.light })
hi("@type.builtin",         { fg = colors.light,   italic = true })
hi("@tag",                  { fg = colors.accent })
hi("@tag.attribute",        { fg = colors.fg_dim })
hi("@tag.delimiter",        { fg = colors.muted })
hi("@comment",              { fg = colors.muted,   italic = true })
hi("@text.title",           { fg = colors.fg_bright, bold = true })
hi("@text.literal",         { fg = colors.fg_dim })
hi("@text.uri",             { fg = colors.accent,  underline = true })
hi("@text.emphasis",        { italic = true })
hi("@text.strong",          { bold = true })

-- Telescope
hi("TelescopeNormal",         { fg = colors.fg_dim,   bg = colors.bg })
hi("TelescopeBorder",         { fg = colors.border,   bg = colors.bg })
hi("TelescopePromptNormal",   { fg = colors.fg,       bg = colors.bg_alt })
hi("TelescopePromptBorder",   { fg = colors.border,   bg = colors.bg_alt })
hi("TelescopePromptTitle",    { fg = colors.fg_bright, bold = true })
hi("TelescopePreviewTitle",   { fg = colors.accent,   bold = true })
hi("TelescopeResultsTitle",   { fg = colors.muted })
hi("TelescopeSelection",      { fg = colors.fg,       bg = colors.bg_dim })
hi("TelescopeSelectionCaret", { fg = colors.accent })
hi("TelescopeMatching",       { fg = colors.fg_bright, bold = true })

-- nvim-tree / neo-tree
hi("NvimTreeNormal",        { fg = colors.fg_dim,   bg = colors.bg })
hi("NvimTreeFolderName",    { fg = colors.accent })
hi("NvimTreeOpenedFolderName", { fg = colors.accent, bold = true })
hi("NvimTreeRootFolder",    { fg = colors.fg_bright, bold = true })
hi("NvimTreeIndentMarker",  { fg = colors.border })
hi("NvimTreeGitDirty",      { fg = colors.accent })
hi("NvimTreeGitNew",        { fg = colors.fg_dim })
hi("NvimTreeGitDeleted",    { fg = colors.warm })

-- Which-key
hi("WhichKey",          { fg = colors.accent })
hi("WhichKeyGroup",     { fg = colors.fg_bright, bold = true })
hi("WhichKeyDesc",      { fg = colors.fg_dim })
hi("WhichKeySeparator", { fg = colors.border })
hi("WhichKeyFloat",     { bg = colors.bg_alt })
