return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      source_selector = {
        winbar = false,
      },
      window = {
        position = "current",
        mappings = {
          ["e"] = function() vim.cmd "Neotree focus filesystem" end,
          ["b"] = function() vim.cmd "Neotree focus buffers" end,
        },
      },
      event_handlers = {
        {
          event = "file_open_requested",
          handler = function()
            -- auto close
            -- vimc.cmd("Neotree close")
            -- OR
            require("neo-tree.command").execute { action = "close" }
          end,
        },
      },
      buffers = {
        window = {
          mappings = {
            ["d"] = "buffer_delete",
            ["o"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
            ["oc"] = { "order_by_created", nowait = false },
            ["od"] = { "order_by_diagnostics", nowait = false },
            ["om"] = { "order_by_modified", nowait = false },
            ["on"] = { "order_by_name", nowait = false },
            ["os"] = { "order_by_size", nowait = false },
            ["ot"] = { "order_by_type", nowait = false },
          },
        },
      },
    },
  },
}
