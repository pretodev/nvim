local complete = function()
  local state = require "tabnine.state"
  local completion = require "tabnine.completion"

  if state.completions_cache == nil then
    completion.prefetch()
    completion.complete()
  elseif state.completions_cache ~= nil then
    completion.accept()
    state.completions_cache = nil
  end
end

local dismiss = function()
  local state = require "tabnine.state"
  local completion = require "tabnine.completion"

  completion.clear()
  state.completions_cache = nil
end

return {
  "codota/tabnine-nvim",
  main = "tabnine",
  build = vim.loop.os_uname().sysname == "Windows_NT" and "pwsh.exe -file .\\dl_binaries.ps1" or "./dl_binaries.sh",
  cmd = { "TabnineStatus", "TabnineDisable", "TabnineEnable", "TabnineToggle" },
  event = "User AstroFile",
  opts = function(_, opts)
    opts.accept_keymap = false
    opts.dismiss_keymap = false
    opts.disable_auto_comment = false

    vim.keymap.set("i", "<C-s>", complete, {})
    vim.keymap.set("i", "<C-x>", dismiss, {})
  end,
}
