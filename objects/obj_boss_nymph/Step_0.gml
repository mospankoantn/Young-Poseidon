/// @description 
/// obj_boss_nymph — Step Event

if (is_dead || !instance_exists(obj_player)) exit;
if (obj_player.weapon_unlocked[1]) { instance_destroy(); exit; }
 
if (hp <= 0)
{
    is_dead = true;
    instance_create_layer(x, y, "Instances", obj_pickup_spear_reward);
    instance_destroy();
    exit;
}
 
// Гравітація
vspd += grv;
if (place_meeting(x, y + vspd, obj_platform))
{
    while (!place_meeting(x, y + sign(vspd), obj_platform)) y += sign(vspd);
    vspd = 0;
}
y += vspd;
 
if (shoot_cd > 0) shoot_cd--;
 
switch (state)
{
    // ------ 0: БІЖИТЬ ------
    case 0:
        x += run_speed * move_dir;
        image_xscale = move_dir;
 
        // Розворот на межах і при стіні
        if (x <= left_x || x >= right_x
            || place_meeting(x + run_speed * move_dir, y, obj_platform))
        {
            move_dir *= -1;
            // Зупиняємось кожні 2 пробіги для стрільби
            stop_timer++;
            if (stop_timer >= 2)
            {
                stop_timer = 0;
                state      = 1;
                shoot_cd   = room_speed;   // 1 секунда заряджання
                barrage_count = 0;
 
                // Генеруємо безпечні пропуски (3 штуки)
                barrage_gap_positions = [];
                var _room_w = room_width;
                repeat (3)
                {
                    array_push(barrage_gap_positions,
                        50 + irandom(_room_w - 100));
                }
            }
        }
    break;
 
    // ------ 1: ЗАРЯДЖАЄ СТРІЛИ (пауза) ------
    case 1:
        image_xscale = (obj_player.x > x) ? 1 : -1;
 
        if (shoot_cd <= 0)
        {
            state = 2;  // Стріляємо
        }
    break;
 
    // ------ 2: ЗАЛП СТРІЛ ------
    case 2:
        // Стріляємо barrage_arrows_total стріл рівномірно по ширині кімнати
        // з урахуванням безпечних пропусків
        if (shoot_cd <= 0)
        {
            var _step = room_width / barrage_arrows_total;
            for (var _ai = 0; _ai < barrage_arrows_total; _ai++)
            {
                var _ax = _ai * _step + _step / 2;
 
                // Перевіряємо чи ця позиція не в безпечному пропуску
                var _in_gap = false;
                for (var _gi = 0; _gi < array_length(barrage_gap_positions); _gi++)
                {
                    var _gx = barrage_gap_positions[_gi];
                    if (abs(_ax - _gx) < barrage_gap_width / 2)
                    {
                        _in_gap = true;
                        break;
                    }
                }
 
                if (!_in_gap)
                {
                    var _arr      = instance_create_layer(_ax, y - 50,
                                        "Instances", obj_arrow);
                    _arr.direction_x = 0;    // Летять вниз
                    _arr.fly_speed   = 8;
                    _arr.damage      = atk;
                    _arr.image_angle = 270;  // Стріла летить вниз
                }
            }
 
            // audio_play_sound(snd_nymph_barrage, 1, false);
            shoot_cd = room_speed * 2;   // 2 секунди до наступного залпу
            state    = 3;
        }
    break;
 
    // ------ 3: ПАУЗА ПІСЛЯ ЗАЛПУ ------
    case 3:
        image_xscale = (obj_player.x > x) ? 1 : -1;
        if (shoot_cd <= 0)
            state = 0;  // Повертаємось до бігу
    break;
}
 
// ---- КОНТАКТНА ШКОДА ----
if (distance_to_object(obj_player) < 50 && !obj_player.is_damage)
{
    obj_player.hp       -= atk;
    var _kd = point_direction(x, y, obj_player.x, obj_player.y);
    obj_player.hspd     = lengthdir_x(8, _kd);
    obj_player.vspd     = -5;
    obj_player.is_damage = true;
    obj_player.alarm[0]  = room_speed;
}
