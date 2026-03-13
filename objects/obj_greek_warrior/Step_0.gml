/// @description Логіка поведінки Грецького Воїна

/// obj_greek_warrior — Step Event

// ---- СМЕРТЬ ----
if (hp <= 0)
{
    // audio_play_sound(snd_warrior_die, 1, false);
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
 
switch (state)
{
    // ------ 0: ПАТРУЛЬ ------
    case 0:
        if (patrol_timer > 0)
        {
            patrol_timer--;
            break;
        }
 
        x += patrol_spd * move_dir;
        image_xscale = move_dir;
 
        // Розворот на межах і при зіткненні зі стіною
        if (x <= left_bound || x >= right_bound
            || place_meeting(x + patrol_spd * move_dir, y, obj_platform))
        {
            move_dir     *= -1;
            patrol_timer  = 20;  // Невелика пауза перед розворотом
        }
 
        // Виявлення гравця
        if (_dist <= sight_range)
        {
            state = 1;
            // audio_play_sound(snd_warrior_alert, 1, false);
        }
    break;
 
    // ------ 1: ПЕРЕСЛІДУЄ ------
    case 1:
        var _move_x = sign(obj_player.x - x) * spd;
        if (!place_meeting(x + _move_x, y, obj_platform))
            x += _move_x;
 
        image_xscale = sign(obj_player.x - x);
 
        // Перехід в атаку
        if (_dist <= attack_range)
        {
            state = 2;
            break;
        }
 
        // Втратив гравця
        if (_dist > sight_range * 1.5)
            state = 0;
    break;
 
    // ------ 2: АТАКА ------
    case 2:
        image_xscale = (obj_player.x > x) ? 1 : -1;
 
        if (attack_cd <= 0 && !obj_player.is_damage)
        {
            obj_player.hp       -= atk;
            var _dir             = point_direction(x, y, obj_player.x, obj_player.y);
            obj_player.hspd     = lengthdir_x(8, _dir);
            obj_player.vspd     = -4;
            obj_player.is_damage = true;
            obj_player.alarm[0]  = room_speed;
            attack_cd = attack_cd_max;
            // audio_play_sound(snd_warrior_attack, 1, false);
        }
 
        // Гравець відбіг — переслідуємо знову
        if (_dist > attack_range * 1.5)
            state = 1;
    break;
}