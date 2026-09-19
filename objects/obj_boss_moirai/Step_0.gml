/// @description 
/// obj_boss_moirai — Step Event

if (is_dead || !instance_exists(obj_player)) exit;
if (world_state_boss_defeated("moirai"))
{
    world_state_spawn_boss_reward("moirai", obj_pickup_olympus_key, x, y);
    with (obj_olympus_fire) instance_destroy();
    instance_destroy();
    exit;
}
 
if (hp <= 0)
{
    if (!enemy_anim_death_tick(spr_boss_moirai_death)) exit;
    is_dead = true;
    world_state_mark_boss_defeated("moirai");
    world_state_spawn_boss_reward("moirai", obj_pickup_olympus_key, x, y);
    // Знищуємо всі вогні
    with (obj_olympus_fire) instance_destroy();
    autosave_game();
    instance_destroy();
    exit;
}
 
if (fire_cd > 0) fire_cd--;
if (wave_cd > 0) wave_cd--;
 
// ---- ХВИЛЯ ПРИ ОТРИМАННІ ШКОДИ ----
if (hp < last_hp && wave_cd <= 0)
{
    // Отримали шкоду — хвиля відкидає гравця
    if (instance_exists(obj_player) && !obj_player.is_damage)
    {
        var _kd = point_direction(x, y, obj_player.x, obj_player.y);
        obj_player.hspd     = lengthdir_x(wave_knockback, _kd);
        obj_player.vspd     = -8;
        obj_player.is_damage = true;
        obj_player.alarm[0]  = room_speed * 0.5;
        // audio_play_sound(snd_moirai_wave, 1, false);
    }
    wave_cd = wave_cd_max;
    enemy_anim_attack(spr_boss_moirai_attack);
}
last_hp = hp;
 
// ---- РУХ МІЖ ТОЧКАМИ ----
var _tx = point_x[current_point];
var _ty = point_y[current_point];
var _d  = point_distance(x, y, _tx, _ty);
 
if (_d > fly_speed)
{
    var _dir = point_direction(x, y, _tx, _ty);
    x += lengthdir_x(fly_speed, _dir);
    y += lengthdir_y(fly_speed, _dir);
    image_xscale = (obj_player.x > x) ? 1 : -1;
}
else
{
    x = _tx; y = _ty;
    current_point = (current_point + 1) mod point_count;
    // Тіні рухаються з відставанням
    shadow1_point = (current_point + 1) mod point_count;
    shadow2_point = (current_point + 2) mod point_count;
}
 
// ---- ПОСТІЙНИЙ ВИКЛИК ВОГНЮ ОЛІМПУ ----
if (fire_cd <= 0 && instance_number(obj_olympus_fire) < max_fires)
{
    // Створюємо вогонь в рандомному місці вгорі
    var _fx = obj_player.x + irandom_range(-200, 200);
    var _fy = obj_player.y - irandom_range(100, 200);
    instance_create_layer(clamp(_fx, 50, room_width - 50),
                          clamp(_fy, 50, room_height / 2),
                          "Instances", obj_olympus_fire);
    fire_cd = fire_cd_max;
    // audio_play_sound(snd_moirai_summon, 1, false);
}
