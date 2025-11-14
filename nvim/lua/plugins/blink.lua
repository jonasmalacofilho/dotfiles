return {
  'saghen/blink.cmp',
  version = '1.*',
  dependencies = {
    -- Set up LuaLS for editing Neovim config files.
    'folke/lazydev.nvim',
    -- Snippets for the snippet source.
    'rafamadriz/friendly-snippets',
  },

  --- @module 'blink.cmp'
  --- @type blink.cmp.Config
  opts = {},

  opts_extend = { 'sources.default' },
}
