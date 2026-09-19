/// @description 
/// obj_boss_charon — Step Event

if (is_dead || !instance_exists(obj_player)) exit;
if (world_state_boss_defeated("charon"))
{
    world_state_spawn_boss_reward("charon", obj_pickup_scythe_reward, x, y);
    if (instance_exists(scythe_instance)) instance_destroy(scythe_instance);
    instance_destroy();
    exit;
}

if (hp <= 0)
{
    if (!enemy_anim_death_tick(spr_boss_charon_death)) exit;
    is_dead = true;
    world_state_mark_boss_defeated("charon");
    world_state_spawn_boss_reward("charon", obj_pickup_scythe_reward, x, y);
    // Знищуємо косу якщо летить
    if (instance_exists(scythe_instance)) instance_destroy(scythe_instance);
    instance_destroy();
    exit;
}
 
if (scythe_cd > 0) scythe_cd--;
 
// ---- РУХ ЧОВНОМ ----
x += boat_speed * move_dir;
image_xscale = move_dir;
 
if (x <= water_left)  { move_dir =  1; x = water_left;  }
if (x >= water_right) { move_dir = -1; x = water_right; }
 
// ---- КОСА-БУМЕРАНГ ----
// Кидає косу в гравця, вона летить і повертається як бумеранг
if (scythe_cd <= 0 && !instance_exists(scythe_instance))
{
    scythe_instance       = instance_create_layer(x, y - 10,
                                "Instances", obj_charon_scythe);
    scythe_instance.owner = id;
    scythe_instance.dmg   = scythe_damage;
    scythe_instance.spd   = scythe_fly_speed;
    scythe_instance.target_x = obj_player.x;
    scythe_instance.target_y = obj_player.y;
    scythe_cd = scythe_cd_max;
    enemy_anim_attack(spr_boss_charon_attack);
    // audio_play_sound(snd_charon_scythe, 1, false);
}
 
// ---- КОНТАКТНА ШКОДА (човен б'є гравця) ----
if (distance_to_object(obj_player) < 50 && !obj_player.is_damage)
{
    obj_player.hp       -= atk;
    var _kd = point_direction(x, y, obj_player.x, obj_player.y);
    obj_player.hspd     = lengthdir_x(8, _kd);
    obj_player.vspd     = -4;
    obj_player.is_damage = true;
    obj_player.alarm[0]  = room_speed;
}
