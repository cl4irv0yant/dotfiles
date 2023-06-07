local M = {
  "christoomey/vim-tmux-navigator",
  event = "BufEnter",
}

function M.config()
    vim.api.nvim_set_keymap('n', '<C-h>', ':TmuxNavigateLeft<cr>', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<C-j>', ':TmuxNavigateDown<cr>', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<C-k>', ':TmuxNavigateUp<cr>', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<C-l>', ':TmuxNavigateRight<cr>', { noremap = true, silent = true })
end
return M
