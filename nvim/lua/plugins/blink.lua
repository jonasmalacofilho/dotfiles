return {
  'saghen/blink.cmp',
  version = '1.*', -- v2 requires blink.lib and that's "not ready for us" as of April 2026
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
