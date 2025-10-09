return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      -- Install these parsers for better React/JSX highlighting
      ensure_installed = {
        "javascript",
        "typescript", 
        "tsx",
        "html",
        "css",
        "json",
        "markdown",
        "lua",
        "vim",
        "vimdoc",
      },
      
      -- Auto install missing parsers when entering buffer
      auto_install = true,
      
      highlight = {
        enable = true,
        -- Disable vim's regex highlighting in favor of treesitter
        additional_vim_regex_highlighting = false,
      },
      
      -- Better indentation
      indent = {
        enable = true,
      },
      
      -- Enhanced JSX/TSX support
      context_commentstring = {
        enable = true,
      },
    })
    
    -- Ensure JSX files use tsx parser for better highlighting
    vim.treesitter.language.register("tsx", "jsx")
  end,
}
