/// @description
/// obj_arrow — Step Event

// Рух стріли
x += fly_speed * direction_x;
y += fly_speed * (direction_y != 0 ? direction_y : 0);
 
// Обертання спрайту в напрямку руху
image_xscale = direction_x;
image_angle  = (direction_x > 0) ? 0 : 180;
 
lifetime--;
if (lifetime <= 0)
{
    instance_destroy();
    exit;
}
 
// Зіткнення зі стіною
if (place_meeting(x, y, obj_platform))
{
    instance_destroy();
    exit;
}
 
// Зіткнення з гравцем
if (instance_exists(obj_player) && place_meeting(x, y, obj_player))
{
    if (!obj_player.is_damage)
    {
        obj_player.hp       -= damage;
        obj_player.hspd     = fly_speed * direction_x * 0.5;
        obj_player.vspd     = -3;
        obj_player.is_damage = true;
        obj_player.alarm[0]  = room_speed;
        // audio_play_sound(snd_arrow_hit, 1, false);
    }
    instance_destroy();
}