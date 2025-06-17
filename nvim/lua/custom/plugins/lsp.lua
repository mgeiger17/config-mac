return {
  -- Hauptmodul: LSPConfig + Mason + alle allgemeinen Server
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      local lspconfig = require 'lspconfig'
      local mason = require 'mason'
      local mason_lspconfig = require 'mason-lspconfig'

      mason.setup()
      mason_lspconfig.setup {
        ensure_installed = {
          'pyright',
          'rust_analyzer',
          'clangd',
          'hls',
          'lua_ls',
        },
      }

      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      mason_lspconfig.setup_handlers {
        function(server_name)
          lspconfig[server_name].setup {
            capabilities = capabilities,
          }
        end,

        -- Spezialkonfigurationen

        ['pyright'] = function()
          local function get_python_path()
            local cwd = vim.fn.getcwd()
            local paths = {
              cwd .. '/.venv/bin/python3', -- Linux/macOS
              cwd .. '/.venv/bin/python', -- fallback macOS (manchmal ohne 3)
              cwd .. '\\.venv\\Scripts\\python.exe', -- Windows
            }
            for _, path in ipairs(paths) do
              if vim.fn.executable(path) == 1 then
                return path
              end
            end
            return 'python3' -- fallback global python3
          end

          lspconfig.pyright.setup {
            capabilities = capabilities,
            settings = {
              python = {
                analysis = {
                  typeCheckingMode = 'basic',
                  autoSearchPaths = true,
                  useLibraryCodeForTypes = true,
                },
              },
            },
            before_init = function(_, config)
              config.settings.python.pythonPath = get_python_path()
            end,
          }
        end,

        ['rust_analyzer'] = function()
          lspconfig.rust_analyzer.setup {
            capabilities = capabilities,
            settings = {
              ['rust-analyzer'] = {
                cargo = { allFeatures = true },
                checkOnSave = {
                  command = 'clippy',
                },
              },
            },
          }
        end,
      }
    end,
  },

  -- Spezielle Java-Integration mit nvim-jdtls
  {
    'neovim/nvim-lspconfig',
    dependencies = { 'mfussenegger/nvim-jdtls' },
    ft = { 'java' },
    config = function()
      local jdtls = require 'jdtls'
      local jdtls_setup = require 'jdtls.setup'
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'java',
        callback = function()
          local root_markers = { '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle', 'src' }
          local root_dir = jdtls_setup.find_root(root_markers)
          if not root_dir then
            return
          end

          local home = os.getenv 'HOME'
          local jdtls_path = home .. '/.local/share/eclipse.jdt.ls'
          local launcher_jar = vim.fn.glob(jdtls_path .. '/plugins/org.eclipse.equinox.launcher_*.jar')

          jdtls.start_or_attach {
            cmd = {
              '/Library/Java/JavaVirtualMachines/temurin-21.jdk/Contents/Home/bin/java',
              '-Declipse.application=org.eclipse.jdt.ls.core.id1',
              '-Dosgi.bundles.defaultStartLevel=4',
              '-Declipse.product=org.eclipse.jdt.ls.core.product',
              '-Dlog.protocol=true',
              '-Dlog.level=ALL',
              '-Xmx1G',
              '-jar',
              launcher_jar,
              '-configuration',
              jdtls_path .. '/config_mac',
              '-data',
              home .. '/.cache/jdtls-workspace',
            },
            root_dir = root_dir,
            capabilities = capabilities,
            settings = {
              java = {},
            },
          }
        end,
      })
    end,
  },

  -- TypeScript & JavaScript: typescript-tools statt tsserver
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
