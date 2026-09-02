vim.api.nvim_create_autocmd("InsertLeave", {
  callback = function()
    os.execute("im-select com.apple.keylayout.ABC")
  end,
})

