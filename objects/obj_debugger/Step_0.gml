
/// @description obj_debugger — Step Event

// ════ F1: ВКЛ/ВИКЛ ДЕБАГЕР ════
if (keyboard_check_pressed(vk_f1))
{
    is_open = !is_open;
}

if (!is_open) {
    // Навіть закритий — застосовуємо god_mode і fast_mode
    _apply_modes();
    exit;
}

// ════ ГАРЯЧІ КЛАВІШІ (лише коли відкрито) ════

// F2 — God Mode (невразливість)
if (keyboard_check_pressed(vk_f2))
{
    god_mode = !god_mode;
    debug_log(god_mode ? "God Mode ON" : "God Mode OFF");
}

// F3 — Швидкий режим (x3 швидкість)
if (keyboard_check_pressed(vk_f3))
{
    fast_mode = !fast_mode;
    debug_log(fast_mode ? "Fast Mode ON (x3)" : "Fast Mode OFF");
}

// F4 — Розблокувати всю зброю
if (keyboard_check_pressed(vk_f4) && instance_exists(obj_player))
{
    with (obj_player)
    {
        for (var _i = 0; _i < 6; _i++)
            weapon_unlocked[_i] = true;
        current_weapon = 0;
    }
    debug_log("Вся зброя розблокована");
}

// F5 — Повне HP
if (keyboard_check_pressed(vk_f5) && instance_exists(obj_player))
{
    obj_player.hp = obj_player.max_hp;
    debug_log("HP відновлено");
}

// F6 — Показ хітбоксів
if (keyboard_check_pressed(vk_f6))
{
    show_hitbox = !show_hitbox;
    debug_log(show_hitbox ? "Хітбокси: ON" : "Хітбокси: OFF");
}

// F7 — Показ швидкості
if (keyboard_check_pressed(vk_f7))
{
    show_velocity = !show_velocity;
}

// F8 — Вбити всіх ворогів у кімнаті
if (keyboard_check_pressed(vk_f8))
{
    var _killed = 0;
    with (obj_enemy) { instance_destroy(); _killed++; }
    debug_log("Вбито ворогів: " + string(_killed));
}

// F9 — Максимальні предмети
if (keyboard_check_pressed(vk_f9) && instance_exists(obj_player))
{
    with (obj_player)
    {
        potion_heal_count     = 9;
        potion_strength_count = 9;
        potion_speed_count    = 9;
        perm_spd_bonus        = 2;
        max_hp                = 9;
        hp                    = max_hp;
    }
    debug_log("Всі предмети отримано (макс)");
}

// F10 — Ключ Олімпу
if (keyboard_check_pressed(vk_f10) && instance_exists(obj_player))
{
    obj_player.has_olympus_key = true;
    debug_log("Ключ Олімпу отримано");
}

// ════ ЗАСТОСУВАННЯ РЕЖИМІВ ════
_apply_modes();

// ════ ВКЛАДКИ (1/2/3/4) ════
if (keyboard_check_pressed(ord("1")) && is_open) active_tab = 0;
if (keyboard_check_pressed(ord("2")) && is_open) active_tab = 1;
if (keyboard_check_pressed(ord("3")) && is_open) active_tab = 2;
if (keyboard_check_pressed(ord("4")) && is_open) active_tab = 3;

// ════ СКРОЛ СПИСКУ КІМНАТ ════
if (active_tab == 0)
{
    if (mouse_wheel_up()   && is_open) room_scroll = max(0, room_scroll - 1);
    if (mouse_wheel_down() && is_open)
        room_scroll = min(array_length(room_list) - 1, room_scroll + 1);
}

// ════ FPS ІСТОРІЯ ════
fps_history[@ fps_index] = fps_real;
fps_index = (fps_index + 1) mod 60;