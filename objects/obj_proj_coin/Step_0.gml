/// @description
/// obj_proj_coin — Step Event
vspd += grv;
x    += hspd;
y    += vspd;
image_angle += 8;   // Обертання
lifetime--;
 
if (lifetime <= 0 || place_meeting(x, y, obj_platform))
{
    instance_destroy();
    exit;
}
 
if (instance_exists(obj_player) && place_meeting(x, y, obj_player) && !obj_player.is_damage && !obj_player.is_dead)
{
    obj_player.hp       -= damage;
    obj_player.hspd     = hspd * 0.6;
    obj_player.vspd     = -4;
    obj_player.is_damage = true;
    obj_player.alarm[0]  = room_speed;
    instance_destroy();
}