/// @description
/// obj_room_exit — Create Event

// ════ НАЛАШТУВАННЯ (встановлюються через Instance Creation Code) ════
 
// Кімната призначення
target_room      = rm_sea_1;    // Замінюється в кожному екземплярі
 
// Де з'явиться гравець у кімнаті призначення (пікселі)
// -1 = використати spawn_tag (знайти obj_room_exit з тим самим тегом)
spawn_x          = -1;
spawn_y          = -1;
 
// Тег для спарювання входу/виходу
// Наприклад: "sea_to_coast" — і тут і там однакий тег
// Тоді гравець з'явиться біля відповідного виходу в новій кімнаті
spawn_tag        = "";
 
// Напрямок виходу (для анімації і підказки)
// "right", "left", "up", "down"
exit_direction   = "right";
 
// Ширина/висота зони переходу
exit_width       = 32;
exit_height      = 96;
 
// Потрібна зброя/ключ для проходження? ("" = вільний прохід)
// Приклад: "pickaxe"  "key"  "scythe"  ""
required_item    = "";
 
// Чи заблокований (наприклад до перемоги над босом)
is_locked        = false;
lock_reason      = "";        // Текст пояснення чому заблокований
 
// Показувати підказку [F]?
show_prompt      = true;
 
// ════ ВНУТРІШНІ ЗМІННІ ════
player_in_range  = false;
prompt_alpha     = 0;
lock_shake       = 0;         // Анімація "затрусити" при спробі пройти заблокований
 
// ════ КОЛЬОРИ ПО НАПРЯМКУ ════
_dir_color = make_color_rgb(80, 140, 220);
switch (exit_direction)
{
    case "right": _dir_color = make_color_rgb(80,  180, 120); break;
    case "left":  _dir_color = make_color_rgb(80,  130, 220); break;
    case "up":    _dir_color = make_color_rgb(200, 160, 60);  break;
    case "down":  _dir_color = make_color_rgb(160, 80,  200); break;
}

// Функція спроби переходу:
_try_enter = function()
{
    // ---- Перевірка блокування ----
    if (is_locked)
    {
        lock_shake = 20;
        if (instance_exists(obj_ui_controller) && lock_reason != "")
            obj_ui_controller.show_hint(lock_reason, 180);
        return;   // ← зупиняємось
    }

    // ---- Перевірка потрібного предмета ----
    if (required_item != "" && instance_exists(obj_player))
    {
        var _has = false;
        switch (required_item)
        {
            case "pickaxe": _has = obj_player.weapon_unlocked[2]; break;
            case "scythe":  _has = obj_player.weapon_unlocked[3]; break;
            case "oar":     _has = obj_player.weapon_unlocked[4]; break;
            case "key":     _has = obj_player.has_olympus_key;    break;
            case "sword":   _has = obj_player.weapon_unlocked[5]; break;
            case "spear":   _has = obj_player.weapon_unlocked[1]; break;
            case "trident": _has = obj_player.weapon_unlocked[0]; break;
        }

        if (!_has)
        {
            lock_shake = 20;
            if (instance_exists(obj_ui_controller))
                obj_ui_controller.show_hint(lc("exit_need_" + required_item), 210);
            return;   // ← зупиняємось, предмета немає
        }
    }

    // ---- Все перевірено — переходимо ----
    global.spawn_from_tag = spawn_tag;
    global.spawn_x_manual = spawn_x;
    global.spawn_y_manual = spawn_y;
    global.came_from_room = room;

    // ---- Запускаємо перехід ----
    if (instance_exists(obj_room_transition))
    {
        // Використовуємо існуючий persistent об'єкт
        obj_room_transition.target_room = target_room;
        obj_room_transition.state       = 0;   // ← запускаємо затемнення!
    }
    else
    {
        // Створюємо новий якщо не існує
        var _trans        = instance_create_layer(0, 0, "Instances", obj_room_transition);
        _trans.target_room = target_room;
        _trans.state       = 0;   // ← запускаємо затемнення!
    }
};