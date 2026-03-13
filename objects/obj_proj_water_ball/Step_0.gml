/// @description
/// obj_proj_water_ball — Step Event

vspd     += grv;
x        += hspd;
y        += vspd;
lifetime--;
 
if (lifetime <= 0 || place_meeting(x, y, obj_platform))
{
    instance_destroy();
    exit;
}
 
if (instance_exists(obj_player) && place_meeting(x, y, obj_player) && !obj_player.is_damage)
{
    obj_player.hp       -= damage;
    obj_player.hspd     = hspd * 0.5;
    obj_player.vspd     = -3;
    obj_player.is_damage = true;
    obj_player.alarm[0]  = room_speed;
    instance_destroy();
}