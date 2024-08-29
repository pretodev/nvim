-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

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
    autocmds = {
      fix_imports_on_save = {
        cond = function(client) return client.name == "vtsls" end,
        {
          event = "BufWritePre",
          desc = "Fix imports on save",
          callback = function()
            vim.lsp.buf.code_action {
              context = { diagnostics = {}, only = { "source.organizeImports" } },
              apply = true,
            }
          end,
        },
      },
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
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      -- first key is the mode
      n = {
        -- second key is the lefthand side of the map

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
        ["<Tab>"] = { function() require("astrocore.buffer").prev() end, desc = "Previous buffer" },

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
  },
}
