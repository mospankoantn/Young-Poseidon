/// @description 
/// obj_boss_nymph — Step Event

if (is_dead || !instance_exists(obj_player)) exit;
 
if (hp <= max_hp / 2 && phase == 1) { phase = 2; }
 
if (hp <= 0)
{
    is_dead = true;
    instance_create_layer(x, y, "Instances", obj_pickup_spear_reward);
    instance_destroy();
    exit;
}
 
if (charm_cd  > 0) charm_cd--;
if (heal_cd   > 0) heal_cd--;
if (flower_cd > 0) flower_cd--;
 
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
 
// ---- ЧАРИ (уповільнення гравця) ----
// Уповільнення = тимчасово зменшуємо spd гравця
if (charm_cd <= 0 && distance_to_object(obj_player) < 200)
{
    // Уповільнюємо гравця на 3 секунди
    obj_player.temp_spd_buff = -0.6;          // Від'ємний бонус = уповільнення
    obj_player.buff_duration = room_speed * 3;
    charm_cd = charm_cd_max;
    // audio_play_sound(snd_nymph_charm, 1, false);
}
 
// ---- ФАЗА 2 ----
if (phase == 2)
{
    // Самолікування
    if (heal_cd <= 0)
    {
        hp = min(hp + heal_amount, max_hp);
        // Ефект лікування (зелене світіння)
        heal_cd = heal_cd_max;
        // audio_play_sound(snd_nymph_heal, 1, false);
    }
 
    // Квіти-снаряди по колу
    if (flower_cd <= 0)
    {
        var _angles = [0, 60, 120, 180, 240, 300]; // 6 напрямків
        for (var _i = 0; _i < 6; _i++)
        {
            var _fl = instance_create_layer(x, y, "Instances", obj_proj_water_ball);
            _fl.hspd   = lengthdir_x(4, _angles[_i]);
            _fl.vspd   = lengthdir_y(4, _angles[_i]);
            _fl.damage = atk / 2;     // Менша шкода але багато снарядів
        }
        flower_cd = flower_cd_max;
    }
}
 
// ---- КОНТАКТНА ШКОДА ----
if (distance_to_object(obj_player) < 40 && !obj_player.is_damage)
{
    obj_player.hp       -= atk;
    var _kd              = point_direction(x, y, obj_player.x, obj_player.y);
    obj_player.hspd     = lengthdir_x(9, _kd);
    obj_player.vspd     = -5;
    obj_player.is_damage = true;
    obj_player.alarm[0]  = room_speed;
}