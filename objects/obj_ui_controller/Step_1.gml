/// Begin Step keeps menu input ahead of gameplay Step events.
yp_display_tick();
gw=display_get_gui_width(); gh=display_get_gui_height();
var _focus=window_has_focus();
if (!game_paused && global.yp_settings.auto_pause && menu_focus && !_focus) yp_pause(true);
menu_focus=_focus;
if (game_paused) { yp_menu_step(); exit; }
var _click=mouse_check_button_pressed(mb_left)
    && point_in_rectangle(device_mouse_x_to_gui(0),device_mouse_y_to_gui(0),gw-42,8,gw-12,36);
if (keyboard_check_pressed(vk_escape) || _click) yp_pause(true);
