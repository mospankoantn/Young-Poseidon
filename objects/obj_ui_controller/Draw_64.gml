/// @description Clean gameplay HUD
/// obj_ui_controller - Draw GUI Event

if (!instance_exists(obj_player)) exit;
var _p = obj_player;

if (font_exists(fnt_main)) draw_set_font(fnt_main);

var _pad = 12;
var _top_h = 44;
var _bot_h = 54;
var _bot_y = gh - _bot_h;

var _ink = make_color_rgb(8, 18, 28);
var _panel = make_color_rgb(15, 34, 48);
var _teal = make_color_rgb(74, 190, 178);
var _gold = make_color_rgb(244, 188, 74);
var _coral = make_color_rgb(224, 88, 72);
var _soft = make_color_rgb(178, 214, 226);

// Top strip: health, room, active temporary buff.
draw_set_alpha(0.78);
draw_set_color(_ink);
draw_rectangle(0, 0, gw, _top_h, false);
draw_set_alpha(0.65);
draw_set_color(_teal);
draw_rectangle(0, _top_h - 2, gw, _top_h, false);
draw_set_alpha(1);

var _heart_size = 20;
var _heart_gap = 4;
var _heart_y = 12;
for (var _hi = 0; _hi < _p.max_hp; _hi++)
{
    var _hx = _pad + _hi * (_heart_size + _heart_gap);
    var _filled = (_hi < _p.hp);

    if (_filled && sprite_exists(spr_heart_full))
    {
        draw_sprite_ext(spr_heart_full, 0, _hx + 10, _heart_y + 10, 1, 1, 0, c_white, 1);
    }
    else if (!_filled && sprite_exists(spr_heart_empty))
    {
        draw_sprite_ext(spr_heart_empty, 0, _hx + 10, _heart_y + 10, 1, 1, 0, c_white, 0.72);
    }
    else
    {
        draw_set_alpha(_filled ? 1 : 0.35);
        draw_set_color(_filled ? _coral : make_color_rgb(80, 42, 44));
        draw_ellipse(_hx + 2, _heart_y + 2, _hx + 10, _heart_y + 12, false);
        draw_ellipse(_hx + 10, _heart_y + 2, _hx + 18, _heart_y + 12, false);
        draw_triangle(_hx + 2, _heart_y + 10, _hx + 18, _heart_y + 10, _hx + 10, _heart_y + 21, false);
        draw_set_alpha(1);
    }
}

var _atk_total = (_p.current_weapon >= 0) ? (_p.weapon_atk[_p.current_weapon] + _p.temp_atk_buff) : 0;
var _spd_mult = (_p.current_weapon >= 0) ? _p.weapon_spd_mult[_p.current_weapon] : 1;
var _spd_total = (_p.spd + _p.perm_spd_bonus + _p.temp_spd_buff) * _spd_mult;
var _stat_x = _pad + _p.max_hp * (_heart_size + _heart_gap) + 8;

draw_set_halign(fa_left);
draw_set_valign(fa_middle);
draw_set_color(_gold);
draw_text(_stat_x, 14, lc("hud_atk") + " " + string(_atk_total));
draw_set_color(_soft);
draw_text(_stat_x, 30, lc("hud_spd") + " " + string(round(_spd_total * 10) / 10));

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);
draw_text(gw * 0.5, 16, string_upper(lc(zone_key)) + "  " + string(zone_room));
draw_set_color(_soft);
var _weapon_hint = (_p.current_weapon >= 0) ? _p.weapon_names[_p.current_weapon] : lc("hud_no_weapon");
draw_text(gw * 0.5, 32, "TAB - " + _weapon_hint);

if (_p.buff_duration > 0)
{
    var _secs = ceil(_p.buff_duration / room_speed);
    var _buff_text = (_p.temp_atk_buff > 0)
        ? (lc("buff_atk") + string(_p.temp_atk_buff) + " [" + string(_secs) + "s]")
        : (lc("buff_spd") + string(_p.temp_spd_buff) + " [" + string(_secs) + "s]");

    draw_set_halign(fa_right);
    draw_set_color(_p.temp_atk_buff > 0 ? _coral : _teal);
    draw_text(gw - 58, 22, _buff_text);
}

