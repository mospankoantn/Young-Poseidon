/// @description Викликається коли нова кімната завантажена
// obj_room_transition — Room Start Event

// Тепер ми в новій кімнаті — розміщуємо гравця
if (state == 1)
{
    state = 2;  // Починаємо освітлення
    room_route_exits_rebuild();
 
    if (!instance_exists(obj_player)) exit;
 
    // ---- Варіант A: spawn_tag — знаходимо відповідний вихід ----
    if (global.spawn_from_tag != "")
    {
        var _found = false;
        var _en    = instance_number(obj_room_exit);
        for (var _i = 0; _i < _en; _i++)
        {
            var _exit = instance_find(obj_room_exit, _i);
            if (instance_exists(_exit) && _exit.spawn_tag == global.spawn_from_tag)
            {
                // Ставимо гравця поруч з відповідним виходом
                var _offset_x = 0;
                var _offset_y = 0;
                switch (_exit.exit_direction)
                {
                    case "right": _offset_x = -60;  break;
                    case "left":  _offset_x =  60;  break;
                    case "up":    _offset_y =  80;  break;
                    case "down":  _offset_y = -80;  break;
                }
                obj_player.x    = _exit.x + _offset_x;
                obj_player.y    = _exit.y + _offset_y;
                obj_player.hspd = 0;
                obj_player.vspd = 0;
                _found          = true;
                break;
            }
        }
 
        if (!_found && global.came_from_room != -1)
        {
            var _fallback_count = instance_number(obj_room_exit);
            for (var _j = 0; _j < _fallback_count; _j++)
            {
                var _fallback_exit = instance_find(obj_room_exit, _j);
                if (instance_exists(_fallback_exit) && _fallback_exit.target_room == global.came_from_room)
                {
                    var _fallback_offset_x = 0;
                    var _fallback_offset_y = 0;
                    switch (_fallback_exit.exit_direction)
                    {
                        case "right": _fallback_offset_x = -60; break;
                        case "left":  _fallback_offset_x =  60; break;
                        case "up":    _fallback_offset_y =  80; break;
                        case "down":  _fallback_offset_y = -80; break;
                    }

                    obj_player.x = _fallback_exit.x + _fallback_offset_x;
                    obj_player.y = _fallback_exit.y + _fallback_offset_y;
                    obj_player.hspd = 0;
                    obj_player.vspd = 0;
                    _found = true;
                    break;
                }
            }
        }

        if (!_found && global.spawn_x_manual >= 0)
        {
            // Тег не знайдено — використовуємо ручні координати
            obj_player.x = global.spawn_x_manual;
            obj_player.y = global.spawn_y_manual;
        }
    }
    // ---- Варіант B: ручні координати ----
    else if (global.spawn_x_manual >= 0)
    {
        obj_player.x = global.spawn_x_manual;
        obj_player.y = global.spawn_y_manual;
    }
 
    // Оновлюємо UI
    if (instance_exists(obj_ui_controller))
    {
        // Назва зони встановлюється в Room Start кімнати
    }
}
