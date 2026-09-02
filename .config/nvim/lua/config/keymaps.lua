local map = vim.keymap.set

-- Resize window using <ctrl> arrow keys
map("n", "<M-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<M-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<M-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<M-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- Telescope
map("n", "D-p", ":Telescope find_files<cr>", { desc = "Find files" })
map("n", "D-f", ":Telescope live_grep<cr>",  { desc = "Code Search" })

