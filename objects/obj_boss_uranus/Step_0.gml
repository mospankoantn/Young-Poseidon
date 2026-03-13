/// @description 
/// obj_boss_uranus — Step Event

if (is_dead || !instance_exists(obj_player)) exit;
 
if (hp <= max_hp / 2 && phase == 1)
{
    phase = 2;
    lightning_cd_max = room_speed * 1.5;   // Блискавки вдвічі частіше
}
 
if (hp <= 0)
{
    is_dead = true;
    instance_create_layer(x, y, "Instances", obj_pickup_pickaxe_reward);
    instance_destroy();
    exit;
}
 
if (lightning_cd > 0) lightning_cd--;
if (field_cd     > 0) field_cd--;
 
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
}
 
// ---- БЛИСКАВКА З НЕБА ----
if (lightning_cd <= 0)
{
    // Попередження: створюємо об'єкт блискавки над гравцем
    // obj_proj_lightning сам рахує затримку і б'є через 1.5 секунди
    var _bolt        = instance_create_layer(obj_player.x, room_height * 0.1,
                                             "Instances", obj_proj_lightning);
    _bolt.target_x   = obj_player.x;
    _bolt.target_y   = obj_player.y;
    _bolt.damage     = atk;
    _bolt.warn_time  = room_speed * 1.5;   // 1.5 секунди попередження
    lightning_cd     = lightning_cd_max;
    // audio_play_sound(snd_uranus_lightning_warn, 1, false);
}
 
// ---- ФАЗА 2: ЕЛЕКТРИЧНЕ ПОЛЕ ----
if (phase == 2 && field_cd <= 0)
{
    if (distance_to_object(obj_player) <= field_radius && !obj_player.is_damage)
    {
        obj_player.hp       -= atk / 3;     // Менша шкода але часто
        obj_player.is_damage = true;
        obj_player.alarm[0]  = room_speed * 0.3;
    }
    field_cd = field_cd_max;
}
 
// ---- КОНТАКТНА ШКОДА ----
if (distance_to_object(obj_player) < 44 && !obj_player.is_damage)
{
    obj_player.hp       -= atk;
    var _kd              = point_direction(x, y, obj_player.x, obj_player.y);
    obj_player.hspd     = lengthdir_x(10, _kd);
    obj_player.vspd     = -7;
    obj_player.is_damage = true;
    obj_player.alarm[0]  = room_speed;
}
 