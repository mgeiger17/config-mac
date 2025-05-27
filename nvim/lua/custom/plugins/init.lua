-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

-- Setze Python-Interpreter für Neovim

return {
  -- Startify (wie gehabt)
  {
    'mhinz/vim-startify',
    lazy = false,
    init = function()
      vim.g.startify_custom_header = {
        ' ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ',
        ' ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ',
        ' ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ',
        ' ██║╚██╗██║██╔══╝  ██║   ██║██║   ██║██║██║╚██╔╝██║ ',
        ' ██║ ╚████║███████╗╚██████╔╝╚██████╔╝██║██║ ╚═╝ ██║ ',
        ' ╚═╝  ╚═══╝╚══════╝ ╚═════╝  ╚═════╝ ╚═╝╚═╝     ╚═╝ ',
      }
      vim.g.startify_lists = {
        { type = 'sessions', header = { '   🗂  Sessions' } },
        { type = 'commands', header = { '   ⚡ Quick Commands' } },
        { type = 'dir', header = { '   📂 Recent Files' } },
      }
      vim.g.startify_commands = {
        { '🔍 Find File', 'Telescope find_files' },
        { '📜 Recent Files', 'Telescope oldfiles' },
        { '📝 New File', 'ene | startinsert' },
        { '🛠 Lazy Plugin Manager', 'Lazy' },
        { '❌ Quit', 'qa' },
      }
    end,
  },
}
