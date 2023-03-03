-- Server configuration information can be found at:
-- <https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md>.

local lsp = require("lsp-zero")

lsp.preset("recommended")

lsp.ensure_installed({
  "lua_ls",
})

--[[
Rust.

Set up the server and keymaps using lsp-zero, then pass it to rust-tools for
inlay hints (and, in the future, other goodies).
--]]

local rust_tools = require("rust-tools")

local rust_lsp = lsp.build_options("rust_analyzer", {
  -- TODO: set up bindings for code and hover actions from rust-tools.
  settings = {
    ["rust-analyzer"] = {
      imports = {
        granularity = {
          group = "module",
        },
      },
      check = {
        command = "clippy",
      },
    }
  },
  -- Manage the rust-analyzer binary with rustup, not Mason.
  cmd = { "rustup", "run", "stable", "rust-analyzer" },
})

rust_tools.setup({
  tools = {
    runnables = {
      use_telescope = true,
    },
    inlay_hints = {
      auto = true,
      show_parameter_hints = false,
      parameter_hints_prefix = "",
      other_hints_prefix = "",
    },
    hover_actions = {
      auto_focus = true,
    }
  },
  server = rust_lsp,
})

--[[
Lua, mostly for Neovim.
--]]

lsp.configure("lua_ls", {
  settings = {
    Lua = {
      telemetry = {
        enable = false,
      },
    },
  },
})

--[[
Other LSP servers.
--]]

lsp.configure("eslint")

--[[
Finishing touches and setup.
--]]

lsp.setup()

-- FIXME: set only in LSP-attached buffers.
vim.keymap.set("n", "<leader>F", function() vim.lsp.buf.format() end, { desc = "Format the current buffer" })
