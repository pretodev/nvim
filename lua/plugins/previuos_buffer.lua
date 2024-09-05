local buffers = {}

return {
  "AstroNvim/astrocore",
  opts = {
    autocmds = {
      previous_buffer = {
        {
          event = "BufEnter",
          group = "previous_buffer",
          callback = function()
            local current_buffer = vim.api.nvim_get_current_buf()
            for i, buf in ipairs(buffers) do
              if buf == current_buffer then
                table.remove(buffers, i)
                break
              end
            end
            table.insert(buffers, 1, current_buffer)
            if #buffers > 2 then table.remove(buffers, 3) end
          end,
        },
      },
    },
    mappings = {
      n = {
        ["<Leader><Tab>"] = {
          function()
            if #buffers < 2 then return end
            local target_buffer = buffers[2]
            if vim.api.nvim_buf_is_valid(target_buffer) then vim.api.nvim_set_current_buf(target_buffer) end
          end,
          desc = "Previous buffer",
        },
      },
    },
  },
}
