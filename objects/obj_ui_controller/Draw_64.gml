/// @description Малювання інтерфейсу користувача
// obj_ui_controller Draw GUI Event

if (!instance_exists(obj_player)) exit;
 
var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _p  = obj_player;
var _m  = 12;
 
if (font_exists(fnt_main)) draw_set_font(fnt_main);
 
// ════════════════════════════════════════
// БЛОК 1: HP
// ════════════════════════════════════════
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_text(_m, _m, "HP: " + string(_p.hp) + " / " + string(_p.max_hp));
 
// ════════════════════════════════════════
// БЛОК 2: ЗІЛЛЯ
// ════════════════════════════════════════
draw_set_color(make_color_rgb(100, 220, 100));
draw_text(_m, _m + 22, "Здоров'я [2]: " + string(_p.potion_heal_count));
 
draw_set_color(make_color_rgb(220, 100, 100));
draw_text(_m, _m + 42, "Сила    [3]: " + string(_p.potion_strength_count));
 
draw_set_color(make_color_rgb(100, 180, 255));
draw_text(_m, _m + 62, "Швидкість[4]: " + string(_p.potion_speed_count));
 
// ════════════════════════════════════════
// БЛОК 3: АКТИВНИЙ БАФ
// ════════════════════════════════════════
if (_p.buff_duration > 0)
{
    var _secs = ceil(_p.buff_duration / room_speed);
    var _str  = "";
    if (_p.temp_atk_buff > 0)
        _str = "Сила +" + string(_p.temp_atk_buff) + "  (" + string(_secs) + "с)";
    else if (_p.temp_spd_buff > 0)
        _str = "Швидкість +" + string(_p.temp_spd_buff) + "  (" + string(_secs) + "с)";
 
    var _pulse = 0.6 + 0.4 * sin(current_time / 200000);
    draw_set_color(make_color_hsv(30, 255, 255 * _pulse));
    draw_set_halign(fa_right);
    draw_text(_gw - _m, _m, _str);
    draw_set_halign(fa_left);
}
 
// ════════════════════════════════════════
// БЛОК 4: КЛЮЧ ОЛІМПУ (якщо є)
// ════════════════════════════════════════
if (_p.has_olympus_key)
{
    draw_set_halign(fa_right);
    draw_set_color(c_yellow);
    draw_text(_gw - _m, _m + 22, "🗝 Ключ Олімпу");
    draw_set_halign(fa_left);
}
 
// ════════════════════════════════════════
// БЛОК 5: ПАНЕЛЬ ЗБРОЇ (внизу по центру)
// ════════════════════════════════════════
// Збираємо розблоковані зброї
var _unlocked = [];
for (var _i = 0; _i < array_length(_p.weapon_unlocked); _i++)
{
    if (_p.weapon_unlocked[_i])
        array_push(_unlocked, _i);
}
 
var _uc     = array_length(_unlocked);
var _sw     = 52;    // Ширина слота
var _sh     = 52;    // Висота слота
var _gap    = 6;     // Відступ між слотами
var _pad    = 8;     // Внутрішній відступ панелі
var _bar_w  = _uc * (_sw + _gap) - _gap + _pad * 2;
var _bar_h  = _sh + _pad * 2;
var _bar_x  = _gw / 2 - _bar_w / 2;
var _bar_y  = _gh - _bar_h - _m;
 
// Фон панелі
draw_set_alpha(0.75);
draw_set_color(make_color_rgb(20, 25, 40));
draw_rectangle(_bar_x, _bar_y, _bar_x + _bar_w, _bar_y + _bar_h, false);
draw_set_alpha(0.5);
draw_set_color(make_color_rgb(60, 90, 140));
draw_rectangle(_bar_x, _bar_y, _bar_x + _bar_w, _bar_y + _bar_h, true);
draw_set_alpha(1);
 
// Слоти зброї
for (var _i = 0; _i < _uc; _i++)
{
    var _wid  = _unlocked[_i];
    var _sx   = _bar_x + _pad + _i * (_sw + _gap);
    var _sy   = _bar_y + _pad;
    var _sel  = (_wid == _p.current_weapon);
 
    // Фон слота
    if (_sel)
    {
        // Обрана зброя — яскравий фон + пульсація
        var _pulse2 = 0.7 + 0.3 * sin(current_time / 200000);
        draw_set_color(make_color_rgb(
            floor(80  * _pulse2),
            floor(120 * _pulse2),
            floor(200 * _pulse2)));
    }
    else
    {
        draw_set_color(make_color_rgb(35, 45, 65));
    }
    draw_rectangle(_sx, _sy, _sx + _sw, _sy + _sh, false);
 
    // Контур слота
    draw_set_color(_sel ? c_yellow : make_color_rgb(70, 100, 150));
    draw_rectangle(_sx, _sy, _sx + _sw, _sy + _sh, true);
 
    // Спрайт зброї в слоті
    var _wspr = _p.weapon_sprites[_wid];
    if (sprite_exists(_wspr))
    {
        draw_sprite_ext(_wspr, 0,
            _sx + _sw / 2, _sy + _sh / 2 - 6,
            1, 1, 0, c_white, 1);
    }
 
    // Коротка назва під іконкою
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_set_color(_sel ? c_yellow : make_color_rgb(160, 180, 200));
    if (font_exists(fnt_main)) draw_set_font(fnt_main);
    draw_text(_sx + _sw / 2, _sy + _sh - 2,
        string(_wid + 1));   // Номер 1-6
}
 
// Назва обраної зброї та ATK під панеллю
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_color(make_color_rgb(200, 210, 230));
if (font_exists(fnt_main)) draw_set_font(fnt_main);
draw_text(_gw / 2, _bar_y + _bar_h + 3,
    _p.weapon_names[_p.current_weapon]
    + "  ATK: " + string(_p.weapon_atk[_p.current_weapon] + _p.temp_atk_buff));
 
// ════════════════════════════════════════
// БЛОК 6: ПІДКАЗКА КЕРУВАННЯ
// ════════════════════════════════════════
draw_set_halign(fa_right);
draw_set_valign(fa_bottom);
draw_set_color(make_color_rgb(100, 110, 130));
draw_text(_gw - _m, _gh - _m,
    "ESC-Меню | WASD-Рух | SPACE-Стрибок | F-Атака | Q/Z-Зброя | Tab-Вибір зброї");
 
// ════ СКИДАННЯ ════
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(-1);