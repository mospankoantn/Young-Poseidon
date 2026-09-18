/// @description Малювання меню
/// obj_main_menu — Draw GUI Event

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _t  = appear_t / 60;   // 0..1 — прогрес появи
 
// ── ФОН (темно-синій як у Main_Menu.png) ──
// Спрайт фону кімнати вже є — тут малюємо лише UI поверх.
 
// ── НАЗВА ЗЛІВА: "YOUNG POSEIDON MAIN MENU" ──
if (font_exists(fnt_title)) draw_set_font(fnt_title);
draw_set_alpha(_t);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_middle);
 
var _title_x = 60;
var _title_y = _gh / 2 - 40;
// ── ТІНЬ ЗА ЗАГОЛОВКОМ ──
draw_set_alpha(0.65 * _t);
draw_set_color(make_color_rgb(5, 10, 25));
draw_rectangle(_title_x - 10, _title_y - 60,
    _title_x + 250, _title_y + 80, false);
draw_set_alpha(_t);
draw_text_transformed(_title_x, _title_y, lc("menu_title"), 1, 1, 0);
 
// ── EXIT СПРАВА ──
var _exit_x    = _gw - 80;
var _exit_y    = _gh / 2;
var _exit_hover = (point_distance(device_mouse_x_to_gui(0),
                                  device_mouse_y_to_gui(0),
                                  _exit_x, _exit_y) < 40);
 
draw_set_color(_exit_hover ? c_yellow : c_white);
draw_set_halign(fa_center);
draw_text(_exit_x, _exit_y, lc("menu_exit"));
 
if (_exit_hover && mouse_check_button_pressed(mb_left))
    game_end();
 
// ── ПУНКТИ МЕНЮ ──
if (font_exists(fnt_main)) draw_set_font(fnt_main);

var _mx     = device_mouse_x_to_gui(0);
var _my     = device_mouse_y_to_gui(0);
var _item_x = _gw / 2 - 80;
var _item_y = _gh / 2 - 60;
var _item_h = 48;
var _item_w = 210;

// ── ЗАГАЛЬНА ПІДЛОЖКА ЗА ВСІМА ПУНКТАМИ ──
var _panel_pad = 14;
var _panel_x   = _item_x - _panel_pad;
var _panel_y   = _item_y - _panel_pad;
var _panel_w   = _item_w + _panel_pad * 2;
var _panel_h   = array_length(menu_items) * _item_h + _panel_pad * 2 - 10;

draw_set_alpha(0.72 * _t);
draw_set_color(make_color_rgb(5, 10, 25));
draw_rectangle(_panel_x, _panel_y,
    _panel_x + _panel_w, _panel_y + _panel_h, false);

// Контур панелі
draw_set_alpha(0.4 * _t);
draw_set_color(make_color_rgb(80, 120, 200));
draw_rectangle(_panel_x, _panel_y,
    _panel_x + _panel_w, _panel_y + _panel_h, true);
draw_set_alpha(1);

for (var _i = 0; _i < array_length(menu_items); _i++)
{
    var _iy    = _item_y + _i * _item_h;
    var _hover = (_mx >= _panel_x && _mx <= _panel_x + _panel_w
               && _my >= _iy - 4  && _my <= _iy + _item_h - 8);
    var _is_sel = (_i == selected);

    // Підсвічування при наведенні
    if (_hover || _is_sel)
    {
        draw_set_alpha(0.35 * _t);
        draw_set_color(make_color_rgb(80, 130, 220));
        draw_rectangle(_panel_x + 4, _iy - 4,
            _panel_x + _panel_w - 4, _iy + _item_h - 10, false);
        draw_set_alpha(_t);

        // Ліва рискочка перед обраним пунктом
        draw_set_color(c_yellow);
        draw_rectangle(_panel_x + 4, _iy + 4,
            _panel_x + 8, _iy + _item_h - 14, false);
    }

    // Текст
    draw_set_alpha(_t);
    draw_set_color((_hover || _is_sel) ? c_yellow : c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);
    draw_text(_item_x, _iy + _item_h / 2 - 10, menu_items[_i]);

    if (_hover && mouse_check_button_pressed(mb_left))
        _execute_menu(_i);
}

if (status_timer > 0 && status_text != "")
{
    draw_set_alpha(min(_t, 0.9));
    draw_set_color(make_color_rgb(255, 220, 120));
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_text_ext(_panel_x + _panel_w / 2, _panel_y + _panel_h + 14,
        status_text, 18, _panel_w + 40);
    draw_set_alpha(1);
}
 
// ── ПРАПОРЦІ МОВИ (знизу зліва) ──
var _fy  = _gh - 50;
var _fx  = 60;
 
// Прапор України
draw_set_alpha(_t * (global.lang == "UA" ? 1.0 : 0.5));
draw_set_color(make_color_rgb(0, 87, 183));
draw_rectangle(_fx, _fy, _fx + 38, _fy + 14, false);
draw_set_color(make_color_rgb(255, 215, 0));
draw_rectangle(_fx, _fy + 14, _fx + 38, _fy + 28, false);
 
// Обрана рамка
if (global.lang == "UA")
{
    draw_set_color(c_yellow);
    draw_rectangle(_fx - 2, _fy - 2, _fx + 40, _fy + 30, true);
}
 
// Прапор Британії
draw_set_alpha(_t * (global.lang == "EN" ? 1.0 : 0.5));
draw_set_color(make_color_rgb(1, 33, 105));
draw_rectangle(_fx + 48, _fy, _fx + 86, _fy + 28, false);
draw_set_color(make_color_rgb(200, 16, 46));
draw_line(_fx + 48, _fy, _fx + 86, _fy + 28);
draw_line(_fx + 86, _fy, _fx + 48, _fy + 28);
draw_set_color(c_white);
draw_line_width(_fx + 67, _fy, _fx + 67, _fy + 28, 3);
draw_line_width(_fx + 48, _fy + 14, _fx + 86, _fy + 14, 3);
 
if (global.lang == "EN")
{
    draw_set_alpha(_t);
    draw_set_color(c_yellow);
    draw_rectangle(_fx + 46, _fy - 2, _fx + 88, _fy + 30, true);
}
draw_set_alpha(1);
 
// Клік по прапорцях
var _mxg = device_mouse_x_to_gui(0);
var _myg = device_mouse_y_to_gui(0);
if (mouse_check_button_pressed(mb_left))
{
    if (_mxg >= _fx && _mxg <= _fx + 38 && _myg >= _fy && _myg <= _fy + 30)
        set_language("UA");
    if (_mxg >= _fx + 48 && _mxg <= _fx + 88 && _myg >= _fy && _myg <= _fy + 30)
        set_language("EN");
}
  
draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_font(-1);
