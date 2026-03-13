/// @description 
/// obj_boss_war_ghost — Step Event

if (is_dead || !instance_exists(obj_player)) exit;
 
if (hp <= max_hp / 2 && phase == 1)
{
    phase = 2;
    fly_speed = 5;   // Стає швидшим
}
 
if (hp <= 0)
{
    is_dead = true;
    instance_create_layer(x, y, "Instances", obj_pickup_scythe_reward);
    instance_destroy();
    exit;
}
 
if (spear_cd > 0) spear_cd--;
if (rally_cd > 0) rally_cd--;
 
// Пульсація прозорості (привид)
image_alpha = 0.65 + 0.25 * sin(current_time / 200000);
 
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
 
    // При досягненні точки — кидаємо спис(и)
    if (spear_cd <= 0)
    {
        var _spear_count = (phase == 2) ? 3 : 1;
        var _base_dir    = point_direction(x, y, obj_player.x, obj_player.y);
 
        for (var _si = 0; _si < _spear_count; _si++)
        {
            var _spread = (_spear_count > 1) ? (_si - 1) * 20 : 0;
            var _sp     = instance_create_layer(x, y, "Instances", obj_proj_spear_ghost);
            var _sd     = _base_dir + _spread;
            _sp.hspd    = lengthdir_x(8, _sd);
            _sp.vspd    = lengthdir_y(8, _sd);
            _sp.damage  = atk;
        }
        spear_cd = spear_cd_max;
        // audio_play_sound(snd_warghost_spear, 1, false);
    }
}
 
// ---- ФАЗА 2: КЛИЧ ПІДСИЛЕННЯ ----
if (phase == 2 && rally_cd <= 0)
{
    // Підсилюємо всіх ворогів поблизу (збільшуємо їх atk на 3)
    with (obj_enemy)
    {
        if (self != obj_boss_war_ghost          // Не себе
           && distance_to_object(obj_boss_war_ghost) <= other.rally_radius)
        {
            atk += 3;   // Тимчасовий бонус (не скидається — задумано)
        }
    }
    rally_cd = rally_cd_max;
    // audio_play_sound(snd_warghost_rally, 1, false);
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