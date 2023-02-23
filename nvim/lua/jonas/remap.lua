-- Move lines up or down.
vim.keymap.set("v", "J", ":m '>+1<CR>gv", { desc = "Move lines down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv", { desc = "Move lines up" })

-- Override shift motions in visual mode to remain in that mode.
vim.keymap.set("v", "<", "<gv", { desc = "Shift lines leftwards" })
vim.keymap.set("v", ">", ">gv", { desc = "Shift lines rightwards" })

-- Override Y to yank from cursor to EOL, like C and D.
vim.keymap.set("n", "Y", "y$", { desc = "Yank from cursor to EOL" })

-- Delete to the black hole register.
vim.keymap.set({"n", "v"}, "<leader>d", [["_d]], { desc = "Delete with black hole register" })

-- Yank and put using the system clipboard.
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]], { desc = "Yank to clipboard" })
vim.keymap.set({"n", "v"}, "<leader>p", [["+p]], { desc = "Put (paste) after from clipboard" })
vim.keymap.set({"n", "v"}, "<leader>P", [["+P]], { desc = "Put (paste) before from clipboard" })
vim.keymap.set("n", "<leader>Y", [["+y$]], { desc = "Yank to clipboard from cursor to EOL" })

-- Select text that was just pasted.
vim.keymap.set("n", "gV", "`[v`]", { desc = "Select just pasted text" })

-- Move up/down: if count is zero, move in display lines, else move linewise.
vim.keymap.set("", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, desc = "Smartly move downward" })
vim.keymap.set("", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, desc = "Smartly move upward" })

-- Formatting.
vim.keymap.set("n", "<leader>$", [[:%s/\s\+$//<CR>]], { desc = "Trim trailing whitespace" })

-- Buffer, window and tab manipulation.
vim.keymap.set("n", "<leader>b", ":b#<CR>", { desc = "Switch to previous buffer" })
vim.keymap.set("n", "<leader>s", ":sp<CR>", { desc = "Split window horizontally" })
vim.keymap.set("n", "<leader>v", ":vsp<CR>", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>t", ":tabe<CR>", { desc = "Open a new, empty, tab page" })
vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "Close window" })
vim.keymap.set("n", "<leader>Q", ":cq<CR>", { desc = "Close all window" })
vim.keymap.set("n", "<leader>w", ":update<CR>", { desc = "Write file if modified" })
vim.keymap.set("n", "<leader>x", ":x<CR>", { desc = "Write file if modified and close window" })

-- Sorting.
vim.keymap.set("v", "<leader>A", ":'<,'>sort<CR>", { desc = "Sort selection ascending" })
vim.keymap.set("v", "<leader>D", ":'<,'>sort!<CR>", { desc = "Sort selection descending" })

-- Spell checking.
vim.keymap.set("n", "<leader>ae", ":setlocal spell spelllang=en_us<CR>", { desc = "Spell check in en_US" })
vim.keymap.set("n", "<leader>ap", ":setlocal spell spelllang=pt_br<CR>", { desc = "Spell check in pt_BR" })
vim.keymap.set("n", "<leader>aa", ":setlocal spell spelllang=en_us,pt_br<CR>", { desc = "Spell check in en_US + pt_BR" })
vim.keymap.set("n", "<leader>al", ":setlocal nospell<CR>", { desc = "Don't spell check" })

-- Quickfix list navigation.
vim.keymap.set("n", "<C-j>", ":cprev<CR>zz")
vim.keymap.set("n", "<C-k>", ":cnext<CR>zz")
vim.keymap.set("n", "<leader>j", ":lprev<CR>zz")
vim.keymap.set("n", "<leader>k", ":lnext<CR>zz")
