return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  lazy = false,
  version = false,
  opts = {
    -- Change provider to "anthropic" or "openai" if you want to use direct API keys
    provider = "copilot", 
    auto_suggestions_provider = "copilot",
    behaviour = {
      auto_suggestions = false, -- Keep inline suggestions managed by copilot.lua
      support_paste_from_clipboard = true,
    },
    -- Example config for Anthropic:
    -- anthropic = {
    --   endpoint = "https://api.anthropic.com",
    --   model = "claude-3-5-sonnet-20241022",
    --   temperature = 0,
    --   max_tokens = 4096,
    -- },
  },
  build = "make",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
    {
      "zbirenbaum/copilot.lua",
      opts = {
        suggestion = { enabled = false },
        panel = { enabled = false },
      },
    },
    "Kaiser-Yang/blink-cmp-avante",
    {
      "saghen/blink.cmp",
      opts = {
        sources = {
          default = { "avante" },
          providers = {
            avante = {
              name = "Avante",
              module = "blink-cmp-avante",
            },
          },
        },
      },
    },
  },
}
