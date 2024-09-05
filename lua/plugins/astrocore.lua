-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`

local recent_buffers = {}

local function update_recent_buffers()
  local current_buffer = vim.api.nvim_get_current_buf()

  for i, buf in ipairs(recent_buffers) do
    if buf == current_buffer then
      table.remove(recent_buffers, i)
      break
    end
  end
  table.insert(recent_buffers, 1, current_buffer)
  if #recent_buffers > 2 then table.remove(recent_buffers, 3) end
end

local function switch_to_recent_buffer()
  if #recent_buffers < 2 then return end
  local target_buffer = recent_buffers[2]
  if vim.api.nvim_buf_is_valid(target_buffer) then vim.api.nvim_set_current_buf(target_buffer) end
end

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics_mode = 3, -- diagnostic mode on start (0 = off, 1 = no signs/virtual text, 2 = no virtual text, 3 = on)
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },

    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        showtabline = 0,
        relativenumber = true, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        spell = false, -- sets vim.opt.spell
        signcolumn = "yes", -- sets vim.opt.signcolumn to yes
        wrap = false, -- sets vim.opt.wrap
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
      },
    },
    mappings = {
      n = {
        -- navigate buffer tabs
        ["]b"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["[b"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },

        -- copy buffer content
        ["<leader>Y"] = { 'gg"+yG', desc = "copy buffer content" },

        -- mappings seen under group name "Buffer"
        ["<Leader>bd"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Close buffer from tabline",
        },

        -- show diagnostic in modal
        ["<C-e>"] = { function() vim.diagnostic.open_float() end, desc = "Open diagnostic model" },

        -- show help signature in modal
        ["<C-s>"] = { function() vim.lsp.buf.signature_help() end, desc = "Open signature modal" },

        -- show oppened buffers
        ["<Leader>o"] = { function() vim.cmd "Neotree focus buffers" end, desc = "Oppened buffers" },

        -- prev tab
        ["<Leader><Tab>"] = { switch_to_recent_buffer, desc = "Previous buffer" },

        -- tables with just a `desc` key will be registered with which-key if it's installed
        -- this is useful for naming menus
        -- ["<Leader>b"] = { desc = "Buffers" },

        -- setting a mapping to false will disable it
        -- ["<C-S>"] = false,
      },

      i = {
        ["<C-e>"] = { function() vim.diagnostic.open_float() end, desc = "Open float diagnostic" },
        ["<C-s>"] = { function() vim.lsp.buf.signature_help() end, desc = "Open signature modal" },
      },
      v = {
        -- move selected content
        ["J"] = { ":m '>+1<CR>gv=gv", desc = "move selected content to bottom" },
        ["K"] = { ":m '<-2<CR>gv=gv", desc = "move selected content to top" },
      },
    },
    autocmds = {
      updaterecentbuffers = {
        {
          event = "BufEnter",
          group = "updaterecentbuffers",
          callback = update_recent_buffers,
        },
      },
    },
  },
}
