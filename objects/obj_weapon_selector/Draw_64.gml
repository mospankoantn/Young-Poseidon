/// @description
/// obj_weapon_selector — Draw GUI Event

if (!instance_exists(obj_player)) exit;
 
var _count = array_length(unlocked_indices);
if (_count == 0) exit;
 
// ---- ЗАТЕМНЕННЯ ФОНУ ----
draw_set_alpha(0.55 * appear_scale);
draw_set_color(c_black);
draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
draw_set_alpha(1);
 
// ---- ЦЕНТРАЛЬНЕ КОЛО ----
draw_set_alpha(0.3 * appear_scale);
draw_set_color(make_color_rgb(30, 50, 80));
draw_circle(gui_cx, gui_cy, radius + icon_size / 2 + 12, false);
draw_set_alpha(appear_scale);
draw_set_color(make_color_rgb(60, 100, 160));
draw_circle(gui_cx, gui_cy, radius + icon_size / 2 + 12, true);
draw_set_alpha(1);
 
// ---- ІКОНКИ ЗБРОЇ ----
for (var _i = 0; _i < _count; _i++)
{
    var _angle    = (_i / _count) * 360 - 90;
    var _windex   = unlocked_indices[_i];
    var _ix       = gui_cx + lengthdir_x(radius, _angle) * appear_scale;
    var _iy       = gui_cy + lengthdir_y(radius, _angle) * appear_scale;
 
    var _is_selected = (_i == selected_slot);
    var _is_hovered  = (_i == hover_slot);
 
    // Фон іконки
    var _bg_radius = icon_size / 2 + (_is_selected ? 10 : (_is_hovered ? 6 : 3));
    var _bg_col    = _is_selected
                        ? make_color_rgb(255, 200, 50)      // Обрана — золота
                        : (_is_hovered
                            ? make_color_rgb(100, 160, 255) // Наведена — синя
                            : make_color_rgb(40, 60, 100)); // Звичайна — темна
 
    draw_set_alpha(0.9 * appear_scale);
    draw_set_color(_bg_col);
    draw_circle(_ix, _iy, _bg_radius, false);
 
    // Контур
    draw_set_color(c_white);
    draw_set_alpha(0.5 * appear_scale);
    draw_circle(_ix, _iy, _bg_radius, true);
    draw_set_alpha(appear_scale);
 
    // Спрайт зброї
    var _wspr = obj_player.weapon_sprites[_windex];
    if (sprite_exists(_wspr))
    {
        draw_sprite_ext(_wspr, 0,
            _ix, _iy,
            1, 1, 0, c_white, appear_scale);
    }
    else
    {
        // Якщо спрайту немає — малюємо номер
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(c_white);
        if (font_exists(fnt_main)) draw_set_font(fnt_main);
        draw_text(_ix, _iy, string(_windex + 1));
    }
 
    // Назва зброї під іконкою (лише для обраної або наведеної)
    if (_is_selected || _is_hovered)
    {
        draw_set_halign(fa_center);
        draw_set_valign(fa_top);
        draw_set_color(_is_selected ? c_yellow : c_white);
        if (font_exists(fnt_main)) draw_set_font(fnt_main);
        draw_text(_ix, _iy + _bg_radius + 4,
            obj_player.weapon_names[_windex]);
    }
}
 
// ---- ПІДКАЗКА В ЦЕНТРІ ----
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(make_color_rgb(180, 200, 220));
if (font_exists(fnt_main)) draw_set_font(fnt_main);
draw_text(gui_cx, gui_cy,
    obj_player.weapon_names[unlocked_indices[selected_slot]]);
 
// ATK поточної зброї
draw_set_color(make_color_rgb(255, 150, 100));
draw_text(gui_cx, gui_cy + 22,
    "ATK: " + string(obj_player.weapon_atk[unlocked_indices[selected_slot]]
              + obj_player.temp_atk_buff));
 
// Підказки клавіш
draw_set_color(make_color_rgb(120, 140, 160));
draw_text(gui_cx, gui_cy - 22, "Tab — закрити  |  Enter — обрати");
 
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_font(-1);