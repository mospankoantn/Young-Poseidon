/// @description 
/// obj_boss_triton — Step Event

if (is_dead || !instance_exists(obj_player)) exit;
 
// ============================================================
// ПЕРЕВІРКА ФАЗИ
// ============================================================
if (hp <= max_hp / 2 && phase == 1)
{
    phase = 2;
    // Спалах переходу у фазу 2
    // audio_play_sound(snd_boss_phase2, 1, false);
}
 
// ============================================================
// СМЕРТЬ
// ============================================================
if (hp <= 0)
{
    is_dead = true;
    // Видати нагороду — тризубець
    instance_create_layer(x, y, "Instances", obj_pickup_trident_reward);
    // audio_play_sound(snd_boss_die, 1, false);
    // alarm[0] = room_speed * 2; // Затримка перед знищенням (для анімації)
    instance_destroy();
    exit;
}
 
// ============================================================
// КУЛДАУНИ
// ============================================================
if (ball_cd   > 0) ball_cd--;
if (wave_cd   > 0) wave_cd--;
if (summon_cd > 0) summon_cd--;
 
// ============================================================
// РУХ МІЖ ТОЧКАМИ
// ============================================================
var _tx = point_x[current_point];
var _ty = point_y[current_point];
var _dist_to_target = point_distance(x, y, _tx, _ty);
 
if (_dist_to_target > fly_speed)
{
    var _dir = point_direction(x, y, _tx, _ty);
    x += lengthdir_x(fly_speed, _dir);
    y += lengthdir_y(fly_speed, _dir);
    image_xscale = (lengthdir_x(1, _dir) > 0) ? 1 : -1;
}
else
{
    // Досягли точки — переходимо до наступної
    x = _tx;
    y = _ty;
    current_point = (current_point + 1) mod point_count;
 
    // При досягненні точки — стріляємо
    if (ball_cd <= 0)
    {
        // Стріляємо водяну кулю в гравця
        var _ball = instance_create_layer(x, y, "Instances", obj_proj_water_ball);
        var _dir_to_pl = point_direction(x, y, obj_player.x, obj_player.y);
        _ball.hspd   = lengthdir_x(5, _dir_to_pl);
        _ball.vspd   = lengthdir_y(5, _dir_to_pl);
        _ball.damage = atk;
        ball_cd = ball_cd_max;
        // audio_play_sound(snd_triton_ball, 1, false);
    }
}
 
// ============================================================
// ФАЗА 2: ДОДАТКОВІ АТАКИ
// ============================================================
if (phase == 2)
{
    // --- Виклик крабів ---
    if (summon_cd <= 0)
    {
        // Викликаємо 2 крабів поруч з гравцем
        instance_create_layer(obj_player.x - 80, obj_player.y, "Instances", obj_giant_crab);
        instance_create_layer(obj_player.x + 80, obj_player.y, "Instances", obj_giant_crab);
        summon_cd = summon_cd_max;
        // audio_play_sound(snd_triton_summon, 1, false);
    }
 
    // --- Хвиля по підлозі ---
    if (wave_cd <= 0)
    {
        // Стріляємо 3 кулі вниз під кутами — імітація хвилі
        for (var _i = -1; _i <= 1; _i++)
        {
            var _wave = instance_create_layer(x, y, "Instances", obj_proj_water_ball);
            _wave.hspd   = _i * 4;
            _wave.vspd   = 5;
            _wave.damage = atk;
        }
        wave_cd = wave_cd_max;
    }
}
 
// ============================================================
// КОНТАКТНА ШКОДА (якщо гравець торкається боса)
// ============================================================
if (distance_to_object(obj_player) < 40 && !obj_player.is_damage)
{
    obj_player.hp       -= atk;
    var _kd              = point_direction(x, y, obj_player.x, obj_player.y);
    obj_player.hspd     = lengthdir_x(10, _kd);
    obj_player.vspd     = -6;
    obj_player.is_damage = true;
    obj_player.alarm[0]  = room_speed;
}