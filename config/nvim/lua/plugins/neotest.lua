return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-neotest/neotest-python',
    'codymikol/neotest-kotlin',
    'nvim-treesitter/nvim-treesitter',
    'antoinemadec/FixCursorHold.nvim',
  },
  config = function()
    require('neotest').setup {
      adapters = {
        require 'neotest-python',
        require 'neotest-kotest',
      },
    }
  end,
}
