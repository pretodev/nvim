return {
  "codota/tabnine-nvim",
  main = "tabnine",
  build = vim.loop.os_uname().sysname == "Windows_NT" and "pwsh.exe -file .\\dl_binaries.ps1" or "./dl_binaries.sh",
  cmd = { "TabnineStatus", "TabnineDisable", "TabnineEnable", "TabnineToggle" },
  event = "User AstroFile",
  opts = {
    accept_keymap = false,
    dismiss_keymap = false,
    -- debounce_ms = 999999,
  },
  config = function()
    local completion = require "tabnine.completion"
    local state = require "tabnine.state"
    vim.keymap.set("i", "<C-s>", function()
      print(completion.should_complete())
      if completion.should_complete() then
        completion.complete()
      else
        completion.clear()
        state.completions_cache = nil
      end
    end)
  end,
}
