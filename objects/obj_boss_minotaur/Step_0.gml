/// @description 
/// obj_boss_minotaur — Step Event

if (is_dead || !instance_exists(obj_player)) exit;
 
if (hp <= max_hp / 2 && phase == 1) { phase = 2; }
 
if (hp <= 0)
{
    is_dead = true;
    instance_create_layer(x, y, "Instances", obj_pickup_sword_reward);
    instance_destroy();
    exit;
}
 
if (slam_cd   > 0) slam_cd--;
if (charge_cd > 0) charge_cd--;
if (stomp_cd  > 0) stomp_cd--;
 
// ---- ГРАВІТАЦІЯ ----
vspd += grv;
var _was_in_air = !place_meeting(x, y + 1, obj_platform);
if (place_meeting(x, y + vspd, obj_platform))
{
    while (!place_meeting(x, y + sign(vspd), obj_platform))
        y += sign(vspd);
    vspd = 0;
    // Щойно приземлився
    if (_was_in_air)
        just_landed = true;
}
y += vspd;
 
var _on_ground = place_meeting(x, y + 1, obj_platform);
 
// ---- УДАР ПРИ ПОСАДЦІ ----
if (just_landed && slam_cd <= 0)
{
    just_landed = false;
    if (!obj_player.is_damage && distance_to_object(obj_player) <= slam_range)
    {
        obj_player.hp       -= atk;
        obj_player.vspd     = -8;
        obj_player.hspd     = sign(obj_player.x - x) * 10;
        obj_player.is_damage = true;
        obj_player.alarm[0]  = room_speed;
        // audio_play_sound(snd_minotaur_slam, 1, false);
    }
    slam_cd = slam_cd_max;
}
just_landed = false;
 
switch (state)
{
    // ------ 0: НА ЗЕМЛІ — вибір наступної дії ------
    case 0:
        if (!_on_ground) { state = 1; break; }
 
        image_xscale = (obj_player.x > x) ? 1 : -1;
 
        // Фаза 2: заряд через кімнату
        if (phase == 2 && charge_cd <= 0)
        {
            is_charging = true;
            charge_dir  = sign(obj_player.x - x);
            state       = 2;
            break;
        }
 
        // Фаза 2: тупання (камені зверху)
        if (phase == 2 && stomp_cd <= 0)
        {
            // 3 камені падають зверху в різних позиціях
            for (var _si = -1; _si <= 1; _si++)
            {
                var _stone = instance_create_layer(
                    obj_player.x + _si * 80, room_height * 0.05,
                    "Instances", obj_proj_lightning);   // Перевикористовуємо як кам'яний снаряд
                _stone.target_x  = obj_player.x + _si * 80;
                _stone.target_y  = obj_player.y;
                _stone.damage    = atk / 2;
                _stone.warn_time = room_speed;
            }
            stomp_cd = stomp_cd_max;
        }
 
        // Стрибок до наступної точки
        if (_on_ground)
        {
            var _tx   = point_x[current_point];
            var _dist = abs(_tx - x);
            if (_dist > 20)
            {
                // Стрибаємо у бік точки
                var _jump_hspd = sign(_tx - x) * 5;
                vspd           = -14;
                x             += _jump_hspd;
                state          = 1;
            }
            else
            {
                current_point = (current_point + 1) mod point_count;
            }
        }
    break;
 
    // ------ 1: У ПОВІТРІ ------
    case 1:
        // Горизонтальний рух до точки під час стрибка
        var _tx      = point_x[current_point];
        var _move_x  = sign(_tx - x) * 5;
        if (!place_meeting(x + _move_x, y, obj_platform))
            x += _move_x;
 
        image_xscale = sign(_tx - x);
 
        // Приземлення
        if (_on_ground)
        {
            state = 0;
        }
    break;
 
    // ------ 2: ЗАРЯД ------
    case 2:
        x += charge_spd * charge_dir;
        image_xscale = charge_dir;
 
        // Шкода при заряді (постійна)
        if (!obj_player.is_damage && distance_to_object(obj_player) < 50)
        {
            obj_player.hp       -= atk;
            obj_player.hspd     = charge_dir * 12;
            obj_player.vspd     = -5;
            obj_player.is_damage = true;
            obj_player.alarm[0]  = room_speed;
            // audio_play_sound(snd_minotaur_charge, 1, false);
        }
 
        // Зупиняємось при зіткненні зі стіною або виходячи за межі
        if (place_meeting(x + charge_spd * charge_dir, y, obj_platform)
            || x < 50 || x > room_width - 50)
        {
            is_charging  = false;
            state        = 0;
            charge_cd    = charge_cd_max;
            // audio_play_sound(snd_minotaur_wall_hit, 1, false);
        }
    break;
}
 