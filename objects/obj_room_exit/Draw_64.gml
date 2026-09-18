/// @description
/// obj_room_exit — Draw GUI Event

// Підказка "[F] Перейти → Узбережжя" коли гравець поруч
if (prompt_alpha < 0.05) exit;
if (!instance_exists(obj_player)) exit;
 
var _gw    = display_get_gui_width();
var _gh    = display_get_gui_height();
 
// Конвертуємо координати об'єкта в GUI-простір
var _gui_x = (x - camera_get_view_x(view_camera[0]))
             * (_gw / camera_get_view_width(view_camera[0]));
var _gui_y = (y - camera_get_view_y(view_camera[0]))
             * (_gh / camera_get_view_height(view_camera[0]));
 
// Назва кімнати призначення
var _room_name = "";
if (variable_global_exists("room_names")
    && ds_map_exists(global.room_names, target_room))
    _room_name = global.room_names[? target_room];
 
// Підказка
var _prompt_str = lc("exit_go");
if (_room_name != "") _prompt_str += " → " + _room_name;
 
var _pw = string_width(_prompt_str) + 20;
var _ph = 26;
var _px = clamp(_gui_x - _pw / 2, 10, _gw - _pw - 10);
var _py = _gui_y - 70;
 
// Тло підказки
draw_set_alpha(prompt_alpha * 0.85);
draw_set_color(make_color_rgb(10, 20, 40));
draw_rectangle(_px, _py, _px + _pw, _py + _ph, false);
draw_set_alpha(prompt_alpha);
draw_set_color(_dir_color);
draw_rectangle(_px, _py, _px + _pw, _py + _ph, true);
 
// Текст
draw_set_alpha(prompt_alpha);
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
if (font_exists(fnt_main)) draw_set_font(fnt_main);
draw_text(_px + _pw / 2, _py + _ph / 2, _prompt_str);
 
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_font(-1);