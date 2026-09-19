/// @description obj_debugger — Draw GUI Event

// ── Завжди: мінімальний рядок статусу ──
var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

if (font_exists(fnt_main)) draw_set_font(fnt_main);

if (!is_open)
{
    draw_set_alpha(1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_font(-1);
    exit;
}

// Статус рядок (завжди видний навіть коли закрито)
var _status_y = _gh - 20;
draw_set_alpha(0.7);
draw_set_color(c_black);
draw_rectangle(0, _status_y - 2, 500, _gh, false);
draw_set_alpha(1);

var _status = "F1-Debug";
if (god_mode)   _status += "  [GOD]";
if (fast_mode)  _status += "  [x3]";
if (show_hitbox)_status += "  [BOX]";
if (instance_exists(obj_player))
    _status += "  HP:" + string(obj_player.hp)
            + "  X:" + string(floor(obj_player.x))
            + "  Y:" + string(floor(obj_player.y));

draw_set_halign(fa_left);
draw_set_valign(fa_bottom);
draw_set_color(make_color_rgb(180, 255, 180));
draw_text(6, _gh - 3, _status);

// ════════════════════════════════════════
// ГОЛОВНА ПАНЕЛЬ
// ════════════════════════════════════════
var _px = panel_x;
var _py = panel_y;
var _pw = panel_w;
var _ph = panel_h;

// Тло
draw_set_alpha(0.92);
draw_set_color(make_color_rgb(12, 14, 20));
draw_rectangle(_px, _py, _px + _pw, _py + _ph, false);
draw_set_alpha(1);
draw_set_color(make_color_rgb(60, 80, 120));
draw_rectangle(_px, _py, _px + _pw, _py + _ph, true);

// ── Заголовок ──
draw_set_alpha(0.95);
draw_set_color(make_color_rgb(20, 30, 55));
draw_rectangle(_px, _py, _px + _pw, _py + 28, false);
draw_set_alpha(1);
draw_set_color(make_color_rgb(100, 200, 100));
draw_set_halign(fa_left);
draw_set_valign(fa_middle);
draw_text(_px + 8, _py + 14, "ДЕБАГЕР   [F1 закрити]");

// FPS у заголовку
var _avg_fps = 0;
for (var _fi = 0; _fi < 60; _fi++) _avg_fps += fps_history[_fi];
_avg_fps = floor(_avg_fps / 60);
var _fps_col = make_color_rgb(255, 80, 80);
if (_avg_fps >= 55) _fps_col = make_color_rgb(100, 255, 100);
else if (_avg_fps >= 30) _fps_col = make_color_rgb(255, 200, 50);
draw_set_color(_fps_col);
draw_set_halign(fa_right);
draw_text(_px + _pw - 8, _py + 14, string(_avg_fps) + " fps");

// ── ВКЛАДКИ ──
var _tabs      = ["Карта", "Гравець", "Вороги", "Предмети"];
var _tab_w     = _pw / array_length(_tabs);
var _tab_y     = _py + 28; 
var _tab_h     = 26;
var _mx        = device_mouse_x_to_gui(0);
var _my        = device_mouse_y_to_gui(0);

for (var _ti = 0; _ti < array_length(_tabs); _ti++)
{
    var _tx     = _px + _ti * _tab_w;
    var _tsel   = (_ti == active_tab);
    var _thover = (_mx >= _tx && _mx < _tx + _tab_w
                && _my >= _tab_y && _my < _tab_y + _tab_h);

    draw_set_alpha(_tsel ? 0.9 : (_thover ? 0.5 : 0.25));
    draw_set_color(_tsel ? make_color_rgb(40, 80, 160) : make_color_rgb(20, 30, 50));
    draw_rectangle(_tx, _tab_y, _tx + _tab_w - 1, _tab_y + _tab_h, false);

    draw_set_alpha(1);
    draw_set_color(_tsel ? c_white : make_color_rgb(140, 160, 200));
    draw_set_halign(fa_center);
    draw_text(_tx + _tab_w / 2, _tab_y + _tab_h / 2, _tabs[_ti]);

    if (_thover && mouse_check_button_pressed(mb_left))
        active_tab = _ti;
}

var _content_y = _tab_y + _tab_h + 6;
var _content_h = _ph - (_content_y - _py) - 6;

draw_set_halign(fa_left);
draw_set_valign(fa_top);

// ════════════════════════════════════════
// ВКЛАДКА 0: КАРТА (перехід між кімнатами)
// ════════════════════════════════════════
if (active_tab == 0)
{
    var _row_h      = 22;
    var _visible    = floor(_content_h / _row_h);
    var _total      = array_length(room_list);
    var _max_scroll = max(0, _total - _visible);
    room_scroll     = clamp(room_scroll, 0, _max_scroll);

    for (var _ri = 0; _ri < _visible; _ri++)
    {
        var _idx  = _ri + room_scroll;
        if (_idx >= _total) break;

        var _entry    = room_list[_idx];
        var _name     = _entry[0];
        var _rm       = _entry[1];
        var _ry       = _content_y + _ri * _row_h;
        var _is_sep   = (_rm == -1);
        var _is_cur   = (!_is_sep && _rm == room);
        var _hovering = (!_is_sep
                      && _mx >= _px + 4    && _mx <= _px + _pw - 4
                      && _my >= _ry        && _my <= _ry + _row_h - 2);

        if (_is_sep)
        {
            // Роздільник зони
            draw_set_alpha(0.6);
            draw_set_color(make_color_rgb(30, 45, 75));
            draw_rectangle(_px + 4, _ry + 2, _px + _pw - 4, _ry + _row_h - 2, false);
            draw_set_alpha(1);
            draw_set_color(make_color_rgb(100, 140, 200));
            draw_text(_px + 10, _ry + 4, _name);
        }
        else
        {
            // Рядок кімнати
            if (_is_cur)
            {
                draw_set_alpha(0.5);
                draw_set_color(make_color_rgb(30, 80, 30));
                draw_rectangle(_px + 4, _ry, _px + _pw - 4, _ry + _row_h - 1, false);
            }
            else if (_hovering)
            {
                draw_set_alpha(0.3);
                draw_set_color(make_color_rgb(40, 60, 120));
                draw_rectangle(_px + 4, _ry, _px + _pw - 4, _ry + _row_h - 1, false);
            }
            draw_set_alpha(1);

            // Маркер поточної кімнати
            draw_set_color(_is_cur ? make_color_rgb(100, 255, 100)
                         : (_hovering ? c_yellow : make_color_rgb(160, 180, 220)));
            draw_text(_px + 18, _ry + 3,
                (_is_cur ? "► " : "  ") + _name);

            // Клік = телепорт
            if (_hovering && mouse_check_button_pressed(mb_left))
            {
                debug_log("Перехід: " + _name);
                if (instance_exists(obj_room_transition))
                {
                    obj_room_transition.target_room = _rm;
                    obj_room_transition.state       = 0;
                }
                else
                    room_goto(_rm);
            }
        }
    }

    // Смуга прокрутки
    if (_total > _visible)
    {
        var _sb_x    = _px + _pw - 8;
        var _sb_h    = _content_h;
        var _thumb_h = max(20, _sb_h * _visible / _total);
        var _thumb_y = _content_y + (_sb_h - _thumb_h) * (room_scroll / _max_scroll);

        draw_set_alpha(0.2);
        draw_set_color(c_white);
        draw_rectangle(_sb_x, _content_y, _sb_x + 5, _content_y + _sb_h, false);
        draw_set_alpha(0.6);
        draw_set_color(make_color_rgb(100, 150, 255));
        draw_rectangle(_sb_x, _thumb_y, _sb_x + 5, _thumb_y + _thumb_h, false);
        draw_set_alpha(1);
    }
}

// ════════════════════════════════════════
// ВКЛАДКА 1: ГРАВЕЦЬ
// ════════════════════════════════════════
else if (active_tab == 1)
{
    var _ly = _content_y + 4;
    var _lh = 20;

    // ── Кнопки режимів ──
    var _btns = [
        ["F2  God Mode",    god_mode,   make_color_rgb(255, 80, 80)],
        ["F3  Fast x3",     fast_mode,  make_color_rgb(255, 200, 50)],
        ["F6  Хітбокси",    show_hitbox,make_color_rgb(100, 200, 255)],
        ["F7  Швидкість",   show_velocity, make_color_rgb(180, 255, 180)],
    ];

    for (var _bi = 0; _bi < array_length(_btns); _bi++)
    {
        var _bx   = _px + 8 + _bi * ((_pw - 16) / 4);
        var _bw   = (_pw - 16) / 4 - 4;
        var _by   = _ly;
        var _bon  = _btns[_bi][1];
        var _bcol = _btns[_bi][2];
        var _bhov = (_mx >= _bx && _mx <= _bx + _bw
                  && _my >= _by && _my <= _by + 24);

        draw_set_alpha(_bon ? 0.85 : (_bhov ? 0.4 : 0.2));
        draw_set_color(_bon ? _bcol : make_color_rgb(40, 50, 70));
        draw_rectangle(_bx, _by, _bx + _bw, _by + 24, false);
        draw_set_alpha(_bon ? 0.8 : 0.3);
        draw_set_color(_bcol);
        draw_rectangle(_bx, _by, _bx + _bw, _by + 24, true);
        draw_set_alpha(1);

        draw_set_color(_bon ? c_white : make_color_rgb(140, 160, 200));
        draw_set_halign(fa_center);
        draw_text(_bx + _bw / 2, _by + 12, _btns[_bi][0]);

        if (_bhov && mouse_check_button_pressed(mb_left))
        {
            switch (_bi)
            {
                case 0: god_mode      = !god_mode;     break;
                case 1: fast_mode     = !fast_mode;    break;
                case 2: show_hitbox   = !show_hitbox;  break;
                case 3: show_velocity = !show_velocity;break;
            }
        }
    }
    draw_set_halign(fa_left);
    _ly += 32;

    // ── Статистика гравця ──
    if (instance_exists(obj_player))
    {
        var _p = obj_player;
        var _stats = [
            ["Позиція",     string(floor(_p.x)) + ", " + string(floor(_p.y))],
            ["HP",          string(_p.hp) + " / " + string(_p.max_hp)],
            ["hspd/vspd",   string_format(_p.hspd, 4, 1) + " / " + string_format(_p.vspd, 4, 1)],
            ["SPD",         string(_p.spd) + " + " + string(_p.perm_spd_bonus) + " perm"],
            ["Зброя",       (_p.current_weapon >= 0) ? _p.weapon_names[_p.current_weapon] : "—"],
            ["Буф",         (_p.buff_duration > 0) ? string(ceil(_p.buff_duration/60)) + "с" : "—"],
            ["Зілля Z/X/C", string(_p.potion_heal_count) + " / "
                          + string(_p.potion_strength_count) + " / "
                          + string(_p.potion_speed_count)],
            ["Frozen",      string(_p.is_frozen) + " (" + string(_p.freeze_timer) + ")"],
            ["Кімната",     room_get_name(room)],
        ];

        for (var _si = 0; _si < array_length(_stats); _si++)
        {
            var _sy = _ly + _si * _lh;
            draw_set_alpha(0.15);
            draw_set_color(_si mod 2 == 0 ? make_color_rgb(30, 40, 70) : c_black);
            draw_rectangle(_px + 4, _sy, _px + _pw - 4, _sy + _lh, false);
            draw_set_alpha(1);

            draw_set_color(make_color_rgb(140, 160, 220));
            draw_text(_px + 10, _sy + 3, _stats[_si][0] + ":");
            draw_set_color(c_white);
            draw_text(_px + 120, _sy + 3, _stats[_si][1]);
        }
        _ly += array_length(_stats) * _lh + 8;
    }

    // ── Кнопки швидких дій ──
    var _action_btns = [
        ["F4 Вся зброя",    vk_f4],
        ["F5 Повне HP",     vk_f5],
        ["F9 Всі предмети", vk_f9],
        ["F10 Ключ",        vk_f10],
    ];

    for (var _abi = 0; _abi < array_length(_action_btns); _abi++)
    {
        var _abx  = _px + 8;
        var _aby  = _ly + _abi * 26;
        var _abw  = _pw - 16;
        var _abhov = (_mx >= _abx && _mx <= _abx + _abw
                   && _my >= _aby && _my <= _aby + 22);

        draw_set_alpha(_abhov ? 0.5 : 0.25);
        draw_set_color(make_color_rgb(40, 60, 100));
        draw_rectangle(_abx, _aby, _abx + _abw, _aby + 22, false);
        draw_set_alpha(1);
        draw_set_color(_abhov ? c_yellow : make_color_rgb(160, 180, 220));
        draw_set_halign(fa_center);
        draw_text(_abx + _abw/2, _aby + 11, _action_btns[_abi][0]);

        if (_abhov && mouse_check_button_pressed(mb_left))
            keyboard_key_press(_action_btns[_abi][1]);
    }
    draw_set_halign(fa_left);
}

// ════════════════════════════════════════
// ВКЛАДКА 2: ВОРОГИ
// ════════════════════════════════════════
else if (active_tab == 2)
{
    var _ly  = _content_y + 4;
    var _lh  = 20;
    var _en  = instance_number(obj_enemy);

    // Загальна кількість
    draw_set_color(make_color_rgb(255, 150, 100));
    draw_text(_px + 10, _ly, "Ворогів у кімнаті: " + string(_en));
    _ly += 26;

    // Кнопка "Вбити всіх"
    var _kbx  = _px + 8;
    var _kby  = _ly;
    var _kbw  = _pw - 16;
    var _kbhov = (_mx >= _kbx && _mx <= _kbx + _kbw
               && _my >= _kby && _my <= _kby + 24);

    draw_set_alpha(_kbhov ? 0.7 : 0.4);
    draw_set_color(make_color_rgb(120, 20, 20));
    draw_rectangle(_kbx, _kby, _kbx + _kbw, _kby + 24, false);
    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_text(_kbx + _kbw / 2, _kby + 12, "F8  Вбити всіх ворогів");
    draw_set_halign(fa_left);

    if (_kbhov && mouse_check_button_pressed(mb_left))
    {
        var _killed = 0;
        with (obj_enemy) { instance_destroy(); _killed++; }
        debug_log("Вбито: " + string(_killed));
    }
    _ly += 32;

    // Список ворогів
    for (var _ei = 0; _ei < min(_en, floor((_content_h - 60) / _lh)); _ei++)
    {
        var _inst = instance_find(obj_enemy, _ei);
        if (!instance_exists(_inst)) continue;

        var _ey = _ly + _ei * _lh;

        draw_set_alpha(0.15);
        draw_set_color(_ei mod 2 == 0 ? make_color_rgb(30, 20, 20) : c_black);
        draw_rectangle(_px + 4, _ey, _px + _pw - 4, _ey + _lh, false);
        draw_set_alpha(1);

        var _ename = object_get_name(_inst.object_index);
        var _ehp   = variable_instance_exists(_inst, "hp")
                     ? string(_inst.hp) : "?";
        var _estate = variable_instance_exists(_inst, "state")
                      ? string(_inst.state) : "?";

        draw_set_color(make_color_rgb(255, 140, 100));
        draw_text(_px + 10, _ey + 3, _ename);
        draw_set_color(make_color_rgb(140, 160, 220));
        draw_text(_px + 170, _ey + 3,
            "HP:" + _ehp + "  St:" + _estate
            + "  [" + string(floor(_inst.x)) + "," + string(floor(_inst.y)) + "]");
    }
}

// ════════════════════════════════════════
// ВКЛАДКА 3: ПРЕДМЕТИ
// ════════════════════════════════════════
else if (active_tab == 3)
{
    var _ly = _content_y + 4;

    // Зброя
    draw_set_color(make_color_rgb(200, 200, 100));
    draw_text(_px + 10, _ly, "ЗБРОЯ:");
    _ly += 22;

    if (instance_exists(obj_player))
    {
        var _p = obj_player;
        for (var _wi = 0; _wi < 6; _wi++)
        {
            var _wy     = _ly + _wi * 22;
            var _wsel   = (_wi == _p.current_weapon);
            var _wunl   = _p.weapon_unlocked[_wi];
            var _whov   = (_mx >= _px + 8 && _mx <= _px + _pw - 8
                        && _my >= _wy     && _my <= _wy + 20);

            draw_set_alpha(_wunl ? 0.3 : 0.1);
            draw_set_color(_wsel ? make_color_rgb(50, 80, 50) : make_color_rgb(20, 25, 40));
            draw_rectangle(_px + 8, _wy, _px + _pw - 8, _wy + 20, false);
            draw_set_alpha(1);

            draw_set_color(_wsel ? make_color_rgb(100, 255, 100)
                         : (_wunl ? c_white : make_color_rgb(80, 80, 100)));
            draw_text(_px + 14, _wy + 3,
                (_wsel ? "► " : "  ")
                + _p.weapon_names[_wi]
                + "  ATK:" + string(_p.weapon_atk[_wi])
                + "  SPD×" + string(_p.weapon_spd_mult[_wi]));

            // Замок якщо заблокована
            if (!_wunl)
            {
                draw_set_color(make_color_rgb(255, 100, 100));
                draw_text(_px + _pw - 24, _wy + 3, "[🔒]");
            }

            // Клік = розблокувати і переключити
            if (_whov && mouse_check_button_pressed(mb_left))
            {
                _p.weapon_unlocked[_wi] = true;
                _p.current_weapon       = _wi;
                debug_log("Розблоковано: " + _p.weapon_names[_wi]);
            }
        }
        _ly += 6 * 22 + 10;

        // Зілля
        draw_set_color(make_color_rgb(200, 200, 100));
        draw_text(_px + 10, _ly, "ЗІЛЛЯ:");
        _ly += 22;

        var _potions = [
            ["Здоров'я (Z)", "potion_heal_count"],
            ["Геракл  (X)",  "potion_strength_count"],
            ["Гермес  (C)",  "potion_speed_count"],
        ];

        for (var _pi = 0; _pi < 3; _pi++)
        {
            var _pot_y   = _ly + _pi * 26;
            var _pot_val = variable_instance_get(_p, _potions[_pi][1]);

            draw_set_color(make_color_rgb(140, 160, 220));
            draw_text(_px + 14, _pot_y + 3, _potions[_pi][0] + ":");
            draw_set_color(c_white);
            draw_text(_px + 150, _pot_y + 3, string(_pot_val));

            // +/- кнопки
            for (var _delta = -1; _delta <= 1; _delta += 2)
            {
                var _btnx = _px + _pw - 50 + (_delta == 1 ? 20 : 0);
                var _btnh = (_mx >= _btnx && _mx <= _btnx + 18
                          && _my >= _pot_y && _my <= _pot_y + 20);
                draw_set_alpha(_btnh ? 0.8 : 0.4);
                draw_set_color(make_color_rgb(40, 60, 100));
                draw_rectangle(_btnx, _pot_y, _btnx + 18, _pot_y + 20, false);
                draw_set_alpha(1);
                draw_set_color(_btnh ? c_yellow : c_white);
                draw_set_halign(fa_center);
                draw_text(_btnx + 9, _pot_y + 10, _delta == 1 ? "+" : "-");
                draw_set_halign(fa_left);

                if (_btnh && mouse_check_button_pressed(mb_left))
                {
                    var _new_val = clamp(_pot_val + _delta, 0, 99);
                    variable_instance_set(_p, _potions[_pi][1], _new_val);
                }
            }
        }
    }
}

// ════════════════════════════════════════
// ЖУРНАЛ ПОДІЙ (знизу панелі)
// ════════════════════════════════════════
var _log_y = _py + _ph - (array_length(log_messages) * 16) - 8;

draw_set_alpha(0.4);
draw_set_color(c_black);
draw_rectangle(_px + 2, _log_y - 4, _px + _pw - 2, _py + _ph - 2, false);
draw_set_alpha(1);

for (var _li = 0; _li < array_length(log_messages); _li++)
{
    var _la = 1 - _li * 0.12;
    draw_set_alpha(max(0.1, _la));
    draw_set_color(make_color_rgb(150, 220, 150));
    draw_text(_px + 8, _log_y + _li * 16, "> " + log_messages[_li]);
}
draw_set_alpha(1);

// ════ ХІТБОКСИ (окремий Draw поверх гри) ════
// (реалізовано в Draw End Event нижче)

// ════ СКИДАННЯ ════
draw_set_color(c_white);
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(-1);

// Debug GUI is allowed to sit above the HUD, so keep the cursor on top of it too.
if (is_open) yp_draw_cursor();
