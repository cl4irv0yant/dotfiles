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

  null_ls.setup {
    debug = true,
    sources = {
      diagnostics.mypy,
      diagnostics.ruff,
      formatting.black,
      diagnostics.phpstan.with({
        command = "phpstan",
      }),
---      diagnostics.phpstan.with {
---        command = "phplint",
---        args = { "vendor/bin/phpstan", "analyze", "--error-format", "json", "--no-progress", "$FILENAME" },
---        timeout = 10000,
---        to_temp_file = false
---      },
---      diagnostics.phpmd.with({
---        command = "phplint",
---        args = { "phpmd", "$FILENAME", "json", "codesize,cleancode,controversial,design,naming,unusedcode" },
---      }),
---      formatting.phpcsfixer.with({
---        command = "phplint",
---        args = { "php-cs-fixer", "--no-interaction", "--quiet", "fix", "$FILENAME" },
---      }),
---      formatting.phpcbf.with({
---        command = "phplint",
---        args = { "phpcbf", "--standard=PSR12", "$FILENAME" },
---      }),
---     diagnostics.psalm.with({
---       command = "phplint",
---       args = { "psalm", "--output-format=json", "--no-cache", "$FILENAME", "2>/dev/null" },
---     }),
    }
  }
end

return M

