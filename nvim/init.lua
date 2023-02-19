--[[

Jonas' 2023 Neovim configuration.

Probably requires nvim >= 0.8.

Based on:

- ThePrimeagen's 0 to LSP: Neovim RC From Scratch (2022):
  <https://www.youtube.com/watch?v=w7i4amO_zaE>.

- TJ DeVries's Effective Neovim: Instant IDE (2022) and kickstart.nvim:
  <https://www.youtube.com/watch?v=stqUbv-5u2s>,
  <https://github.com/nvim-lua/kickstart.nvim>.

- And, of course, my previous configuration:
  <https://github.com/jonasmalacofilho/dotfiles/tree/e9872add38a7/nvim>.

--]]

-- The order is relevant (e.g. mapleader must be set before plugins are required):
require("jonas.set")
require("jonas.remap")
require("jonas.packer")
