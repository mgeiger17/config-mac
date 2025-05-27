-- In plugins.lua oder in mason setup (kickstart nutzt lazy.nvim)
return {
  {
    'williamboman/mason.nvim',
    opts = function(_, opts)
      -- Ergänze die installierten LSP-Server
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { 'jdtls' })
    end,
  },
}
