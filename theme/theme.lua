--[[

     Powerarrow Dark Awesome WM theme
     github.com/lcpz

--]]

local gears = require("gears")
local lain  = require("lain")
local awful = require("awful")
local wibox = require("wibox")
local dpi   = require("beautiful.xresources").apply_dpi

local os = os
local my_table = gears.table -- 4.{0,1} compatibility

local theme                                     = {}
theme.dir                                       = os.getenv("HOME") .. "/.config/awesome/theme"
theme.font                                      = "JetBrains Mono 9"
theme.fg_normal                                 = "#DDDDFF"
theme.fg_focus                                  = "#77DDDD"
theme.fg_urgent                                 = "#CC9393"
theme.fg_minimized                              = "#9B9BA8"
theme.bg_normal                                 = "#1A1A1A"
theme.bg_focus                                  = "#313131"
theme.bg_urgent                                 = "#1A1A1A"
theme.border_width                              = dpi(1)
theme.border_normal                             = "#3F3F3F"
theme.border_focus                              = "#5F5F5F"
theme.border_marked                             = "#CC9393"
theme.tasklist_bg_focus                         = "#1A1A1A"
theme.titlebar_bg_focus                         = theme.bg_focus
theme.titlebar_bg_normal                        = theme.bg_normal
theme.titlebar_fg_focus                         = theme.fg_focus
theme.menu_height                               = dpi(16)
theme.menu_width                                = dpi(140)
theme.menu_submenu_icon                         = theme.dir .. "/icons/submenu.png"
theme.layout_tile                               = theme.dir .. "/icons/tile.png"
theme.layout_tileleft                           = theme.dir .. "/icons/tileleft.png"
theme.layout_tilebottom                         = theme.dir .. "/icons/tilebottom.png"
theme.layout_tiletop                            = theme.dir .. "/icons/tiletop.png"
theme.layout_fairv                              = theme.dir .. "/icons/fairv.png"
theme.layout_fairh                              = theme.dir .. "/icons/fairh.png"
theme.layout_spiral                             = theme.dir .. "/icons/spiral.png"
theme.layout_dwindle                            = theme.dir .. "/icons/dwindle.png"
theme.layout_max                                = theme.dir .. "/icons/max.png"
theme.layout_fullscreen                         = theme.dir .. "/icons/fullscreen.png"
theme.layout_magnifier                          = theme.dir .. "/icons/magnifier.png"
theme.layout_floating                           = theme.dir .. "/icons/floating.png"
theme.widget_ac                                 = theme.dir .. "/icons/ac.png"
theme.widget_battery                            = theme.dir .. "/icons/battery.png"
theme.widget_battery_low                        = theme.dir .. "/icons/battery_low.png"
theme.widget_battery_empty                      = theme.dir .. "/icons/battery_empty.png"
theme.widget_mem                                = theme.dir .. "/icons/mem.png"
theme.widget_cpu                                = theme.dir .. "/icons/cpu.png"
theme.widget_temp                               = theme.dir .. "/icons/temp.png"
theme.widget_net                                = theme.dir .. "/icons/net.png"
theme.widget_hdd                                = theme.dir .. "/icons/hdd.png"
theme.widget_music                              = theme.dir .. "/icons/note.png"
theme.widget_music_on                           = theme.dir .. "/icons/note_on.png"
theme.widget_vol                                = theme.dir .. "/icons/vol.png"
theme.widget_vol_low                            = theme.dir .. "/icons/vol_low.png"
theme.widget_vol_no                             = theme.dir .. "/icons/vol_no.png"
theme.widget_vol_mute                           = theme.dir .. "/icons/vol_mute.png"
theme.widget_mail                               = theme.dir .. "/icons/mail.png"
theme.widget_mail_on                            = theme.dir .. "/icons/mail_on.png"
theme.tasklist_plain_task_name                  = true
theme.tasklist_disable_icon                     = false
theme.useless_gap                               = dpi(3)
theme.systray_icon_spacing                      = dpi(2)
theme.titlebar_close_button_focus               = theme.dir .. "/icons/titlebar/close_focus.png"
theme.titlebar_close_button_normal              = theme.dir .. "/icons/titlebar/close_normal.png"
theme.titlebar_ontop_button_focus_active        = theme.dir .. "/icons/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active       = theme.dir .. "/icons/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive      = theme.dir .. "/icons/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive     = theme.dir .. "/icons/titlebar/ontop_normal_inactive.png"
theme.titlebar_minimize_button_normal           = theme.dir .. "/icons/titlebar/ontop_normal_inactive.png"
theme.titlebar_minimize_button_focus            = theme.dir .. "/icons/titlebar/ontop_focus_inactive.png"
theme.titlebar_sticky_button_focus_active       = theme.dir .. "/icons/titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active      = theme.dir .. "/icons/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive     = theme.dir .. "/icons/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive    = theme.dir .. "/icons/titlebar/sticky_normal_inactive.png"
theme.titlebar_floating_button_focus_active     = theme.dir .. "/icons/titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active    = theme.dir .. "/icons/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive   = theme.dir .. "/icons/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive  = theme.dir .. "/icons/titlebar/floating_normal_inactive.png"
theme.titlebar_maximized_button_focus_active    = theme.dir .. "/icons/titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active   = theme.dir .. "/icons/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = theme.dir .. "/icons/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = theme.dir .. "/icons/titlebar/maximized_normal_inactive.png"
theme.notification_width                        = dpi(450)
theme.notification_max_width                    = dpi(450)
theme.notification_height                       = dpi(140)
theme.notification_max_height                   = dpi(140)


