--[[

=====================================================================
=====================================================================
========                                    .-----.          ========
========         .----------------------.   | === |          ========
========         |.-""""""""""""""""""-.|   |-----|          ========
========         || Based on:          ||   | === |          ========
========         ||   KICKSTART.NVIM   ||   |-----|          ========
========         ||                    ||   | === |          ========
========         || Principles:*       ||   | === |          ========
========         ||   robust, modern,  ||   |-----|          ========
========         ||   lean, convenient ||   |:::::|          ========
========         |'-..................-'|   |____o|          ========
========         `"")----------------(""`   ___________      ========
========        /::::::::::|  |::::::::::\  \ no mouse \     ========
========       /:::========|  |==hjkl==:::\  \ required \    ========
========      '""""""""""""'  '""""""""""""'  '""""""""""'   ========
========                                                     ========
========      https://github.com/nvim-lua/kickstart.nvim     ========
=====================================================================
=====================================================================

        * Not yet lean, and thus, not as robust as possible.

--]]

-- Set the leader key (must happen before plugins are loaded).
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Using a Nerd Font.
vim.g.have_nerd_font = true

-- [[ Setting options ]]
-- See: `:help vim.opt`, `:help option-list`

-- Always use confirm with :q, :qa, :w, etc.
vim.opt.confirm = true

-- Make line numbers default.
vim.opt.number = true
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example.
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line.
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
vim.opt.clipboard = 'unnamedplus'

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term.
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default.
vim.opt.signcolumn = 'yes'

-- Decrease update time for `CursorHold`, but also affets how often swap files are written (see `:h
-- crash-recovery`).
vim.o.updatetime = 1000

-- Decrease mapped sequence wait time (displays which-key popup sooner).
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened.
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
vim.opt.list = true
vim.opt.listchars = { tab = '› ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type, including off-screen results.
vim.opt.inccommand = 'split'

-- Show which line your cursor is on.
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 3

-- Default to 100-column lines.
vim.opt.textwidth = 100
vim.opt.colorcolumn = { '+1' }

-- Default/preferred indentation (possibly overwritten by autocmds/editorconfig).
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.tabstop = 8

-- Show filename on window title.
vim.opt.title = true

-- Enable break indent
vim.opt.breakindent = true

-- Spell by default (assumes undercurls are available).
vim.opt.spell = false
vim.opt.spelllang = 'en_us'
vim.opt.spellfile = '~/.config/nvim/spell/personal.utf-8.add'

-- [[ Basic Keymaps ]]
-- See `:help vim.keymap.set()`

-- Start typing a command without the shift key.
vim.keymap.set({ 'n', 'v' }, '<leader>;', ':', { desc = 'Start typing a command' })

-- Set highlight on search, but clear on pressing <Esc> in normal mode.
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Additional diagnostic keymaps.
-- (`vim.diagnostic.open_float` is also mapped by default to C-W_d)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
--
-- TODO: remove if unused after a couple of weeks.
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Buffer, window and tab manipulation.
vim.keymap.set('n', '<leader>b', ':b#<CR>', { desc = 'Switch to previous buffer' })

-- Override shift motions in visual mode to remain in that mode.
vim.keymap.set('v', '<', '<gv', { desc = 'Shift lines leftwards' })
vim.keymap.set('v', '>', '>gv', { desc = 'Shift lines rightwards' })

-- Select text that was just pasted.
vim.keymap.set('n', 'gV', '`[v`]', { desc = 'Select just pasted text' })

-- Move down/up through with the parts of wrapped lines. Specifically, if
-- count is zero, move in display lines, else move linewise.
vim.keymap.set('', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, desc = 'Smartly move downward' })
vim.keymap.set('', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, desc = 'Smartly move upward' })

-- Enable horizontal scrolling with the mouse wheel.
vim.keymap.set('n', '<S-ScrollWheelDown>', 'z6l')
vim.keymap.set('n', '<S-ScrollWheelUp>', 'z6h')

