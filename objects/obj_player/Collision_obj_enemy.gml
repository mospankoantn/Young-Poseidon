/// @description Зіткнення з ворогом
// Ви можете записать свій код в этом редакторе

if (!is_damage) // Перевіряємо, чи гравець вже не отримує шкоду
{
    // Зменшуємо HP гравця на силу атаки ворога
    with (other) // Переключаємо контекст на ворога (other)
    {
        obj_player.hp -= atk; // Звертаємось до atk ворога
        // Можна додати відштовхування гравця
        var _dir = point_direction(x, y, obj_player.x, obj_player.y);
        obj_player.vspd = -3; // Невеликий підскок
        obj_player.hspd = lengthdir_x(5, _dir);
    }
    
    is_damage = true; // Встановлюємо флаг отримання шкоди
    
    // Встановлюємо таймер невразливості (Alarm 0)
    // room_speed - це кількість кроків за секунду
    alarm[0] = room_speed * 0.5; // Невразливість на 0.5 секунди
    
    // Додати звук отримання шкоди
    // audio_play_sound(snd_player_hurt, 1, false);
}






