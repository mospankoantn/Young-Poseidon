if (startup_state == "logo")
{
    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();
    var _t = startup_logo_age;
    var _fade_panel = clamp(_t / 16, 0, 1);
    var _fade_logo = clamp((_t - 8) / 26, 0, 1);
    var _fade_text = clamp((_t - 20) / 24, 0, 1);
    var _fade_hint = startup_logo_prompt_alpha;
    var _logo_y = lerp(_gh * 0.48 + 18, _gh * 0.46, _fade_logo);
    var _pulse = 0.97 + 0.03 * sin(current_time / 200);
    var _panel_x1 = _gw * 0.16;
    var _panel_x2 = _gw * 0.84;
    var _panel_y1 = _gh * 0.11;
    var _panel_y2 = _gh * 0.89;

    draw_set_alpha(1);
    draw_set_color(make_color_rgb(2, 8, 18));
    draw_rectangle(0, 0, _gw, _gh, false);

    // Underwater glow and moving bubbles to better match Young Poseidon.
    for (var _i = 0; _i < 8; _i++)
    {
        var _bx = frac(0.13 * _i + current_time * 0.000018 * (_i + 1)) * _gw;
        var _by = _gh - frac(0.17 * _i + current_time * 0.000025 * (_i + 2)) * (_gh * 0.82) - 40;
        var _br = 6 + (_i mod 4) * 3;
        draw_set_alpha(0.05 + 0.03 * sin(current_time / 210 + _i));
        draw_set_color(make_color_rgb(130, 218, 238));
        draw_circle(_bx, _by, _br, true);
        draw_set_alpha(0.22);
        draw_circle(_bx, _by, _br, false);
    }

    for (var _j = 0; _j < 4; _j++)
    {
        var _line_y = _gh * (0.22 + 0.15 * _j) + 6 * sin(current_time / 360 + _j * 0.9);
        draw_set_alpha(0.06);
        draw_set_color(make_color_rgb(100, 185, 220));
        draw_line_width(_panel_x1 + 20, _line_y, _panel_x2 - 20, _line_y, 2);
    }

    draw_set_alpha(0.16 * _fade_panel);
    draw_set_color(make_color_rgb(30, 114, 160));
    draw_roundrect(_panel_x1, _panel_y1, _panel_x2, _panel_y2, false);
    draw_set_alpha(1);
    draw_set_color(make_color_rgb(72, 214, 214));
    draw_rectangle(_panel_x1, _panel_y1, _panel_x2, _panel_y1 + 4, false);
    draw_set_color(make_color_rgb(200, 174, 92));
    draw_roundrect(_panel_x1, _panel_y1, _panel_x2, _panel_y2, true);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_font(fnt_main);
    draw_set_alpha(_fade_text);
    draw_set_color(make_color_rgb(182, 220, 232));
    draw_text(_gw * 0.5, _gh * 0.18, "mythic indie studio");

    if (sprite_exists(spr_logo_eclipse_wire))
    {
        var _sw = sprite_get_width(spr_logo_eclipse_wire);
        var _sh = sprite_get_height(spr_logo_eclipse_wire);
        var _max_w = _gw * 0.42;
        var _max_h = _gh * 0.34;
        var _scale = min(_max_w / _sw, _max_h / _sh);
        draw_set_alpha(_fade_logo * _pulse);
        draw_sprite_ext(spr_logo_eclipse_wire, 0, _gw * 0.5, _logo_y, _scale, _scale, 0, c_white, _fade_logo * _pulse);
    }

    draw_set_font(fnt_title);
    draw_set_alpha(_fade_text);
    draw_set_color(c_white);
    draw_text(_gw * 0.5, _gh * 0.66, "Eclipse Wire");

    draw_set_font(fnt_main);
    draw_set_color(make_color_rgb(214, 222, 230));
    draw_text(_gw * 0.5, _gh * 0.73, "представляє / presents");
    draw_set_color(make_color_rgb(188, 204, 214));
    draw_text(_gw * 0.5, _gh * 0.78, "Young Poseidon");

    var _hint_w = 430;
    var _hint_h = 42;
    var _hint_x = _gw * 0.5 - _hint_w * 0.5;
    var _hint_y = _gh * 0.865 - _hint_h * 0.5;
    draw_set_alpha(0.16 * _fade_hint);
    draw_set_color(make_color_rgb(110, 190, 215));
    draw_roundrect(_hint_x, _hint_y, _hint_x + _hint_w, _hint_y + _hint_h, false);
    draw_set_alpha(_fade_hint);
    draw_set_color(make_color_rgb(200, 174, 92));
    draw_roundrect(_hint_x, _hint_y, _hint_x + _hint_w, _hint_y + _hint_h, true);
    draw_set_color(make_color_rgb(232, 207, 124));
    draw_text(_gw * 0.5, _hint_y + _hint_h * 0.5, "Space / Enter / Click — пропустити / skip");

    yp_draw_cursor();

    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_font(-1);

if (startup_transition_alpha > 0)
{
    draw_set_alpha(startup_transition_alpha);
    draw_set_color(make_color_rgb(2, 6, 14));
    draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
    draw_set_alpha(1);
}
    exit;
}

