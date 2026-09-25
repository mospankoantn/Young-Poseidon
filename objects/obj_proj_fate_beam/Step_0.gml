/// @description
/// obj_proj_fate_beam — Step Event

x += hspd;
y += vspd;
image_angle = point_direction(0, 0, hspd, vspd);
lifetime--;
 
if (lifetime <= 0 || place_meeting(x, y, obj_platform))
{
    instance_destroy();
    exit;
}
 
if (instance_exists(obj_player) && place_meeting(x, y, obj_player) && !obj_player.is_damage && !obj_player.is_dead)
{
    obj_player.hp       -= damage;
    // Нитка уповільнює — вже зроблено в Step Мойр через clotho
    obj_player.is_damage = true;
    obj_player.alarm[0]  = room_speed * 0.5;
    instance_destroy();
}