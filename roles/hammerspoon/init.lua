-- Config loaded auto, when save init.lua file
function reloadConfig(files)
    doReload = false
    for _,file in pairs(files) do
        if file:sub(-4) == ".lua" then
            doReload = true
        end
    end
    if doReload then
        hs.reload()
    end
end
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
hs.notify.new({title="Hammerspoon", informativeText="Config loaded"}):send()

-- Toggle Application
local previous_app = nil
local cmd_shift = {"cmd", "shift"}
function toggle_application(_app)
    local front_app = hs.application.frontmostApplication() 
    if front_app:name() ~= _app then
        previous_app = front_app
    end
    local app = hs.appfinder.appFromName(_app)
    if not app then
        hs.application.launchOrFocus(_app)
        return
    end
    local mainwin = app:mainWindow()
    if mainwin then
        if mainwin == hs.window.focusedWindow() then
            mainwin:application():hide()
            if previous_app:mainWindow() then
                previous_app:mainWindow():focus()
            end
        else
            mainwin:application():activate(true)
            mainwin:application():unhide()
            mainwin:focus()
        end
    end
end
hs.hotkey.bind(cmd_shift, "J", function() toggle_application("Terminal") end)
hs.hotkey.bind(cmd_shift, "K", function() toggle_application("Google Chrome") end)

-- Load Spoons
-- See also: https://github.com/Hammerspoon/Spoons
hs.loadSpoon("Calendar")

hs.loadSpoon("Caffeine")
spoon.Caffeine:bindHotkeys({toggle={hyper, "f6"}})
spoon.Caffeine:start()
spoon.Caffeine:clicked()