// Pause button.
var _pause_x = gw - 42;
var _pause_y = 8;
draw_set_alpha(0.88);
draw_set_color(_panel);
draw_rectangle(_pause_x, _pause_y, _pause_x + 30, _pause_y + 28, false);
draw_set_alpha(0.9);
draw_set_color(_soft);
draw_rectangle(_pause_x, _pause_y, _pause_x + 30, _pause_y + 28, true);
draw_set_alpha(1);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);
draw_text(_pause_x + 15, _pause_y + 14, "II");

// Center hint toast. It appears only when there is something useful to say.
if (hint_alpha > 0.05)
{
    var _hint_w = min(gw - 72, max(260, string_width(hint_text) + 42));
    var _hint_h = 40;
    var _hint_x = gw * 0.5 - _hint_w * 0.5;
    var _hint_y = _top_h + 8;

    draw_set_alpha(0.86 * hint_alpha);
    draw_set_color(_panel);
    draw_rectangle(_hint_x, _hint_y, _hint_x + _hint_w, _hint_y + _hint_h, false);
    draw_set_alpha(hint_alpha);
    draw_set_color(_teal);
    draw_rectangle(_hint_x, _hint_y, _hint_x + _hint_w, _hint_y + _hint_h, true);
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_text_ext(gw * 0.5, _hint_y + 8, hint_text, 18, _hint_w - 22);
    draw_set_alpha(1);
}

// Dialog bubbles are no longer reserved on screen when inactive.
if (player_dialog_alpha > 0.05)
{
    var _dw = min(390, gw * 0.45);
    var _dh = 74;
    var _dx = _pad;
    var _dy = _bot_y - _dh - 10;

    draw_set_alpha(0.9 * player_dialog_alpha);
    draw_set_color(_panel);
    draw_rectangle(_dx, _dy, _dx + _dw, _dy + _dh, false);
    draw_set_alpha(player_dialog_alpha);
    draw_set_color(_teal);
    draw_rectangle(_dx, _dy, _dx + _dw, _dy + _dh, true);
    draw_set_color(_soft);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_text(_dx + 12, _dy + 8, lc("dialog_player"));
    draw_set_color(c_white);
    draw_text_ext(_dx + 12, _dy + 28, player_dialog_text, 18, _dw - 24);
    draw_set_color(_soft);
    draw_set_halign(fa_right);
    draw_text(_dx + _dw - 10, _dy + _dh - 20, "Q");
    draw_set_alpha(1);
}

if (npc_dialog_alpha > 0.05)
{
    var _ndw = min(390, gw * 0.45);
    var _ndh = 74;
    var _ndx = gw - _pad - _ndw;
    var _ndy = _bot_y - _ndh - 10;

    draw_set_alpha(0.9 * npc_dialog_alpha);
    draw_set_color(make_color_rgb(44, 25, 24));
    draw_rectangle(_ndx, _ndy, _ndx + _ndw, _ndy + _ndh, false);
    draw_set_alpha(npc_dialog_alpha);
    draw_set_color(_coral);
    draw_rectangle(_ndx, _ndy, _ndx + _ndw, _ndy + _ndh, true);
    draw_set_color(make_color_rgb(255, 206, 178));
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_text(_ndx + 12, _ndy + 8, lc("dialog_npc"));
    draw_set_color(c_white);
    draw_text_ext(_ndx + 12, _ndy + 28, npc_dialog_text, 18, _ndw - 24);
    draw_set_color(make_color_rgb(255, 206, 178));
    draw_set_halign(fa_right);
    draw_text(_ndx + _ndw - 10, _ndy + _ndh - 20, "Q");
    draw_set_alpha(1);
}

// Bottom inventory strip.
draw_set_alpha(0.76);
draw_set_color(_ink);
draw_rectangle(0, _bot_y, gw, gh, false);
draw_set_alpha(0.6);
draw_set_color(_gold);
draw_rectangle(0, _bot_y, gw, _bot_y + 2, false);
draw_set_alpha(1);