-- Delete the word before the cursor with C-BS.
vim.keymap.set({ 'i', 'c' }, '<C-BS>', '<C-w>', { desc = 'Delete the word before the cursor' })

-- Trim trailing whitespace.
vim.keymap.set('n', '<leader>$', [[:%s/\s\+$//<CR>]], { desc = 'Trim trailing whitespace' })

-- Spell checking.
vim.keymap.set('n', '<leader>ae', ':setlocal spell spelllang=en_us<CR>', { desc = 'Spell check in en_US' })
vim.keymap.set('n', '<leader>ap', ':setlocal spell spelllang=pt_br<CR>', { desc = 'Spell check in pt_BR' })
vim.keymap.set('n', '<leader>aa', ':setlocal spell spelllang=en_us,pt_br<CR>', { desc = 'Spell check in en_US + pt_BR' })
vim.keymap.set('n', '<leader>al', ':setlocal nospell<CR>', { desc = "Don't spell check" })

-- [[ Basic Autocommands ]]
-- See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text.
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Natively supported filetypes by Neovim:
-- - https://github.com/neovim/neovim/blob/master/runtime/lua/vim/filetype.lua
-- - $VIMRUNTIME/lua/vim/filetype.lua

-- Automatically enable spell checking for some file types.
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'gitcommit', 'markdown', 'tex' },
  desc = 'Automatically enable spell checking for some file types',
  group = vim.api.nvim_create_augroup('filetype-auto-spell-checking', { clear = true }),
  callback = function()
    vim.opt_local.spell = true
  end,
})

