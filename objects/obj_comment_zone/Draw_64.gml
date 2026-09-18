/// @description
/// obj_comment_zone — Draw GUI Event

if (!is_showing || box_alpha < 0.05) exit;
 
var _gw   = display_get_gui_width();
var _gh   = display_get_gui_height();
var _bw   = _gw * 0.7;
var _bh   = 90;
var _bx   = _gw / 2 - _bw / 2;
var _by   = _gh - _bh - 70;
 
// Тло вікна
draw_set_alpha(box_alpha * 0.88);
draw_set_color(make_color_rgb(10, 20, 40));
draw_rectangle(_bx, _by, _bx + _bw, _by + _bh, false);
 
// Контур
draw_set_alpha(box_alpha);
draw_set_color(make_color_rgb(80, 140, 220));
draw_rectangle(_bx, _by, _bx + _bw, _by + _bh, true);
 
// Ім'я персонажа
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(make_color_rgb(100, 200, 255));
if (font_exists(fnt_main)) draw_set_font(fnt_main);
draw_text(_bx + 14, _by + 10, "Посейдон:");
 
// Текст коментаря
draw_set_color(c_white);
var _line_text = "";
if (current_line < array_length(comment_lines))
    _line_text = comment_lines[current_line];
draw_text_ext(_bx + 14, _by + 30, _line_text, 24, _bw - 28);
 
// Підказка "Q — далі"
var _has_more = (current_line < array_length(comment_lines) - 1);
draw_set_halign(fa_right);
draw_set_color(make_color_rgb(140, 160, 180));
draw_text(_bx + _bw - 10, _by + _bh - 20,
    _has_more ? "[Q] Далі ▶" : "[Q] Закрити ✕");
 
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_color(c_white);
draw_set_font(-1);