var _slot = 42;
var _slot_gap = 8;
var _slots_y = _bot_y + 6;
var _potion_data = [
    [_p.potion_heal_count, spr_potion_heal, "Z", make_color_rgb(62, 146, 82)],
    [_p.potion_strength_count, spr_potion_strength, "X", make_color_rgb(176, 74, 54)],
    [_p.potion_speed_count, spr_potion_speed, "C", make_color_rgb(54, 126, 176)]
];

for (var _pi = 0; _pi < 3; _pi++)
{
    var _count = _potion_data[_pi][0];
    var _spr = _potion_data[_pi][1];
    var _key = _potion_data[_pi][2];
    var _col = _potion_data[_pi][3];
    var _sx = _pad + _pi * (_slot + _slot_gap);
    var _empty = (_count <= 0);

    draw_set_alpha(_empty ? 0.3 : 0.86);
    draw_set_color(_col);
    draw_rectangle(_sx, _slots_y, _sx + _slot, _slots_y + _slot, false);
    draw_set_alpha(_empty ? 0.35 : 0.86);
    draw_set_color(c_white);
    draw_rectangle(_sx, _slots_y, _sx + _slot, _slots_y + _slot, true);

    if (!_empty && sprite_exists(_spr))
        draw_sprite_ext(_spr, 0, _sx + _slot * 0.5, _slots_y + 18, 0.9, 0.9, 0, c_white, 1);

    draw_set_alpha(1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_bottom);
    draw_set_color(_empty ? make_color_rgb(130, 140, 150) : c_white);
    draw_text(_sx + 4, _slots_y + _slot - 4, _key);
    draw_set_halign(fa_right);
    draw_text(_sx + _slot - 4, _slots_y + _slot - 4, string(_count));
}

var _weapon_w = 222;
var _weapon_h = 42;
var _weapon_x = gw - _pad - _weapon_w;
var _weapon_y = _slots_y;

draw_set_alpha(0.86);
draw_set_color(_panel);
draw_rectangle(_weapon_x, _weapon_y, _weapon_x + _weapon_w, _weapon_y + _weapon_h, false);
draw_set_alpha(0.9);
draw_set_color(_teal);
draw_rectangle(_weapon_x, _weapon_y, _weapon_x + _weapon_w, _weapon_y + _weapon_h, true);
draw_set_alpha(1);

if (_p.current_weapon >= 0)
{
    var _wspr = _p.weapon_sprites[_p.current_weapon];
    var _wname = _p.weapon_names[_p.current_weapon];
    var _watk = _p.weapon_atk[_p.current_weapon] + _p.temp_atk_buff;
    var _wspd = _p.weapon_spd_mult[_p.current_weapon];

    if (sprite_exists(_wspr))
        draw_sprite_ext(_wspr, 0, _weapon_x + 24, _weapon_y + _weapon_h * 0.5, 1.2, 1.2, 0, c_white, 1);

    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);
    draw_text(_weapon_x + 48, _weapon_y + 14, string_upper(_wname));
    draw_set_color(_gold);
    draw_text(_weapon_x + 48, _weapon_y + 30, lc("hud_atk") + " " + string(_watk) + "   " + lc("hud_spd") + " " + string(_wspd));
}
else
{
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(_soft);
    draw_text(_weapon_x + _weapon_w * 0.5, _weapon_y + _weapon_h * 0.5, lc("hud_no_weapon"));
}

if (_p.has_olympus_key)
{
    var _kx = _weapon_x - 52;
    draw_set_alpha(0.86);
    draw_set_color(_gold);
    draw_rectangle(_kx, _weapon_y, _kx + 42, _weapon_y + _weapon_h, false);
    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_rectangle(_kx, _weapon_y, _kx + 42, _weapon_y + _weapon_h, true);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    if (sprite_exists(spr_olympus_key))
        draw_sprite_ext(spr_olympus_key, 0, _kx + 21, _weapon_y + 21, 0.9, 0.9, 0, c_white, 1);
    else
        draw_text(_kx + 21, _weapon_y + 21, "KEY");
}

