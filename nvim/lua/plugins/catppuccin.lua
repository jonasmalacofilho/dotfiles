return {
  'catppuccin/nvim',
  name = 'catppuccin',
  priority = 1000,

  --- @module 'catppuccin'
  --- @type CatppuccinOptions
  opts = {
    -- Don't offset colors in kitty and let it control background transparency;
    -- transparent_background also crates some weird artifacts around LSP statuses .
    -- https://github.com/catppuccin/nvim/blob/da33755d00e0/lua/catppuccin/palettes/init.lua#L9-L28
    kitty = false,

    float = {
      solid = true,
    },
    auto_integrations = true,
  },

  config = function(_, opts)
    require('catppuccin').setup(opts)
    vim.cmd.colorscheme 'catppuccin'
  end,
}
