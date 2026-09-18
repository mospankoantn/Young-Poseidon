/// @description Clean weapon wheel
/// obj_weapon_selector - Draw GUI Event

if (!instance_exists(obj_player)) exit;

var _count = array_length(unlocked_indices);
if (_count == 0) exit;

if (font_exists(fnt_main)) draw_set_font(fnt_main);

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _ink = make_color_rgb(7, 13, 22);
var _panel = make_color_rgb(16, 34, 48);
var _teal = make_color_rgb(74, 190, 178);
var _gold = make_color_rgb(244, 188, 74);
var _soft = make_color_rgb(182, 214, 226);

draw_set_alpha(0.62 * appear_scale);
draw_set_color(c_black);
draw_rectangle(0, 0, _gw, _gh, false);
draw_set_alpha(1);

draw_set_alpha(0.86 * appear_scale);
draw_set_color(_ink);
draw_circle(gui_cx, gui_cy, radius + icon_size * 0.72, false);
draw_set_alpha(0.92 * appear_scale);
draw_set_color(_teal);
draw_circle(gui_cx, gui_cy, radius + icon_size * 0.72, true);
draw_set_alpha(1);

for (var _i = 0; _i < _count; _i++)
{
    var _angle = (_i / _count) * 360 - 90;
    var _windex = unlocked_indices[_i];
    var _ix = gui_cx + lengthdir_x(radius, _angle) * appear_scale;
    var _iy = gui_cy + lengthdir_y(radius, _angle) * appear_scale;

    var _is_selected = (_i == selected_slot);
    var _is_hovered = (_i == hover_slot);
    var _r = icon_size * 0.5 + (_is_selected ? 10 : (_is_hovered ? 6 : 2));

    draw_set_alpha(0.94 * appear_scale);
    draw_set_color(_is_selected ? _gold : (_is_hovered ? _teal : _panel));
    draw_circle(_ix, _iy, _r, false);
    draw_set_alpha(0.85 * appear_scale);
    draw_set_color(c_white);
    draw_circle(_ix, _iy, _r, true);

    var _wspr = obj_player.weapon_sprites[_windex];
    if (sprite_exists(_wspr))
    {
        var _icon_scale = 40 / max(sprite_get_width(_wspr), sprite_get_height(_wspr));
        draw_sprite_ext(_wspr, 0, _ix, _iy, _icon_scale, _icon_scale, 0, c_white, appear_scale);
    }
    else
    {
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(c_white);
        draw_text(_ix, _iy, string(_windex + 1));
    }

    draw_set_alpha(appear_scale);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_color(_is_selected ? _gold : _soft);
    draw_text(_ix, _iy + _r + 4, string(_windex + 1));
}

var _info_slot = (hover_slot >= 0) ? hover_slot : selected_slot;
var _info_index = unlocked_indices[_info_slot];
var _info_name = obj_player.weapon_names[_info_index];
var _info_atk = obj_player.weapon_atk[_info_index] + obj_player.temp_atk_buff;
var _info_spd = obj_player.weapon_spd_mult[_info_index];

var _box_w = 260;
var _box_h = 92;
var _box_x = gui_cx - _box_w * 0.5;
var _box_y = gui_cy - _box_h * 0.5;

draw_set_alpha(0.92 * appear_scale);
draw_set_color(_panel);
draw_rectangle(_box_x, _box_y, _box_x + _box_w, _box_y + _box_h, false);
draw_set_alpha(appear_scale);
draw_set_color(_teal);
draw_rectangle(_box_x, _box_y, _box_x + _box_w, _box_y + _box_h, true);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);
draw_text(gui_cx, gui_cy - 24, string_upper(_info_name));
draw_set_color(_gold);
draw_text(gui_cx, gui_cy, lc("hud_atk") + " " + string(_info_atk) + "   " + lc("hud_spd") + " " + string(_info_spd));
draw_set_color(_soft);
draw_text(gui_cx, gui_cy + 26, "TAB / ESC - close    ENTER - select");

draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_font(-1);
