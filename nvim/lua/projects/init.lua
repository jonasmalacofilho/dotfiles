-- Per-project settings loader.
--
-- Each file in this directory (except init.lua) should return a table with:
--   match: a Lua pattern (or list of patterns) tested against the cwd
--   setup: a function called when a pattern matches
--
-- Example (stout.lua):
--   return {
--     match = '/Code/stout$',  -- or { '/Code/stout$', '/Code/stout%-' }
--     setup = function()
--       vim.lsp.config('rust_analyzer', { ... })
--     end,
--   }

local cwd = vim.fn.getcwd()
local config_dir = vim.fn.stdpath('config') .. '/lua/projects'

for _, file in ipairs(vim.fn.glob(config_dir .. '/*.lua', false, true)) do
  local name = vim.fn.fnamemodify(file, ':t:r')
  if name ~= 'init' then
    local ok, project = pcall(require, 'projects.' .. name)
    if ok and project.match then
      local patterns = type(project.match) == 'table' and project.match or { project.match }
      for _, pattern in ipairs(patterns) do
        if cwd:match(pattern) then
          project.setup()
          break
        end
      end
    end
  end
end