// Pause menu.
if (game_paused)
{
    draw_set_alpha(0.68);
    draw_set_color(c_black);
    draw_rectangle(0, 0, gw, gh, false);
    draw_set_alpha(1);

    var _pw = 330;
    var _ph = 374;
    var _px = gw * 0.5 - _pw * 0.5;
    var _py = gh * 0.5 - _ph * 0.5;

    draw_set_alpha(0.96);
    draw_set_color(_ink);
    draw_rectangle(_px, _py, _px + _pw, _py + _ph, false);
    draw_set_alpha(1);
    draw_set_color(_teal);
    draw_rectangle(_px, _py, _px + _pw, _py + _ph, true);

    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
    if (font_exists(fnt_title)) draw_set_font(fnt_title);
    draw_text(gw * 0.5, _py + 18, lc("pause_title"));
    if (font_exists(fnt_main)) draw_set_font(fnt_main);

    var _menu_items = [
        lc("pause_resume"),
        lc("pause_save"),
        lc("pause_load"),
        lc("pause_settings"),
        lc("pause_mainmenu"),
        lc("pause_quit")
    ];

    var _mx = device_mouse_x_to_gui(0);
    var _my = device_mouse_y_to_gui(0);
    var _item_h = 40;
    var _item_y = _py + 72;

    for (var _mi = 0; _mi < array_length(_menu_items); _mi++)
    {
        var _iy = _item_y + _mi * _item_h;
        var _hover = (_mx >= _px + 24 && _mx <= _px + _pw - 24
                   && _my >= _iy && _my <= _iy + _item_h - 6);

        if (_hover)
        {
            draw_set_alpha(0.28);
            draw_set_color(_teal);
            draw_rectangle(_px + 24, _iy, _px + _pw - 24, _iy + _item_h - 6, false);
            draw_set_alpha(1);
        }

        draw_set_color(_hover ? _gold : c_white);
        draw_text(gw * 0.5, _iy + 10, _menu_items[_mi]);

        if (_hover && mouse_check_button_pressed(mb_left))
        {
            switch (_mi)
            {
                case 0:
                    game_paused = false;
                    break;
                case 1:
                    save_game();
                    break;
                case 2:
                    load_game();
                    break;
                case 3:
                    show_hint(lc("pause_settings"), 120);
                    break;
                case 4:
                    game_paused = false;
                    with (obj_player) instance_destroy();
                    room_goto(rm_menu);
                    break;
                case 5:
                    game_end();
                    break;
            }
        }
    }

    var _flag_y = _py + _ph - 40;
    draw_set_alpha(global.lang == "UA" ? 1 : 0.45);
    draw_set_color(make_color_rgb(0, 87, 183));
    draw_rectangle(_px + 30, _flag_y, _px + 64, _flag_y + 14, false);
    draw_set_color(make_color_rgb(255, 215, 0));
    draw_rectangle(_px + 30, _flag_y + 14, _px + 64, _flag_y + 28, false);
    if (global.lang == "UA")
    {
        draw_set_alpha(1);
        draw_set_color(_gold);
        draw_rectangle(_px + 28, _flag_y - 2, _px + 66, _flag_y + 30, true);
    }

    draw_set_alpha(global.lang == "EN" ? 1 : 0.45);
    draw_set_color(make_color_rgb(1, 33, 105));
    draw_rectangle(_px + 76, _flag_y, _px + 110, _flag_y + 28, false);
    draw_set_color(make_color_rgb(200, 16, 46));
    draw_line(_px + 76, _flag_y, _px + 110, _flag_y + 28);
    draw_line(_px + 110, _flag_y, _px + 76, _flag_y + 28);
    if (global.lang == "EN")
    {
        draw_set_alpha(1);
        draw_set_color(_gold);
        draw_rectangle(_px + 74, _flag_y - 2, _px + 112, _flag_y + 30, true);
    }

    draw_set_alpha(1);
    if (mouse_check_button_pressed(mb_left))
    {
        if (_mx >= _px + 28 && _mx <= _px + 66 && _my >= _flag_y - 2 && _my <= _flag_y + 30)
            set_language("UA");

        if (_mx >= _px + 74 && _mx <= _px + 112 && _my >= _flag_y - 2 && _my <= _flag_y + 30)
            set_language("EN");
    }
}

draw_set_font(-1);
draw_set_color(c_white);
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
