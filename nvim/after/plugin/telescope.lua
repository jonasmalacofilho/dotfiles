local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope: files' })
vim.keymap.set('n', '<leader>fc', builtin.commands, { desc = 'Telescope: commands' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope: live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope: buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope: help' })
vim.keymap.set('n', '<leader>fm', builtin.keymaps, { desc = 'Telescope: keymaps' })

require('telescope').load_extension('fzf')
