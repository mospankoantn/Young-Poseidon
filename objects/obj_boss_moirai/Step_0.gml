/// @description 
/// obj_boss_moirai — Step Event

if (is_dead || !instance_exists(obj_player)) exit;
 
if (hp <= max_hp / 2 && phase == 1)
{
    phase             = 2;
    clotho_cd_max     = room_speed * 2;    // Все вдвічі частіше
    lachesis_cd_max   = room_speed * 3;
    atropos_cd_max    = room_speed * 5;
    fly_speed         = 4;
}
 
if (hp <= 0)
{
    is_dead = true;
    // Фінальна нагорода — ключ від Олімпу
    instance_create_layer(x, y, "Instances", obj_pickup_olympus_key);
    instance_destroy();
    exit;
}
 
if (clotho_cd   > 0) clotho_cd--;
if (lachesis_cd > 0) lachesis_cd--;
if (atropos_cd  > 0) atropos_cd--;
 
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
 
// ---- АТАКА 1: КЛОТО — НИТКИ УПОВІЛЬНЕННЯ ----
if (clotho_cd <= 0)
{
    // Уповільнюємо гравця
    obj_player.temp_spd_buff = -0.5;
    obj_player.buff_duration = room_speed * 3;
 
    // Стріляємо 2 снаряди-нитки (з obj_proj_fate_beam)
    for (var _fi = -1; _fi <= 1; _fi += 2)
    {
        var _thread    = instance_create_layer(x, y, "Instances", obj_proj_fate_beam);
        var _td        = point_direction(x, y, obj_player.x, obj_player.y);
        _thread.hspd   = lengthdir_x(5, _td + _fi * 15);
        _thread.vspd   = lengthdir_y(5, _td + _fi * 15);
        _thread.damage = atk / 3;
    }
    clotho_cd = clotho_cd_max;
    // audio_play_sound(snd_moirai_clotho, 1, false);
}
 
// ---- АТАКА 2: ЛАХЕСІС — ПРОМІНЬ ДОЛІ ----
if (!beam_charging && lachesis_cd <= 0)
{
    beam_charging  = true;
    beam_charge_t  = 0;
    lachesis_cd    = lachesis_cd_max;
}
 
if (beam_charging)
{
    beam_charge_t++;
 
    // 2 секунди заряджання (попередження — намалюємо лінію в Draw)
    if (beam_charge_t >= beam_charge_max)
    {
        beam_charging = false;
        beam_charge_t = 0;
 
        // Завдаємо шкоди якщо гравець в зоні
        if (distance_to_object(obj_player) < 300
            && !obj_player.is_damage)
        {
            obj_player.hp       -= atk * 2;   // Промінь б'є вдвічі сильніше
            var _bd              = point_direction(x, y, obj_player.x, obj_player.y);
            obj_player.hspd     = lengthdir_x(6, _bd);
            obj_player.vspd     = -4;
            obj_player.is_damage = true;
            obj_player.alarm[0]  = room_speed;
        }
        // audio_play_sound(snd_moirai_lachesis, 1, false);
    }
}
 
// ---- АТАКА 3: АТРОПОС — РІЗАННЯ НИТКИ ----
if (atropos_cd <= 0)
{
    // Забирає 40% поточного HP гравця (незалежно від захисту)
    if (!obj_player.is_damage)
    {
        obj_player.hp       -= max(1, floor(obj_player.hp * 0.4));
        obj_player.is_damage = true;
        obj_player.alarm[0]  = room_speed * 0.5;
        atropos_cd = atropos_cd_max;
        // audio_play_sound(snd_moirai_atropos, 1, false);
    }
}
 
// ---- КОНТАКТНА ШКОДА ----
if (distance_to_object(obj_player) < 40 && !obj_player.is_damage)
{
    obj_player.hp       -= atk;
    var _kd              = point_direction(x, y, obj_player.x, obj_player.y);
    obj_player.hspd     = lengthdir_x(8, _kd);
    obj_player.vspd     = -5;
    obj_player.is_damage = true;
    obj_player.alarm[0]  = room_speed;
}