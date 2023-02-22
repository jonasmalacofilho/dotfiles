require("Comment").setup({
  toggler = {
    ---Line-comment toggle keymap
    line = '<leader>cc',
    ---Block-comment toggle keymap
    block = '<leader><S-c><S-c>',
  },
  ---LHS of operator-pending mappings in NORMAL and VISUAL mode
  opleader = {
    ---Line-comment keymap
    line = '<leader>c',
    ---Block-comment keymap
    block = '<leader><S-c>',
  },
  ---LHS of extra mappings
  extra = {
    ---Add comment on the line above
    above = '<leader>cO',
    ---Add comment on the line below
    below = '<leader>co',
    ---Add comment at the end of line
    eol = '<leader>cA',
  },
})
