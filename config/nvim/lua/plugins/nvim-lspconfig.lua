return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    { 'j-hui/fidget.nvim', opts = {} },
    { 'folke/neodev.nvim', opts = {} },
  },
  config = function()
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        -- LSP keymaps
        map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
        map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
        map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
        map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
        map('K', vim.lsp.buf.hover, 'Hover Documentation')
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        -- Function to apply 'Create function' code action if available
        local function create_missing_function()
          -- Generate position parameters at the current cursor position
          local params = vim.lsp.util.make_position_params()
          params.context = { diagnostics = vim.diagnostic.get(0) }

          vim.lsp.buf_request(0, 'textDocument/codeAction', params, function(err, result, ctx)
            if err then
              print('Error fetching code actions: ', err)
              return
            end

            if not result or vim.tbl_isempty(result) then
              print 'No code actions available'
              return
            end

            -- Find and apply 'Create function' action if available
            for _, action in ipairs(result) do
              if action.title:match 'Create function' then
                vim.lsp.buf.execute_command(action)
                print 'Function created successfully!'
                return
              end
            end

            print "No 'Create function' action found"
          end)
        end

        -- Keymap to create missing function
        map('<leader>cf', create_missing_function, '[C]reate [F]unction')

        -- Document highlight (optional but useful)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.server_capabilities.documentHighlightProvider then
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            callback = vim.lsp.buf.clear_references,
          })
        end
      end,
    })

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
    local servers = {
      kotlin_language_server = {},
      pyright = {
        settings = {
          python = {
            analysis = {
              root = vim.fn.getcwd(),
              useLibraryCodeForTypes = true,
              reportMissingImports = 'error',
              reportMissingTypeStubs = false,
            },
          },
        },
      },
      clangd = {},
      gopls = {},
      phpactor = {},
      bashls = {},
      eslint = {},
      tailwindcss = {},
      lua_ls = {
        settings = {
          Lua = {
            completion = {
              callSnippet = 'Replace',
            },
          },
        },
      },
    }

    -- Mason setup
    require('mason').setup()
    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
      'stylua',
      'ktlint',
      'prettierd',
      'ruff',
      'mypy',
      'isort',
      'black',
      'stylelint',
    })
    require('mason-tool-installer').setup { ensure_installed = ensure_installed }

    require('mason-lspconfig').setup {
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
          require('lspconfig')[server_name].setup(server)
        end,
      },
    }
  end,
}
