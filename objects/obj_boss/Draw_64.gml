/// @description Смуга HP малюється у нижній частині екрану для будь-якого боса
/// obj_boss — Draw GUI Event

// Смуга HP малюється у нижній частині екрану для будь-якого боса
var _gw      = display_get_gui_width();
var _gh      = display_get_gui_height();
var _bar_w   = _gw * 0.6;           // Ширина смуги = 60% екрану
var _bar_h   = 22;
var _bar_x   = _gw / 2 - _bar_w / 2;
var _bar_y   = _gh - 55;
var _hp_pct  = clamp(hp / max_hp, 0, 1);
 
// Тло смуги
draw_set_color(make_color_rgb(30, 10, 10));
draw_rectangle(_bar_x - 2, _bar_y - 2, _bar_x + _bar_w + 2, _bar_y + _bar_h + 2, false);
 
// Заповнення HP (червоне → жовте залежно від %)
var _hp_color = merge_color(c_red, c_yellow, _hp_pct);
draw_set_color(_hp_color);
draw_rectangle(_bar_x, _bar_y, _bar_x + _bar_w * _hp_pct, _bar_y + _bar_h, false);
 
// Контур
draw_set_color(c_white);
draw_rectangle(_bar_x - 2, _bar_y - 2, _bar_x + _bar_w + 2, _bar_y + _bar_h + 2, true);
 
// Ім'я боса та HP
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);
if (font_exists(fnt_main)) draw_set_font(fnt_main);
draw_text(_gw / 2, _bar_y + _bar_h / 2,
    lc(boss_name_key) + "   " + string(hp) + " / " + string(max_hp));
 
// Позначка фази (якщо є 2+ фази)
if (variable_instance_exists(id, "phase") && phase >= 2)
{
    draw_set_color(c_orange);
    draw_text(_gw / 2, _bar_y - 18, lc("boss_phase2"));
}
 
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_font(-1);
