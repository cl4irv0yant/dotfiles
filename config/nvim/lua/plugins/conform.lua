return {
  'stevearc/conform.nvim',
  opts = {
    notify_on_error = true,
    format_on_save = function(bufnr)
      local disable_filetypes = { c = true, cpp = true }
      return {
        timeout_ms = 2000,
        lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
      }
    end,
    formatters_by_ft = {
      lua = { 'stylua' },
      python = { 'isort', 'black', 'ruff' },
      kotlin = { 'ktlint' },
      sh = { 'shfmt' },
      css = { 'prettierd' },
      javascript = { { 'prettierd', 'prettier' } },
    },
  },
}
