local M ={
  "nvim-neotest/neotest",
  lazy = true,
  dependencies = {
    "olimorris/neotest-phpunit",
  },
  config = function()
    
  end
}

function M.config()
  local neotest = require "neotest-phpunit"

  neotest.setup({
        adapters = {
          require("neotest-phpunit")
        }
})
end

return M