theme.wallpaper = function(s)
    local wa = s.workarea
    local isHorizontal = wa.width >= wa.height
    if isHorizontal then
        return theme.dir .. "/wall.png"
    else
        return theme.dir .. "/wall2.png"
    end
end

local markup = lain.util.markup
local separators = lain.util.separators

function escapeMarkup(s) 
    s = s:gsub("&", "&amp;")
    s = s:gsub("<", "&lt;")
    s = s:gsub(">", "&gt;")
    s = s:gsub("'", "&#39;")
    return s
end

-- Textclock
local clockicon = wibox.widget.imagebox(theme.widget_clock)
local clock = awful.widget.watch(
    "date +'%a %d %b %R'", 60,
    function(widget, stdout)
        widget:set_markup(" " .. markup.font(theme.font, stdout))
    end
)

-- Calendar
theme.cal = lain.widget.cal({
    attach_to = { clock },
    notification_preset = {
        font = "JetBrains Mono 9",
        fg   = theme.fg_normal,
        bg   = theme.bg_normal
    }
})

-- CPU
local cpuicon = wibox.widget.imagebox(theme.widget_cpu)
local cpu = lain.widget.cpu({
    settings = function()
        widget:set_markup(markup.font(theme.font, " " .. cpu_now.usage .. "% "))
    end
})

-- Net
local neticon = wibox.widget.imagebox(theme.widget_net)
local net = lain.widget.net({
    settings = function()
        widget:set_markup(markup.font(theme.font,
                          markup("#7AC82E", " " .. string.format("%04.2f", net_now.received / 1024))
                          .. " " ..
                          markup("#46A8C3", " " .. string.format("%04.2f", net_now.sent / 1024) .. " ")))
    end
})

-- Custom bullshit
local recttag_right = function(cr, width, height)
    gears.shape.transform(gears.shape.rectangular_tag)
    :rotate_at(width/2,height/2, math.pi) (cr, width, height)
end

local client_callback = function(se, c, index, objects) --luacheck: no unused

    local textbox = se:get_children_by_id('textfield')[1]
    if c.class == nil then
        textbox:set_markup_silently(c.name)
        return 
    end
    local index = string.find(c.class, "-[^-]*$")
    
    local text = c.class
    if index ~= nil then
        text = string.sub(c.class, 1, index-1)
    end

    text = text:gsub("^%l", string.upper) .. " (" .. escapeMarkup(c.name) .. ")"

    if c == client.focus then
        text = markup(theme.fg_focus, text)
    elseif c.minimized then
        text = markup(theme.fg_minimized, text)
    end

    textbox:set_markup_silently(text)
