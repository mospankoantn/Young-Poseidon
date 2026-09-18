/// @description Зіткнення з ворогом
/// obj_player — Collision with obj_enemy

// ВАЖЛИВО: ця подія спрацьовує КОЖЕН кадр поки є зіткнення,
// тому використовуємо is_damage як захист від подвійного урону

if (!is_dead && hp > 0 && !is_damage)
{
    // Отримуємо шкоду від ворога
    hp -= other.atk;
 
    // Knockback: відштовхуємо гравця від ворога
    var _dir = point_direction(other.x, other.y, x, y);
    hspd  = lengthdir_x(6, _dir);
    vspd  = -4;
 
    // Вмикаємо невразливість
    is_damage = true;
    alarm[0]  = room_speed;   // 1 секунда невразливості
 
    // audio_play_sound(snd_player_hurt, 1, false);
}
