/// @description 
/// obj_falling_stone — Step Event

vspd += grv;
y    += vspd;
 
// Шкода Харону
if (!hit_boss && instance_exists(obj_boss_charon)
    && place_meeting(x, y, obj_boss_charon))
{
    obj_boss_charon.hp -= damage;
    hit_boss = true;
    // audio_play_sound(snd_stone_hit_boss, 1, false);
}
 
// Шкода гравцю
if (!hit_player && instance_exists(obj_player)
    && place_meeting(x, y, obj_player) && !obj_player.is_damage)
{
    obj_player.hp       -= damage;
    obj_player.vspd     = -3;
    obj_player.is_damage = true;
    obj_player.alarm[0]  = room_speed;
    hit_player = true;
}
 
// Зупинка на платформі
if (place_meeting(x, y + vspd, obj_platform))
{
    while (!place_meeting(x, y + 1, obj_platform)) y++;
    vspd = 0;
    // Камінь залишається як перешкода (або знищується)
    alarm[0] = room_speed * 3;
}