/// @description 
/// obj_boss_charon — Step Event

if (is_dead || !instance_exists(obj_player)) exit;
 
if (hp <= max_hp / 2 && phase == 1) { phase = 2; }
 
if (hp <= 0)
{
    is_dead = true;
    instance_create_layer(x, y, "Instances", obj_pickup_oar_reward);
    instance_destroy();
    exit;
}
 
if (coin_cd   > 0) coin_cd--;
if (rain_cd   > 0) rain_cd--;
if (summon_cd > 0) summon_cd--;
 
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
 
    // При досягненні кута — кидаємо монету в гравця
    if (coin_cd <= 0)
    {
        var _coin      = instance_create_layer(x, y, "Instances", obj_proj_coin);
        var _cd        = point_direction(x, y, obj_player.x, obj_player.y);
        _coin.hspd     = lengthdir_x(7, _cd);
        _coin.vspd     = lengthdir_y(7, _cd);
        _coin.damage   = atk;
        coin_cd = coin_cd_max;
        // audio_play_sound(snd_charon_coin, 1, false);
    }
}
 
// ---- ФАЗА 2 ----
if (phase == 2)
{
    // Монетний дощ — 8 монет по колу
    if (rain_cd <= 0)
    {
        for (var _i = 0; _i < 8; _i++)
        {
            var _angle = _i * 45;
            var _rc    = instance_create_layer(x, y, "Instances", obj_proj_coin);
            _rc.hspd   = lengthdir_x(5, _angle);
            _rc.vspd   = lengthdir_y(5, _angle);
            _rc.damage = atk * 0.7;
        }
        rain_cd = rain_cd_max;
    }
 
    // Виклик духів
    if (summon_cd <= 0)
    {
        instance_create_layer(obj_player.x - 100, obj_player.y, "Instances", obj_fallen_spirit);
        summon_cd = summon_cd_max;
        // audio_play_sound(snd_charon_summon, 1, false);
    }
}
 
// ---- КОНТАКТНА ШКОДА ----
if (distance_to_object(obj_player) < 42 && !obj_player.is_damage)
{
    obj_player.hp       -= atk;
    var _kd              = point_direction(x, y, obj_player.x, obj_player.y);
    obj_player.hspd     = lengthdir_x(9, _kd);
    obj_player.vspd     = -5;
    obj_player.is_damage = true;
    obj_player.alarm[0]  = room_speed;
}
 