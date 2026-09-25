/// @description Зіткнення з ворогом
/// obj_player — Collision with obj_enemy

// ВАЖЛИВО: ця подія спрацьовує КОЖЕН кадр поки є зіткнення,
// тому використовуємо is_damage як захист від подвійного урону

if (!is_dead && hp > 0 && !is_damage && enemy_can_damage(other))
{
    if (variable_instance_exists(other, "contact_damage_enabled") && !other.contact_damage_enabled) exit;
    // Не кожен нащадок obj_enemy має контактну атаку (наприклад, Мойри).
    // Відсутній atk трактуємо як 0, щоб зіткнення не падало з runtime error.
    var _contact_damage = variable_instance_exists(other, "atk") ? max(0, other.atk) : 0;
    if (_contact_damage > 0)
    {
        hp -= _contact_damage;

        // Knockback: відштовхуємо гравця від ворога.
        var _dir = point_direction(other.x, other.y, x, y);
        hspd  = lengthdir_x(6, _dir);
        vspd  = -4;

        // Вмикаємо невразливість лише після реальної контактної шкоди.
        is_damage = true;
        alarm[0]  = room_speed;   // 1 секунда невразливості

        // audio_play_sound(snd_player_hurt, 1, false);
    }
}
