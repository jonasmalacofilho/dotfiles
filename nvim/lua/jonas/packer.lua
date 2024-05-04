--[[

Set up plugins using packer.nvim.

TODO: debugger

--]]

-- Automatically bootstrapping (cloning) of packer.nvim.
-- Copied from: <https://github.com/wbthomason/packer.nvim#bootstrapping>.
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
  -- Make the package manager manage the package manager.
  use 'wbthomason/packer.nvim'

  -- Fuzzy find everything...
  use {
    'nvim-telescope/telescope.nvim', branch = '0.1.x',
    requires = { 'nvim-lua/plenary.nvim' }
  }
  -- ... quidckly and with support for fzf syntax.
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

  -- Select a color scheme.
  use {
    'ellisonleao/gruvbox.nvim',
    config = function() vim.cmd.colorscheme('gruvbox') end
  }

  -- Efficient syntax-based highlighting, indenting, jumps, etc.
  use {
    'nvim-treesitter/nvim-treesitter',
    run = function()
      local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
      ts_update()
    end
  }

  -- Undo history as a tree.
  use 'mbbill/undotree'

  -- Git & GitHub tools.
  use 'tpope/vim-fugitive'
  -- TODO (maybe): use 'tpope/vim-rhubarb'

  -- Statusline.
  -- REQUIRES: patched Nerd Fonts.
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }

  -- Commenting code.
  use 'numToStr/Comment.nvim'

  -- Ranger file manager integration, replacing Netrw.
  --
  -- REQUIRES: ranger, pynvim and ueberzug.
  --
  -- As the latest release of ranger is missing a couple of important fixes:
  --
  -- - ranger/ranger@2241cac89953 ("xdg-open is not compatible with the -- convention")
  -- - ranger/ranger@f65e6f08bcf6 ("Fix crashes when deleting to trash")
  --
  -- it's probably best to install it from git.
  --
  -- To replace Netrw, we need to set g:rnvimr_enable_ex *before* the rnvimr loads. But 
  -- a `setup` function with packer implies `opt = true`, which wont work with rnvimr.
  vim.g.rnvimr_enable_ex = 1
  use {
    'kevinhwang91/rnvimr',
  }

  -- Convenience functions for common file management actions.
  --
  -- A sudo askpass helper is necessary for :SudoEdit/:SudoWrite and should be specified in
  -- /etc/sudo.conf. For example:
  --
  --   Path askpass /usr/lib/git-core/git-gui--askpass
  --
  -- Note that git-gui--askpass requires tk (for the wish command).
  use 'tpope/vim-eunuch'

  -- Basic LSP setup. Also installs mason.
  -- TODO: simplify.
  use {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v1.x',
    requires = {
      -- LSP Support
      {'neovim/nvim-lspconfig'},             -- Required
      {'williamboman/mason.nvim'},           -- Optional
      {'williamboman/mason-lspconfig.nvim'}, -- Optional

      -- Autocompletion
      {'hrsh7th/nvim-cmp'},         -- Required
      {'hrsh7th/cmp-nvim-lsp'},     -- Required
      {'hrsh7th/cmp-buffer'},       -- Optional
      {'hrsh7th/cmp-path'},         -- Optional
      {'saadparwaiz1/cmp_luasnip'}, -- Optional
      {'hrsh7th/cmp-nvim-lua'},     -- Optional

      -- Snippets
      {'L3MON4D3/LuaSnip'},             -- Required
      {'rafamadriz/friendly-snippets'}, -- Optional
    }
  }

  -- Rust goodies, including a custom LSP setup with inlay hints.
  use {
    'simrat39/rust-tools.nvim',
    requires = {
      {'neovim/nvim-lspconfig'}
    }
  }

  -- Automatically set up my configuration (only) after cloning packer.nvim.
  -- Keep this at the end, after all plugins.
  if packer_bootstrap then
    require('packer').sync()
  end
end)
