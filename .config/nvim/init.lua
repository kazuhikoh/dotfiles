--======================== 
-- Options 
--======================== 

-- Encoding 
vim.scriptencoding = 'utf-8'
vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'

-- OSのクリップボードを使用する
vim.opt.clipboard:append('unnamedplus,unnamed')

-- Styles
vim.opt.number = true
vim.opt.cursorline = true

vim.opt.tabstop = 2
vim.opt.expandtab = true -- Tab文字でなくSpaceを入力
vim.opt.shiftwidth = 2
vim.opt.smartindent = true

vim.opt.list = true -- 不可視文字を見えるようにする

-- Selection
vim.opt.virtualedit:append("block") -- 矩形選択で行末の右側も選択可能にする

-- Search
vim.opt.hlsearch = true
vim.opt.incsearch = true

--======================== 
-- LSP
--======================== 

-- 警告を分かりやすくする
-- ref: https://dev.classmethod.jp/articles/eetann-change-neovim-lsp-diagnostics-format/
vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  virtual_text = {
    format = function(diagnostic)
      return string.format('%s (%s: %s)', diagnostic.message, diagnostic.source, diagnostic.code)
    end,
  },
})


--======================== 
-- User Commands
--======================== 

-- W: 自動フォーマットを無視して保存
vim.api.nvim_create_user_command('W', 'noautocmd w', {})


--======================== 
-- Plugins
--======================== 

require("config.lazy")
require("config.keymaps")

