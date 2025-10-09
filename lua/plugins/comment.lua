return {
  'numToStr/Comment.nvim',
  config = function()
    require('Comment').setup()
     -- Option 1: Use gcc (most common vim convention)
    vim.keymap.set('n', 'gcc', '<Plug>(comment_toggle_linewise_current)', { desc = 'Toggle comment' })
    vim.keymap.set('v', 'gc', '<Plug>(comment_toggle_linewise_visual)', { desc = 'Toggle comment' })
       
  end
}
