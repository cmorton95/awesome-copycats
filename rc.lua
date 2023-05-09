--[[

     Awesome WM configuration template
     github.com/lcpz

--]]

-- {{{ Required libraries

-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

local gears         = require("gears")
local awful         = require("awful")
                      require("awful.autofocus")
local wibox         = require("wibox")
local beautiful     = require("beautiful")
local naughty       = require("naughty")
local lain          = require("lain")
local freedesktop   = require("freedesktop")
local hotkeys_popup = require("awful.hotkeys_popup")
                      require("awful.hotkeys_popup.keys")
local mytable       = gears.table -- 4.{0,1} compatibility

-- }}}

-- {{{ Error handling

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify {
        preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors
    }
end

-- Handle runtime errors after startup
do
    local in_error = false

    awesome.connect_signal("debug::error", function (err)
        if in_error then return end

        in_error = true

        naughty.notify {
            preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
            text = tostring(err)
        }

        in_error = false
    end)
end

-- }}}

-- {{{ Variable definitions

local modkey       = "Mod4"
local altkey       = "Mod1"
local terminal     = "yakuake"
local vi_focus     = false -- vi-like client focus https://github.com/lcpz/awesome-copycats/issues/275
local cycle_prev   = false  -- cycle with only the previously focused client or all https://github.com/lcpz/awesome-copycats/issues/274
local editor       = "code"
local browser      = "vivaldi"
local scrlocker    = "slock"
local player       = "Deezer"
local conffolder   = string.format("%s/.config/awesome", os.getenv("HOME"))

awful.util.terminal = terminal
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.bottom
}

awful.util.taglist_buttons = mytable.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then client.focus:move_to_tag(t) end
    end),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then client.focus:toggle_tag(t) end
    end),
    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

awful.util.tasklist_buttons = mytable.join(
     awful.button({ }, 1, function(c)
         c.minimized = not c.minimized
         if not c.minimized then
            client.focus = c
            c:raise()
         end
     end),
     awful.button({ }, 2, function(c) c:kill() end),
     awful.button({ }, 3, function()
         awful.menu.client_list({ theme = { width = 250 } })
     end),
     awful.button({ }, 4, function() awful.client.focus.byidx(1) end),
     awful.button({ }, 5, function() awful.client.focus.byidx(-1) end)
)

beautiful.init(string.format("%s%s", conffolder, "/theme/theme.lua"))

-- }}}

