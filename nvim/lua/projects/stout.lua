return {
  match = { '/Code/stout$', '/Code/stout%-' },
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
