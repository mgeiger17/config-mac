return {
  -- LSPConfig für mehrere Sprachen (Java etc.)
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'mfussenegger/nvim-jdtls',
    },
    config = function()
      local lspconfig = require 'lspconfig'
      local jdtls = require 'jdtls'
      local jdtls_setup = require 'jdtls.setup'
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- Autocommand für Java
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'java',
        callback = function()
          local root_markers = { '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' }
          local root_dir = jdtls_setup.find_root(root_markers)
          if not root_dir then
            return
          end

          jdtls.start_or_attach {
            cmd = { 'jdtls' },
            root_dir = root_dir,
            capabilities = capabilities,
            settings = {
              java = {},
            },
          }
        end,
      })

      -- Entfernt: lspconfig.tsserver.setup → wird ersetzt durch typescript-tools.nvim
    end,
  },

  -- TypeScript/JavaScript über typescript-tools.nvim (tsserver-Nachfolger)
  {
    'pmizio/typescript-tools.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    ft = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
    opts = {
      settings = {
        separate_diagnostic_server = true,
        publish_diagnostic_on = 'insert_leave',
        expose_as_code_action = 'all',
      },
    },
  },
}