end

local create_tags = function(s)
    local wa = s.workarea
    local isHorizontal = wa.width >= wa.height
    if isHorizontal then
        awful.tag.add("Desktop", {
            screen = s,
            layout = awful.layout.suit.tile.bottom,
            master_count = 0,
            selected = true
        })
    else
        awful.tag.add("Desktop", {
            screen = s,
            layout = awful.layout.suit.tile,
            master_count = 0,
            selected = true
        })
    end
end

-- Separators
local spr     = wibox.widget.textbox(' ')
local arrl_dl = separators.arrow_left(theme.bg_focus, "alpha")
local arrl_ld = separators.arrow_left("alpha", theme.bg_focus)
local arrr_dl = separators.arrow_right(theme.bg_focus, "alpha")
local arrr_ld = separators.arrow_right("alpha", theme.bg_focus)

function theme.at_screen_connect(s)

    gears.wallpaper.maximized(theme.wallpaper(s), s, true)

    -- Tags
    create_tags(s)

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(my_table.join(
                           awful.button({}, 1, function () awful.layout.inc( 1) end),
                           awful.button({}, 2, function () awful.layout.set( awful.layout.layouts[1] ) end),
                           awful.button({}, 3, function () awful.layout.inc(-1) end),
                           awful.button({}, 4, function () awful.layout.inc( 1) end),
                           awful.button({}, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist({
        screen = s, 
        filter = awful.widget.taglist.filter.all, 
        style = {
            shape = recttag_right
        },
        widget_template = {
            {
                {
                    {
                        id = 'text_role',
                        widget = wibox.widget.textbox
                    },
                    layout = wibox.layout.fixed.horizontal,
                },
                left = dpi(6),
                right = dpi(10),
                widget = wibox.container.margin
            },
            id = 'background_role',
            widget = wibox.container.background
        },
        buttons = awful.util.taglist_buttons
    })

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist({
        screen = s, 
        filter = awful.widget.tasklist.filter.currenttags,
        buttons = awful.util.tasklist_buttons,
        style = { 
            shape = gears.shape.powerline,
            bg_normal = theme.bg_focus,
            bg_minimize = theme.bg_focus,
            bg_focus = theme.bg_focus,
            bg_urgent = theme.bg_focus
        },
        layout = {
            spacing = dpi(-6),
            spacing_widget = {
                {
                    forced_width = 0,
                    shape        = gears.shape.powerline,
                    widget       = wibox.widget.separator
                },
                valign = 'center',
                halign = 'center',
                widget = wibox.container.place,
            },
            layout  = wibox.layout.flex.horizontal
        },
        widget_template = {
            {
                {
                    {
                        id = 'textfield',
                        widget = wibox.widget.textbox,
                        forced_width = dpi(180)
                    },
                    layout = wibox.layout.fixed.horizontal
                },
                left = dpi(12),
                right = dpi(6),
                id = 'text_margin_role',
                widget = wibox.container.margin
            },
            id = 'background_role',
            widget = wibox.container.background,
            create_callback = client_callback,
            update_callback = client_callback,
        },
    })

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, height = dpi(18), bg = theme.bg_normal, fg = theme.fg_normal })
    
    local systray = wibox.widget.systray()
    systray.set_base_size(dpi(18))
    
    -- Add widgets to the wibox
    s.mywibox:setup {
        expand = "none",
        layout = wibox.layout.align.horizontal,
        {
            layout = wibox.layout.fixed.horizontal,
            s.mytaglist,
            s.mytasklist
        },
        s.mypromptbox,
        {
            layout = wibox.layout.fixed.horizontal,
            systray,
            spr,
            arrl_ld,
            wibox.container.background(cpu.widget, theme.bg_focus),
            wibox.container.background(cpuicon, theme.bg_focus),
            wibox.container.background(net.widget, theme.bg_focus),
            wibox.container.background(neticon, theme.bg_focus),
            arrl_dl,
            clock,
            spr,
            arrl_ld,
            wibox.container.background(s.mylayoutbox, theme.bg_focus),
        },
    }
end

return theme
