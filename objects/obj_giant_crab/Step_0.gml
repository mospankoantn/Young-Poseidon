if (instance_exists(obj_player) && point_distance(x, y, obj_player.x, obj_player.y) <= 150)
    yp_trigger_hint("crab", "hint_crab", 240);

/// @description Логіка поведінки крабу
// obj_giant_crab Step Event

// ---- СМЕРТЬ ----
if (hp <= 0)
{
    if (!enemy_anim_death_tick(spr_giant_crab_death)) exit;
    // audio_play_sound(snd_crab_die, 1, false);
    instance_destroy();
    exit;
}
 
// ---- ГРАВІТАЦІЯ ----
vspd += grv;
if (place_meeting(x, y + vspd, obj_platform))
{
    while (!place_meeting(x, y + sign(vspd), obj_platform))
        y += sign(vspd);
    vspd = 0;
}
y += vspd;
 
// ---- ПАТРУЛЬ (ходить між двома точками) ----
// Перевіряємо наступну горизонтальну позицію ДО переміщення.
// Маска краба торкається підлоги нижнім краєм, тому звичайний
// place_meeting(next_x, y, obj_platform) може прийняти підлогу за стіну
// і розвертати краба щокадру. Піднімаємо тільки тест стіни на 2 px.
var _next_x = x + spd * move_dir;
var _wall_ahead = place_meeting(_next_x, y - 2, obj_platform);

if (_wall_ahead)
{
    move_dir *= -1;
}
else
{
    x = _next_x;
}

// Розворот на межах патруля.
if (x <= left_bound)  { move_dir =  1; x = left_bound;  }
if (x >= right_bound) { move_dir = -1; x = right_bound; }

image_xscale = move_dir;
 
// ---- АТАКА ДОТИКом ----
if (attack_cd > 0) attack_cd--;
 
if (instance_exists(obj_player) && attack_cd <= 0)
{
    if (distance_to_object(obj_player) <= attack_range && !obj_player.is_damage)
    {
        obj_player.hp       -= atk;
        var _dir             = point_direction(x, y, obj_player.x, obj_player.y);
        obj_player.hspd     = lengthdir_x(6, _dir);
        obj_player.vspd     = -4;
        obj_player.is_damage = true;
        obj_player.alarm[0]  = room_speed;
        attack_cd = attack_cd_max;
        enemy_anim_attack(spr_giant_crab_attack);
        // audio_play_sound(snd_crab_attack, 1, false);
    }
}
