local M = {
  "github/copilot.vim",
  event = "BufReadPre"
}

M.opts = {
  suggestion = { enabled = false },
  panel = { enabled = false },
  filetypes = {
    markdown = true,
    help = true,
  },
}

return M
