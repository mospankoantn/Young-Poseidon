/// @description Логіка поведінки духа шахтаря

/// obj_miner_spirit — Step Event

// ---- СМЕРТЬ ----
if (hp <= 0)
{
    // audio_play_sound(snd_miner_die, 1, false);
    instance_destroy();
    exit;
}
 
if (!instance_exists(obj_player)) exit;
 
// ---- ГРАВІТАЦІЯ ----
vspd += grv;
if (place_meeting(x, y + vspd, obj_platform))
{
    while (!place_meeting(x, y + sign(vspd), obj_platform))
        y += sign(vspd);
    vspd = 0;
}
y += vspd;
 
if (attack_cd > 0) attack_cd--;
 
var _dist = distance_to_object(obj_player);
 
// ---- АВТОМАТ СТАНІВ ----
switch (state)
{
    // ------ 0: СТОЇТЬ (чекає гравця) ------
    case 0:
        image_xscale = (obj_player.x > x) ? 1 : -1;  // Дивиться на гравця
 
        if (_dist <= sight_range)
        {
            state = 1;
            // audio_play_sound(snd_miner_alert, 1, false);
        }
    break;
 
    // ------ 1: ПЕРЕСЛІДУЄ ------
    case 1:
        var _dir = point_direction(x, y, obj_player.x, obj_player.y);
 
        // Рухаємося лише по горизонталі (залишаємося на платформах)
        var _move_x = lengthdir_x(spd, _dir);
        if (!place_meeting(x + _move_x, y, obj_platform))
            x += _move_x;
 
        image_xscale = (_move_x > 0) ? 1 : -1;
 
        // Атака в ближньому бою
        if (_dist <= attack_range && attack_cd <= 0 && !obj_player.is_damage)
        {
            obj_player.hp       -= atk;
            var _kdir            = point_direction(x, y, obj_player.x, obj_player.y);
            obj_player.hspd     = lengthdir_x(7, _kdir);
            obj_player.vspd     = -4;
            obj_player.is_damage = true;
            obj_player.alarm[0]  = room_speed;
            attack_cd = attack_cd_max;
            // audio_play_sound(snd_miner_attack, 1, false);
        }
 
        // Якщо гравець далеко вийшов — повертаємося на місце
        if (_dist > sight_range * 1.5)
            state = 0;
    break;
}