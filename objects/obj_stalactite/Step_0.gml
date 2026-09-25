if (instance_exists(obj_player) && point_distance(x, y, obj_player.x, obj_player.y) <= 120)
    yp_trigger_hint("stalactite", "hint_stalactite", 240);

/// @description
/// obj_stalactite — Step Event

if (stones_left <= 0)
{
    world_state_mark_instance(id, "destroyed");
    instance_destroy();
    exit;
}
if (hit_cd > 0) hit_cd--;
if (strike_flash > 0) strike_flash--;

// Гравець б'є кайлом (E або F) поблизу
if (!instance_exists(obj_player)) exit;
var _dist = distance_to_object(obj_player);

if (_dist <= interact_range && hit_cd <= 0
    && !obj_player.is_dead && obj_player.hp > 0
    && obj_player.current_weapon == 2   // Кайло
    && (yp_input("E",true) || yp_input("F",true)))
{
    stones_left--;
    strike_flash = 20;
    yp_sfx("stone", x);
    obj_player._play_weapon_action("special");
    hit_cd = room_speed * 0.5;

    // Створюємо камінь що падає
    var _stone    = instance_create_layer((bbox_left+bbox_right)*0.5 - 16, bbox_bottom + 2,
                        "Instances", obj_falling_stone);
    _stone.damage = 10;   // 10 шкоди і гравцю і Харону

    // audio_play_sound(snd_stalactite_hit, 1, false);

    // Оновлюємо спрайт (тріщини)
    image_index = 0;
}
