/// @description 
/// obj_falling_rocks — Step Event

switch (state)
{
    // ------ 0: ЧЕКАЄ ------
    case 0:
        // Нічого не робимо, чекаємо User Event 0
    break;
 
    // ------ 1: ПАДАЄ ------
    case 1:
        fall_spd += grv;
        if (fall_spd > 20) fall_spd = 20;  // Максимальна швидкість
 
        // Перевіряємо зіткнення з платформою
        if (place_meeting(x, y + fall_spd, obj_platform))
        {
            while (!place_meeting(x, y + 1, obj_platform))
                y += 1;
            state    = 2;
            fall_spd = 0;
            solid    = true;  // Тепер каміння є твердою перешкодою
            // audio_play_sound(snd_rock_land, 1, false);
        }
        else
        {
            y += fall_spd;
        }
 
        // Шкода гравцю під час падіння
        if (instance_exists(obj_player)
            && place_meeting(x, y, obj_player)
            && !obj_player.is_damage)
        {
            obj_player.hp       -= damage;
            obj_player.vspd     = -5;
            obj_player.hspd     = 0;
            obj_player.is_damage = true;
            obj_player.alarm[0]  = room_speed;
        }
    break;
 
    // ------ 2: ЛЕЖИТЬ ------
    case 2:
        // Каміння стало звичайною платформою-перешкодою
        // Нічого не робимо
    break;
}
 