-- {{{ Menu

-- Create a launcher widget and a main menu
local myawesomemenu = {
   { "Hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "Manual", string.format("%s -e man awesome", terminal) },
   { "Edit config", string.format("%s %s", editor, conffolder) },
   { "Restart", awesome.restart },
   { "Quit", function() awesome.quit() end },
}

awful.util.mymainmenu = freedesktop.menu.build {
    before = {
        { "Awesome", myawesomemenu, beautiful.awesome_icon },
        -- other triads can be put here
    },
    after = {
        { "Open terminal", terminal },
        -- other triads can be put here
    }
}

-- Hide the menu when the mouse leaves it

awful.util.mymainmenu.wibox:connect_signal("mouse::leave", function()
    if not awful.util.mymainmenu.active_child or
       (awful.util.mymainmenu.wibox ~= mouse.current_wibox and
       awful.util.mymainmenu.active_child.wibox ~= mouse.current_wibox) then
        awful.util.mymainmenu:hide()
    else
        awful.util.mymainmenu.active_child.wibox:connect_signal("mouse::leave",
        function()
            if awful.util.mymainmenu.wibox ~= mouse.current_wibox then
                awful.util.mymainmenu:hide()
            end
        end)
    end
end)


-- }}}

-- {{{ Screen

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", function(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end)

-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(function(s) beautiful.at_screen_connect(s) end)

-- }}}

-- {{{ Mouse bindings

root.buttons(mytable.join(
    awful.button({ }, 3, function () awful.util.mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))

-- }}}

-- {{{ Key bindings

globalkeys = mytable.join(
    -- X screen locker
    awful.key({ modkey,           }, "l", function () os.execute(scrlocker) end,
              {description = "lock screen", group = "hotkeys"}),

    -- Show help
    awful.key({ modkey,           }, "s", hotkeys_popup.show_help,
              {description="show help", group="awesome"}),

    -- Menu
    awful.key({ modkey,           }, "w", function () awful.util.mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),

    -- Switching
    awful.key({ modkey,           }, "Tab",
        function ()
            if cycle_prev then
                awful.client.focus.history.previous()
            else
                awful.client.focus.byidx(-1)
            end
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "cycle with previous/go back", group = "client"}),

    -- Show/hide wibox
    awful.key({ modkey }, "b", function ()
            for s in screen do
                s.mywibox.visible = not s.mywibox.visible
            end
        end,
        {description = "toggle wibox", group = "awesome"}),

    -- On-the-fly useless gaps change
    awful.key({ altkey, "Control" }, "=", function () lain.util.useless_gaps_resize(1) end,
              {description = "increment useless gaps", group = "tag"}),
    awful.key({ altkey, "Control" }, "-", function () lain.util.useless_gaps_resize(-1) end,
              {description = "decrement useless gaps", group = "tag"}),

    -- Dynamic tagging
    awful.key({ modkey, "Control" }, "n", function () lain.util.add_tag() end,
              {description = "add new tag", group = "tag"}),
    awful.key({ modkey, "Control" }, "d", function () lain.util.delete_tag() end,
              {description = "delete tag", group = "tag"}),

    -- Standard program
    awful.key({ modkey, "Control"   }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),

    awful.key({ modkey, "Control"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey, "Shift" }, "s", function() awful.spawn("shutdown -P 0") end,
              {description = "shutdown", group = "awesome"}),

    awful.key({ modkey, "Shift" }, "r", function() awful.spawn("shutdown -r 0") end,
              {description = "reboot", group = "awesome"}),

    awful.key({ modkey, "Shift" }, "c", function() awful.spawn("/etc/ricing/picom.sh") end,
              {description = "picom", group = "awesome"}),

    -- MPD control
    awful.key({ altkey }, "space",
        function ()
            awful.spawn("playerctl -p "..player.." play-pause")
        end,
        {description = "player play pause", group = "custom"}),
    awful.key({ altkey }, "Left",
        function ()
            awful.spawn("playerctl -p "..player.." previous")
        end,
        {description = "player previous", group = "custom"}),
    awful.key({ altkey }, "Right",
        function ()
            awful.spawn("playerctl -p "..player.." next")
        end,
        {description = "player next", group = "custom"}),
    awful.key({ altkey }, "Up",
        function ()
            awful.spawn("playerctl -p "..player.." volume 0.05+")
        end,
        {description = "player vol up", group = "custom"}),
    awful.key({ altkey }, "Down",
        function ()
            awful.spawn("playerctl -p "..player.." volume 0.05-")
        end,
        {description = "player vol down", group = "custom"}),

    -- User programs    
    awful.key({ modkey }, "q", function () awful.spawn(browser) end,
              {description = "run browser", group = "launcher"}),

    -- Prompt
    awful.key({ modkey, altkey }, "r", function () awful.screen.focused().mypromptbox:run() end,
            {description = "run prompt", group = "launcher"}),

    awful.key({ modkey }, "r", function () awful.spawn("rofi -show drun -show-icons") end,
            {description = "rofi prompt", group = "launcher"}),

    awful.key({"Control", "Shift"}, "4", function() awful.spawn("flameshot gui --clipboard --accept-on-select") end,
            {description = "spectacle region capture", group = "custom"})
)

clientkeys = mytable.join(
    awful.key({ altkey, "Shift"   }, "m",      lain.util.magnify_client,
              {description = "magnify client", group = "client"}),
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey,           }, "x",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "z",  awful.client.floating.toggle,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey,           }, "Escape",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"})
)

local killps = function()
    -- frick you primary selection eat doo doo and commit dead
    -- os.execute so this definitely goes off before doing anything else
    os.execute('echo -n "" | xclip -i -selection primary')
end

clientbuttons = mytable.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 2, function (c)
        killps()
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        c.minimized = true
    end),
    awful.button({ modkey, "Control" }, 2, function (c)
        killps()
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        c:kill()
    end),
    awful.button({ modkey, "Control", "Shift" }, 2, function (c)
        killps()
        if c.pid then
            awful.spawn("kill -9 " .. c.pid)
        end
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)

-- }}}

-- {{{ Rules

-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { 
        rule = { },
        properties = { 
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            callback = awful.client.setslave,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap+awful.placement.no_offscreen,
            size_hints_honor = false
        }
    },

    -- Floating clients.
    { 
        rule_any = {
            instance = {
                "DTA",  -- Firefox addon DownThemAll.
                "copyq",  -- Includes session name in class.
                "pinentry",
            },
            class = {
                "Arandr",
                "Blueman-manager",
                "Gpick",
                "Kruler",
                "MessageWin",  -- kalarm.
                "Sxiv",
                "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
                "Wpa_gui",
                "veromix",
                "xtightvncviewer"
            },
            -- Note that the name property shown in xprop might be set slightly after creation of the client
            -- and the name shown there might not match defined rules here.
            name = {
                "Event Tester",  -- xev.
            },
            role = {
                "AlarmWindow",  -- Thunderbird's calendar.
                "ConfigManager",  -- Thunderbird's about:config.
                "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
            }
        }, 
        properties = { 
            floating = true 
        }
    },

    { 
        rule_any = {
            class = {
                "yakuake"
            }
        }, 
        properties = { 
            border_width = 0 
        }
    }
}

-- }}}

-- {{{ Signals

-- Signal function to execute when a new client appears.
client.connect_signal("request::manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
        and not c.size_hints.user_position
        and not c.size_hints.program_position then
            -- Prevent clients from being unreachable after screen count changes.
            awful.placement.no_offscreen(c)
    end

    -- Center dialogs over parent
    if c.transient_for then
        awful.placement.centered(c, {
            parent = c.transient_for
        })
        awful.placement.no_offscreen(c)
    end
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = vi_focus})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- }}}
