local M = {
  "jose-elias-alvarez/null-ls.nvim",
  event = "BufReadPre",
  commit = "60b4a7167c79c7d04d1ff48b55f2235bf58158a7",
  dependencies = {
    { "nvim-lua/plenary.nvim", commit = "9a0d3bf7b832818c042aaf30f692b081ddd58bd9", lazy = true, },
  },
}

function M.config()
  local null_ls = require "null-ls"
  -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
  local formatting = null_ls.builtins.formatting
  -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
  local diagnostics = null_ls.builtins.diagnostics


  -- https://github.com/prettier-solidity/prettier-plugin-solidity
  null_ls.setup {
    debug = true,
    sources = {
      formatting.prettier.with {
        extra_filetypes = { "toml" },
        extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" },
      },
      formatting.black.with { extra_args = { "--fast" } },
      formatting.stylua,
      formatting.google_java_format,
      diagnostics.flake8,
      diagnostics.phpcs.with({
        command = "phpcs",
        args = { "--standard=PSR12", "--report=json", "-q", "-s", "--runtime-set", "ignore_warnings_on_exit", "1", "--runtime-set", "ignore_errors_on_exit", "1", "$FILENAME"},
        }),
      diagnostics.phpmd.with(
        {
          command = "phpmd",
          args = { "$FILENAME", "json", "codesize,cleancode,controversial,design,naming,unusedcode" }
        }
      ),
      diagnostics.phpstan.with {
        command = "phpstan",
        args = { "analyze", "--error-format", "json", "--no-progress", "--level", "5", "$FILENAME" },
      }
         }}
end

return M
