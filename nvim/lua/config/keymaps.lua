-- lua/config/keymaps.lua
-- General keymaps. Plugin-specific keymaps live next to their plugin spec
-- in lua/plugins/*.lua (via the `keys` table) so they only load when needed.

local map = vim.keymap.set
local silent = { silent = true }
local function opts(desc, extra)
  return vim.tbl_extend("force", { desc = desc, silent = true }, extra or {})
end

-- Better up/down on wrapped lines
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>", opts("Clear search highlight"))

-- Window navigation
map("n", "<C-h>", "<C-w>h", opts("Go to left window"))
map("n", "<C-j>", "<C-w>j", opts("Go to lower window"))
map("n", "<C-k>", "<C-w>k", opts("Go to upper window"))
map("n", "<C-l>", "<C-w>l", opts("Go to right window"))

-- Resize windows with arrows
map("n", "<C-Up>", "<cmd>resize +2<CR>", opts("Increase window height"))
map("n", "<C-Down>", "<cmd>resize -2<CR>", opts("Decrease window height"))
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", opts("Decrease window width"))
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", opts("Increase window width"))

-- Buffer navigation
map("n", "<S-h>", "<cmd>bprevious<CR>", opts("Previous buffer"))
map("n", "<S-l>", "<cmd>bnext<CR>", opts("Next buffer"))
map("n", "<leader>bd", "<cmd>bdelete<CR>", opts("Delete buffer"))

-- Move lines up/down in visual mode
map("v", "J", ":m '>+1<CR>gv=gv", opts("Move selection down"))
map("v", "K", ":m '<-2<CR>gv=gv", opts("Move selection up"))

-- Keep cursor centered on half-page jumps and search
map("n", "<C-d>", "<C-d>zz", silent)
map("n", "<C-u>", "<C-u>zz", silent)
map("n", "n", "nzzzv", silent)
map("n", "N", "Nzzzv", silent)

-- Paste without overwriting register in visual mode
map("x", "<leader>p", [["_dP]], opts("Paste without yanking"))

-- Delete without overwriting register
map({ "n", "v" }, "<leader>d", [["_d]], opts("Delete without yanking"))

-- Indent and keep selection
map("v", "<", "<gv", silent)
map("v", ">", ">gv", silent)

-- Quick save / quit
map("n", "<leader>w", "<cmd>write<CR>", opts("Save file"))
map("n", "<leader>q", "<cmd>quit<CR>", opts("Quit window"))

-- Split management
map("n", "<leader>sv", "<C-w>v", opts("Split window vertically"))
map("n", "<leader>sh", "<C-w>s", opts("Split window horizontally"))
map("n", "<leader>se", "<C-w>=", opts("Equalize window sizes"))
map("n", "<leader>sx", "<cmd>close<CR>", opts("Close current split"))

-- Diagnostics
map("n", "[d", vim.diagnostic.goto_prev, opts("Previous diagnostic"))
map("n", "]d", vim.diagnostic.goto_next, opts("Next diagnostic"))
map("n", "<leader>xx", vim.diagnostic.open_float, opts("Show line diagnostics"))
map("n", "<leader>xl", vim.diagnostic.setloclist, opts("Diagnostics to loclist"))
