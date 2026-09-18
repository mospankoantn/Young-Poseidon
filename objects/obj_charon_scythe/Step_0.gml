/// @description
/// obj_charon_scythe — Step Event

image_angle += 12;   // Крутиться
lifetime--;
if (lifetime <= 0) { instance_destroy(); exit; }
 
if (!returning)
{
    // Летить до позиції гравця
    var _d = point_distance(x, y, target_x, target_y);
    if (_d > spd)
    {
        var _dir = point_direction(x, y, target_x, target_y);
        x += lengthdir_x(spd, _dir);
        y += lengthdir_y(spd, _dir);
    }
    else
        returning = true;  // Досягла цілі — повертається
 
    // Шкода гравцю під час польоту
    if (instance_exists(obj_player) && place_meeting(x, y, obj_player)
        && !obj_player.is_damage)
    {
        obj_player.hp       -= dmg;
        obj_player.is_damage = true;
        obj_player.alarm[0]  = room_speed;
    }
}
else
{
    // Повертається до Харона
    if (!instance_exists(owner)) { instance_destroy(); exit; }
    var _d = point_distance(x, y, owner.x, owner.y);
    if (_d > spd)
    {
        var _dir = point_direction(x, y, owner.x, owner.y);
        x += lengthdir_x(spd * 1.3, _dir);
        y += lengthdir_y(spd * 1.3, _dir);
    }
    else
        instance_destroy();  // Повернулась
}