return {
  {
    "chomosuke/typst-preview.nvim",
    lazy = false, -- or ft = 'typst'
    version = "*",
    opts = {
      invert_colors = "always",
    },

    keys = {
      {
        "<leader>tp",
        "<cmd>TypstPreview<cr>",
        desc = " Typst Preview",
      },
    },
  },
}