-- Indent these files with 2 spaces.
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'markdown', 'javascript*', 'typescript*', 'json*', 'html', 'css', 'lua', 'yaml' },
  desc = 'Automatically enable spell checking for some file types',
  group = vim.api.nvim_create_augroup('filetype-auto-spell-checking', { clear = true }),
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
-- See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info.
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
--
-- Plugins are grouped by category, and categories are sorted by importance.
--
-- Check the current status of the plugins:
--   :Lazy
--
-- Use `opts = {}` to force a plugin to be loaded. Configuration can be customized with `config`,
-- which takes `(_, opts)`.
--
require('lazy').setup({

  -- [[ Advanced syntax highlighting and indent ]]

  -- Highlight, edit, and navigate code.
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    opts = {
      ensure_installed = {
        'bash',
        'c',
        'diff', -- in particular, makes `git commit -v` colorful
        'fish',
        'javascript',
        'lua',
        'luadoc',
        'markdown',
        'python',
        'rust',
        'tsx',
        'typescript',
        'vim',
        'vimdoc',
      },
      -- Autoinstall languages that are not installed.
      auto_install = true,
      -- Use Treesitter for syntax highlighting.
      highlight = {
        enable = true,

        -- Disable when unbearably slow/laggy (can also be a function). Note that this reverts back
        -- to Vim's `syntax`, which is very limited. Can't you just clear (or disable) hlsearch?
        -- disable = { 'tsx', 'rust' },

        -- Keep  Vim's regex `syntax` system for ident on some languages (add to this list when
        -- experiencing "weird indenting issues"). But this can cause issues with the catppuccin
        -- theme.
        -- additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true },
      incremental_selection = { enable = true },
    },
    config = function(_, opts)
      -- [[ Configure Treesitter ]] See `:help nvim-treesitter`

      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup(opts)

      -- Additional nvim-treesiter modules to explore:
      -- - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
      -- - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
      -- - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    end,
  },

  -- Detect tabstop and shiftwidth automatically.
  'tpope/vim-sleuth',

  -- [[ Language Server Protocol and features ]]

  -- LSP Configuration & Plugins.
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      -- NOTE: passing `opts = {}` is the same as calling `require(...).setup({})`
      --
      -- Automatically install LSPs and related tools to stdpath for Neovim
      -- Mason must be loaded before its dependents so we need to set it up here.
      { 'mason-org/mason.nvim', opts = {} },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },

      { 'saghen/blink.cmp' },
    },
    config = function()
      --  This function gets run when an LSP attaches to a particular buffer.
      --  That is to say, every time a new file is opened that is associated with
      --  an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      --  function will be executed to configure the current buffer.
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame') -- old

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' }) -- old

          -- Find references for the word under your cursor.
          map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences') -- old

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation') -- old

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition') -- old

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration') -- old

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')
          map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols') -- old

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')
          map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols') -- old

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')
          map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition') -- old

          local client = vim.lsp.get_client_by_id(event.data.client_id)

          -- The following autocommands are used to highlight references of the word under your
          -- cursor when your cursor rests there for a little while. See `:help CursorHold` for
          -- information about when this is executed. When you move your cursor, the highlights will
          -- be cleared (the second autocommand).
          --
          -- Disabled because highlights are not very visible with the ayu theme.
          -- if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
          --   local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
          --   vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
          --     buffer = event.buf,
          --     group = highlight_augroup,
          --     callback = vim.lsp.buf.document_highlight,
          --   })
          --
          --   vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
          --     buffer = event.buf,
          --     group = highlight_augroup,
          --     callback = vim.lsp.buf.clear_references,
          --   })
          --
          --   vim.api.nvim_create_autocmd('LspDetach', {
          --     group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
          --     callback = function(event2)
          --       vim.lsp.buf.clear_references()
          --       vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
          --     end,
          --   })
          -- end

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end

          -- Revert my `gq` back to default/internal format, instead of LSP format.
          vim.opt.formatexpr = ''
        end,
      })

      -- Diagnostic Config.
      -- See :help vim.diagnostic.Opts
      -- Taken from kickstart.nvim but disabled because, as is, it's too noisy.
      -- vim.diagnostic.config {
      --   severity_sort = true,
      --   float = { border = 'rounded', source = 'if_many' },
      --   underline = { severity = vim.diagnostic.severity.ERROR },
      --   signs = vim.g.have_nerd_font and {
      --     text = {
      --       [vim.diagnostic.severity.ERROR] = '󰅚 ',
      --       [vim.diagnostic.severity.WARN] = '󰀪 ',
      --       [vim.diagnostic.severity.INFO] = '󰋽 ',
      --       [vim.diagnostic.severity.HINT] = '󰌶 ',
      --     },
      --   } or {},
      --   virtual_text = {
      --     source = 'if_many',
      --     spacing = 2,
      --     format = function(diagnostic)
      --       local diagnostic_message = {
      --         [vim.diagnostic.severity.ERROR] = diagnostic.message,
      --         [vim.diagnostic.severity.WARN] = diagnostic.message,
      --         [vim.diagnostic.severity.INFO] = diagnostic.message,
      --         [vim.diagnostic.severity.HINT] = diagnostic.message,
      --       }
      --       return diagnostic_message[diagnostic.severity]
      --     end,
      --   },
      -- }

      -- LSP servers and clients are able to communicate to each other what features they support.
      -- By default, Neovim doesn't support everything that is in the LSP specification. When you
      -- add blink.cmp, luasnip, etc. Neovim now has *more* capabilities. So, in theory, we need to
      -- create new capabilities with blink.cmp, and then broadcast that to the servers.
      --
      -- However, blink.cmp now extends capabilites by default from its internal code[1]. But,
      -- previously, the following line was required by the completion plugin that preceeded
      -- blink.cmp.
      --
      --   local capabilities = require("blink.cmp").get_lsp_capabilities()
      --
      -- [1]: https://github.com/Saghen/blink.cmp/blob/102db2f5996a/plugin/blink-cmp.lua

      -- Language server configuration.
      --
      -- Comprised by the following sub-tables:
      --
      -- - mason: servers automatically installed with mason
      -- - others: other servers available on the system
      --
      -- Both tables have an identical structure of language server names as keys and a table of
      -- language server (override) configuration as values. The available keys are:
      --
      -- - cmd (table): Override the default command used to start the server
      -- - filetypes (table): Override the default list of associated filetypes for the server
      -- - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      -- - settings (table): Override the default settings passed when initializing the server.
      --
      -- See `:help lspconfig-all` for a list of all the pre-configured LSPs.
      ---@class LspServersConfig
      ---@field mason table<string, vim.lsp.Config>
      ---@field others table<string, vim.lsp.Config>
      local servers = {
        mason = {
          rust_analyzer = {
            -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
            -- https://rust-analyzer.github.io/manual.html
            -- TODO: look into https://github.com/mrcjkb/rustaceanvim for a more advanced setup
            -- TODO: support workspace/project-specific settings (see rustaceanvim)
            settings = {
              ['rust-analyzer'] = {
                imports = {
                  granularity = {
                    enforce = true,
                    group = 'module',
                  },
                },
                -- Can be much slower in larger projects; `clippy` itself is slower than `check`,
                -- but RA also seems to more effectively reuse computations with `check`.
                -- check = {
                --   command = 'clippy',
                -- },
              },
            },
          },

          lua_ls = {
            settings = {
              Lua = {
                completion = {
                  callSnippet = 'Replace',
                },
                diagnostics = { disable = { 'missing-fields' } },
              },
            },
          },

          -- For many servers and setups, the defaults work just fine.
          eslint = {},
          tailwindcss = {},
          ts_ls = {},
          pyright = {},
          clangd = {},
        },
        others = {},
      }

      -- Ensure the servers and tools managed by Mason (above) are installed.
      --
      -- You can add other tools here that you want Mason to install for you, so that they are
      -- available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers.mason or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      -- Either merge all additional server configs from the `servers.mason` and `servers.others` tables
      -- to the default language server configs as provided by nvim-lspconfig or
      -- define a custom server config that's unavailable on nvim-lspconfig.
      for server, config in pairs(vim.tbl_extend('keep', servers.mason, servers.others)) do
        if not vim.tbl_isempty(config) then
          vim.lsp.config(server, config)
        end
      end

      -- After configuring our language servers, we now enable them
      require('mason-lspconfig').setup {
        ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
        automatic_enable = true, -- automatically run vim.lsp.enable() for all servers that are installed via Mason
      }

      -- Manually run vim.lsp.enable for all language servers that are *not* installed via Mason
      if not vim.tbl_isempty(servers.others) then
        vim.lsp.enable(vim.tbl_keys(servers.others))
      end
    end,
  },

  -- Autoformat.
  {
    'stevearc/conform.nvim',
    lazy = false,
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_fallback = true }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      formatters_by_ft = {
        html = { 'prettier' },
        javascript = { 'prettier' },
        javascriptreact = { 'prettier' },
        json = { 'prettier' },
        json5 = { 'prettier' },
        jsonc = { 'prettier' },
        lua = { 'stylua' },
        markdown = { 'prettier' },
        python = { 'black' },
        rust = { lsp_format = 'fallback' },
        typescript = { 'prettier' },
        typescriptreact = { 'prettier' },
        yaml = { 'prettier' },
      },
      format_on_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end

        -- Since most filetypes don't have trully cannonical formatters, only enable format_on_save
        -- in a few cases.
        local enabled = {
          rust = true,
        }

        if not enabled[vim.bo[bufnr].filetype] then
          return
        end

        return {}
      end,
    },
  },

  -- [[ Convenience ]]

  -- Fuzzy Finder (files, lsp, etc).
  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      -- Telescope is a fuzzy finder that comes with a lot of different things that
      -- it can fuzzy find! It's more than just a "file finder", it can search
      -- many different aspects of Neovim, your workspace, LSP, and more!
      --
      -- The easiest way to use Telescope, is to start by doing something like:
      --  :Telescope help_tags
      --
      -- After running this command, a window will open up and you're able to
      -- type in the prompt window. You'll see a list of `help_tags` options and
      -- a corresponding preview of the help.
      --
      -- Two important keymaps to use while in Telescope are:
      --  - Insert mode: <c-/>
      --  - Normal mode: ?
      --
      -- This opens a window that shows you all of the keymaps for the current
      -- Telescope picker. This is really useful to discover what Telescope can
      -- do as well as how to actually do it!

      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require('telescope').setup {
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        --
        defaults = {
          mappings = {
            i = {
              -- Not sure why it needs to be C-s-w, instead of C-w, like in "normal" insert mode.
              ['<C-BS>'] = { '<C-s-w>', type = 'command', opts = { desc = 'Delete the word before the cursor' } },
            },
          },
        },
        -- pickers = {}
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      vim.keymap.set('n', '<leader>sf', function()
        builtin.find_files { hidden = true }
      end, { desc = '[S]earch [F]iles' })

      vim.keymap.set('n', '<leader>sF', function()
        builtin.find_files { hidden = true, no_ignore = true }
      end, { desc = '[S]earch All [F]iles' })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },

  -- Integrate with ranger.
  {
    'kevinhwang91/rnvimr',
    event = 'VimEnter',
    config = function()
      vim.keymap.set('n', '<leader>x', ':RnvimrToggle<cr>', { desc = 'E[x]plore files with ranger' })
    end,
  },

  -- Useful plugin to show you pending keybinds.
  {
    'folke/which-key.nvim',
    event = 'VimEnter', -- late, but before all UI elements are loaded
    config = function()
      require('which-key').setup()

      -- Document existing key chains
      require('which-key').add {
        { '<leader>a', group = 'Spell check ([A]bc icon)' },
        { '<leader>s', group = '[S]earch' },
      }
    end,
  },

  -- Highlight todo, notes, etc in comments.
  --
  -- Some of the supported keywords:
  --
  -- NOTE:
  -- SAFETY:
  -- TODO:
  -- WARN:
  -- FIXME:
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      signs = false,
      merge_keywords = false,
      keywords = {
        PERF = { alt = { 'PERFORMANCE', 'OPTIMIZE' } },
        NOTE = { color = 'test', alt = { 'INFO', 'QUESTION' } },
        SAFETY = { color = 'hint', alt = { 'TIP' } },
        TODO = { color = 'info', alt = { 'IMPORTANT', 'TEST' } },
        WARN = { color = 'warning', alt = { 'WARNING', 'HACK', 'XXX' } },
        FIXME = { color = 'error', alt = { 'BUG', 'CAUTION' } },
      },
    },
    config = function(_, opts)
      local todo = require 'todo-comments'
      todo.setup(opts)

      vim.keymap.set('n', ']t', function()
        todo.jump_next()
      end, { desc = 'Next todo comment' })
      vim.keymap.set('n', '[t', function()
        todo.jump_prev()
      end, { desc = 'Previous todo comment' })

      vim.keymap.set('n', '<leader>st', ':TodoTelescope<CR>', { desc = '[S]earch [T]ODO, FIXME and other notes' })
    end,
  },

  -- Adds git related signs to the gutter, as well as utilities for managing changes.
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  -- [[ mini.nvim collection ]]

  {
    'echasnovski/mini.nvim',
    config = function()
      -- Simple statusline.
      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }

      -- Better Around/Inside textobjects.
      --
      -- - va)  - [V]isually select [A]round [)]paren
      -- - yinq - [Y]ank [I]nside [N]ext [']quote
      -- - ci'  - [C]hange [I]nside [']quote
      --
      -- NOTE: documented to result in some false positives, and to be less
      -- precise than a parser (i.e. treesitter).
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.).
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      --
      -- NOTE: makes `s` as `c` unusable.
      require('mini.surround').setup()
    end,
  },

  -- TODO: tpope/vim-eunuch?

  -- Additional Kickstart plugins available.
  -- require 'kickstart.plugins.debug',
  -- require 'kickstart.plugins.indent_line',
  -- require 'kickstart.plugins.lint',
  -- require 'kickstart.plugins.autopairs',
  -- require 'kickstart.plugins.neo-tree',
  -- require 'kickstart.plugins.gitsigns', -- adds gitsigns keymaps

  -- Load more plugins, config, etc.
  -- See: `:help lazy.nvim-lazy.nvim-structuring-your-plugins`
  { import = 'plugins' },
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- vim: ts=2 sts=2 sw=2 et
