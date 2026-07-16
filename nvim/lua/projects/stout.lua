return {
  match = { '/Code/stout$', '/Code/stout%-', '/Code/stout/.claude/worktrees/' },
  setup = function()
    vim.lsp.config('rust_analyzer', {
      settings = {
        ['rust-analyzer'] = {
          check = {
            command = 'check',
          },
        },
      },
    })
  end,
}
