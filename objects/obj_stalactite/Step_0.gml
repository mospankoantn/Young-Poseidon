/// @description 
/// obj_stalactite — Step Event

if (stones_left <= 0) { instance_destroy(); exit; }
if (hit_cd > 0) hit_cd--;
 
// Гравець б'є кайлом (E або F) поблизу
if (!instance_exists(obj_player)) exit;
var _dist = distance_to_object(obj_player);
 
if (_dist <= interact_range && hit_cd <= 0
    && !obj_player.is_dead && obj_player.hp > 0
    && obj_player.current_weapon == 2   // Кайло
    && (keyboard_check_pressed(ord("E")) || keyboard_check_pressed(ord("F"))))
{
    stones_left--;
    obj_player._play_weapon_action("special");
    hit_cd = room_speed * 0.5;
 
    // Створюємо камінь що падає
    var _stone    = instance_create_layer(x + irandom_range(-20, 20), y,
                        "Instances", obj_falling_stone);
    _stone.damage = 10;   // 10 шкоди і гравцю і Харону
 
    // audio_play_sound(snd_stalactite_hit, 1, false);
 
    // Оновлюємо спрайт (тріщини)
    image_index = clamp(4 - stones_left, 0, 3);
}
