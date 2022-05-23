-- mod-version:3 --lite-xl 2.1
local core = require "core"
local command = require "core.command"
local keymap = require "core.keymap"
local common = require "core.common"
local config = require "core.config"
local contextmenu = require "plugins.contextmenu"


config.plugins.openselected = {}
if not config.plugins.openselected.filemanager then
  if PLATFORM == "Windows" then
    config.plugins.openselected.filemanager = "start"
  elseif PLATFORM == "Mac OS X" then
    config.plugins.openselected.filemanager = "open"
  else
    config.plugins.openselected.filemanager = "xdg-open"
  end
end

command.add("core.docview", {
  ["open-selected:open-selected"] = function()
    local doc = core.active_view.doc
    if not doc:has_selection() then
      core.error("No text selected")
      return
    end

    local text = doc:get_text(doc:get_selection())

    -- trim whitespace from the ends
    text = text:match( "^%s*(.-)%s*$" )

    -- non-Windows platforms need the text quoted (%q)
    if PLATFORM ~= "Windows" then
      text = string.format("%q", text)
    end

    core.log("Opening %s...", text)

    system.exec(config.plugins.openselected.filemanager .. " " .. text)
  end,
})


contextmenu:register("core.docview", {
  contextmenu.DIVIDER,
  { text = "Open Selection",  command = "open-selected:open-selected" }
})


keymap.add { ["ctrl+alt+o"] = "open-selected:open-selected" }