if (startup_state == "language")
{
    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();
    var _flag_w = min(240, _gw * 0.22);
    var _flag_h = round(_flag_w * 0.62);
    var _gap = max(36, _gw * 0.06);
    var _total_w = _flag_w * 2 + _gap;
    var _x1 = (_gw - _total_w) * 0.5;
    var _y1 = clamp(_gh * 0.36, 235, 320);
    var _x2 = _x1 + _flag_w + _gap;
    var _y2 = _y1;
    var _panel_x1 = max(84, _gw * 0.11);
    var _panel_y1 = 76;
    var _panel_x2 = _gw - _panel_x1;
    var _panel_y2 = _gh - 76;

    var _draw_flag_ua = function(_x, _y, _w, _h)
    {
        draw_set_color(make_color_rgb(40, 108, 214));
        draw_rectangle(_x, _y, _x + _w, _y + _h * 0.5, false);
        draw_set_color(make_color_rgb(236, 205, 66));
        draw_rectangle(_x, _y + _h * 0.5, _x + _w, _y + _h, false);
    };

    var _draw_flag_uk = function(_x, _y, _w, _h)
    {
        draw_set_color(make_color_rgb(30, 64, 136));
        draw_rectangle(_x, _y, _x + _w, _y + _h, false);
        draw_set_color(c_white);
        draw_line_width(_x, _y, _x + _w, _y + _h, 16);
        draw_line_width(_x + _w, _y, _x, _y + _h, 16);
        draw_rectangle(_x + _w * 0.42, _y, _x + _w * 0.58, _y + _h, false);
        draw_rectangle(_x, _y + _h * 0.42, _x + _w, _y + _h * 0.58, false);
        draw_set_color(make_color_rgb(198, 26, 42));
        draw_line_width(_x, _y, _x + _w, _y + _h, 8);
        draw_line_width(_x + _w, _y, _x, _y + _h, 8);
        draw_rectangle(_x + _w * 0.46, _y, _x + _w * 0.54, _y + _h, false);
        draw_rectangle(_x, _y + _h * 0.46, _x + _w, _y + _h * 0.54, false);
    };

    draw_set_alpha(1);
    draw_set_color(make_color_rgb(4, 10, 20));
    draw_rectangle(0, 0, _gw, _gh, false);

    // Atmospheric underwater background.
    draw_set_alpha(0.08);
    draw_set_color(make_color_rgb(88, 184, 214));
    for (var _k = 0; _k < 5; _k++)
    {
        var _ray_x = _gw * (0.12 + 0.18 * _k) + sin(current_time / 700 + _k) * 18;
        draw_triangle(_ray_x, 0, _ray_x + 48, 0, _ray_x - 100, _gh, false);
    }
    draw_set_alpha(1);

    draw_set_alpha(0.97);
    draw_set_color(make_color_rgb(8, 20, 36));
    draw_roundrect(_panel_x1, _panel_y1, _panel_x2, _panel_y2, false);
    draw_set_alpha(1);
    draw_set_color(make_color_rgb(84, 214, 210));
    draw_rectangle(_panel_x1, _panel_y1, _panel_x2, _panel_y1 + 4, false);
    draw_set_color(make_color_rgb(200, 174, 92));
    draw_roundrect(_panel_x1, _panel_y1, _panel_x2, _panel_y2, true);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    draw_set_font(fnt_title);
    draw_set_color(c_white);
    draw_text(_gw * 0.5, _panel_y1 + 54, "Оберіть мову / Choose language");

    draw_set_font(fnt_main);
    draw_set_color(make_color_rgb(188, 222, 235));
    draw_text(_gw * 0.5, _panel_y1 + 104, "Перший запуск гри / First launch");
    draw_set_color(make_color_rgb(152, 174, 196));
    draw_text(_gw * 0.5, _panel_y1 + 136, "Налаштуйте мову перед початком мандрівки / Set your language before the voyage begins");

    var _labels = ["Українська", "English"];
    for (var _i = 0; _i < 2; _i++)
    {
        var _bx = (_i == 0) ? _x1 : _x2;
        var _by = (_i == 0) ? _y1 : _y2;
        var _selected = (startup_lang_selected == _i);
        var _border = _selected ? make_color_rgb(225, 193, 98) : make_color_rgb(98, 128, 156);
        var _fill = _selected ? 0.18 : 0.08;

        draw_set_alpha(_fill);
        draw_set_color(make_color_rgb(132, 212, 234));
        draw_roundrect(_bx - 16, _by - 18, _bx + _flag_w + 16, _by + _flag_h + 72, false);
        draw_set_alpha(1);
        draw_set_color(_border);
        draw_roundrect(_bx - 16, _by - 18, _bx + _flag_w + 16, _by + _flag_h + 72, true);
        draw_rectangle(_bx - 10, _by - 12, _bx + _flag_w + 10, _by + _flag_h + 62, true);

        if (_i == 0) _draw_flag_ua(_bx, _by, _flag_w, _flag_h);
        else _draw_flag_uk(_bx, _by, _flag_w, _flag_h);

        if (_selected)
        {
            draw_set_color(make_color_rgb(225, 193, 98));
            draw_text(_bx + _flag_w * 0.5, _by + _flag_h + 28, "Вибрано / Selected");
        }

        draw_set_color(c_white);
        draw_text(_bx + _flag_w * 0.5, _by + _flag_h + 56, _labels[_i]);
    }

    draw_set_color(make_color_rgb(210, 220, 228));
    draw_text(_gw * 0.5, _panel_y2 - 74, "A/D або ←/→ — вибір   •   Enter або клік — підтвердити");
    draw_set_color(make_color_rgb(154, 176, 194));
    draw_text(_gw * 0.5, _panel_y2 - 40, "Пізніше мову можна змінити в Налаштуваннях / You can change it later in Settings");

    yp_draw_cursor();

    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_font(-1);

if (startup_transition_alpha > 0)
{
    draw_set_alpha(startup_transition_alpha);
    draw_set_color(make_color_rgb(2, 6, 14));
    draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
    draw_set_alpha(1);
}
    exit;
}

yp_menu_draw();
yp_draw_cursor();

if (startup_transition_alpha > 0)
{
    draw_set_alpha(startup_transition_alpha);
    draw_set_color(make_color_rgb(2, 6, 14));
    draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
    draw_set_alpha(1);
}
