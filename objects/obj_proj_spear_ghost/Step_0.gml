/// @description
/// obj_proj_spear_ghost — Step Event

x += hspd;
y += vspd;
image_angle = point_direction(0, 0, hspd, vspd);  // Спис дивиться в напрямку руху
lifetime--;
 
if (lifetime <= 0 || place_meeting(x, y, obj_platform))
{
    instance_destroy();
    exit;
}
 
if (instance_exists(obj_player) && place_meeting(x, y, obj_player) && !obj_player.is_damage && !obj_player.is_dead)
{
    obj_player.hp       -= damage;
    obj_player.hspd     = hspd * 0.4;
    obj_player.vspd     = -5;
    obj_player.is_damage = true;
    obj_player.alarm[0]  = room_speed;
    instance_destroy();
}