/// @description
/// obj_room_exit — Draw GUI Event

// Підказка "[F] Перейти → Узбережжя" коли гравець поруч
if (prompt_alpha < 0.05) exit;
if (!instance_exists(obj_player)) exit;

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

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

var _prompt_str = lc("exit_go");
if (_room_name != "") _prompt_str += " → " + _room_name;

// IMPORTANT: use the same font for measurement and rendering. Previously the
// width was measured using whatever font another GUI object had left active,
// which produced a tiny background under only the middle of the text.
if (font_exists(fnt_main)) draw_set_font(fnt_main);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var _max_pw = min(520, _gw - 24);
var _text_w = string_width(_prompt_str);
var _pw = min(_max_pw, max(180, _text_w + 28));
var _wrap = (_text_w + 28 > _max_pw);
var _ph = _wrap ? 44 : 30;
var _px = clamp(_gui_x - _pw * 0.5, 12, _gw - _pw - 12);
var _py = clamp(_gui_y - 74, 52, _gh - _ph - 62);

// Тло підказки
draw_set_alpha(prompt_alpha * 0.88);
draw_set_color(make_color_rgb(10, 20, 40));
draw_rectangle(_px, _py, _px + _pw, _py + _ph, false);
draw_set_alpha(prompt_alpha);
draw_set_color(_dir_color);
draw_rectangle(_px, _py, _px + _pw, _py + _ph, true);

// Текст
draw_set_color(c_white);
if (_wrap)
{
    draw_set_valign(fa_top);
    draw_text_ext(_px + _pw * 0.5, _py + 6, _prompt_str, 16, _pw - 18);
}
else
{
    draw_set_valign(fa_middle);
    draw_text(_px + _pw * 0.5, _py + _ph * 0.5, _prompt_str);
}

draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_font(-1);
