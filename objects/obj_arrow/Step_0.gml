/// @description
/// obj_arrow — Step Event
if (source_enemy != noone)
{
    if (!instance_exists(source_enemy)) { instance_destroy(); exit; }
    if (source_enemy.hp <= 0) { instance_destroy(); exit; }
}

// Рух за нормалізованим напрямком. Це підтримує і горизонтальні стріли,
// і вертикальний дощ стріл Німфи.
var _dx = direction_x;
var _dy = direction_y;
var _len = point_distance(0, 0, _dx, _dy);
if (_len > 0)
{
    _dx /= _len;
    _dy /= _len;
}

x += fly_speed * _dx;
y += fly_speed * _dy;

if (_len > 0)
{
    image_xscale = 1;
    image_angle = point_direction(0, 0, _dx, _dy);
}

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
    var _p = instance_find(obj_player, 0);
    if (!_p.is_dead && _p.hp > 0 && !_p.is_damage
        && (source_enemy == noone || enemy_can_damage(source_enemy)))
    {
        _p.hp -= damage;
        _p.hspd = fly_speed * _dx * 0.5;
        _p.vspd = min(-3, fly_speed * _dy * 0.15);
        _p.is_damage = true;
        _p.alarm[0] = room_speed;
        // audio_play_sound(snd_arrow_hit, 1, false);
    }
    instance_destroy();
}
