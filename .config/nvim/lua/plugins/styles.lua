return {
  -- Color Scheme --
  
  { 
    "EdenEast/nightfox.nvim",
    config = function(_, opts) 
      vim.cmd("colorscheme nightfox")
    end
  },

  -- Status Line --

  { 'nvim-mini/mini.statusline', version = '*' },
  
  -- Highlight -- 

  { 'brenoprata10/nvim-highlight-colors' },

}
