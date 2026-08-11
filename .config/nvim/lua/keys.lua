--[[ keys.lua ]]

local ops = { noremap = true, silent = true }
local function inoremap(key, com) vim.keymap.set('i', key, com, ops) end
local function nnoremap(key, com) vim.keymap.set('n', key, com, ops) end
local function tnoremap(key, com) vim.keymap.set('t', key, com, ops) end

-- utility binds
inoremap("jj", "<Esc>")
tnoremap("<C-t>", [[<C-\><C-n>]])

-- window navigation and manipulation binds
nnoremap("<leader>vs", "<cmd>vs<cr>")
nnoremap("<leader>hs", "<cmd>split<cr>")
nnoremap("<leader>t", "<cmd>tabnew<cr>")

nnoremap("<A-h>", "<cmd>wincmd h<cr>")
nnoremap("<A-j>", "<cmd>wincmd j<cr>")
nnoremap("<A-k>", "<cmd>wincmd k<cr>")
nnoremap("<A-l>", "<cmd>wincmd l<cr>")
nnoremap("<A-=>", "<cmd>wincmd =<cr>")

-- buffer manipulation shortcuts
nnoremap("<leader>q", "<cmd>q<cr>")
nnoremap("<leader>w", "<cmd>w<cr>")
nnoremap("<leader>aq", "<cmd>qa<cr>")
