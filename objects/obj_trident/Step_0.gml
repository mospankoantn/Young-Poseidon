/// @description Independent trident/spear projectile behaviour.

if (!instance_exists(obj_player)) exit;

var _player = instance_find(obj_player, 0);
owner_player = _player;

// ============================================================
// STUCK IN WALL
// ============================================================
if (stuck)
{
    // Re-create only this weapon's invisible standing platform if an external
    // room operation removed it while the projectile is still stuck.
    if (!instance_exists(platform_instance))
    {
        platform_instance = instance_create_layer(x, y, "Instances", obj_trident_platform);
        platform_instance.source_throwable = id;
        platform_instance.image_xscale = image_xscale;
    }
    exit;
}

// ============================================================
// FLYING
// ============================================================
if (thrown && !invisible_time)
{
    var _step_x = (image_xscale > 0) ? 1 : -1;
    var _steps = max(1, round(fly_speed));
    var _hit_wall = false;

    // Move pixel-by-pixel. The old code jumped a full 12 px and then moved the
    // projectile a full 12 px back, leaving the shorter trident visibly
    // floating away from the wall.
    repeat (_steps)
    {
        if (place_meeting(x + _step_x, y, obj_platform))
        {
            _hit_wall = true;
            break;
        }
        x += _step_x;
    }

    image_angle = 0;
    timer++;

    if (_hit_wall)
    {
        stuck = true;
        thrown = false;
        timer = 0;

        if (instance_exists(platform_instance))
            instance_destroy(platform_instance);

        platform_instance = instance_create_layer(x, y, "Instances", obj_trident_platform);
        platform_instance.source_throwable = id;
        platform_instance.image_xscale = image_xscale;
        exit;
    }

    // Enemy hit.
    var _hit = instance_place(x, y, obj_enemy);
    if (instance_exists(_hit))
    {
        var _bonus = variable_instance_exists(_player, "temp_atk_buff")
            ? _player.temp_atk_buff : 0;
        if (variable_instance_exists(_hit, "hp"))
            enemy_take_hit(_hit, damage + _bonus, x);

        thrown = false;
        timer = 0;
    }

    var _out = (x < -100 || x > room_width + 100
                || y < -100 || y > room_height + 100);
    if (_out || timer >= flight_duration)
    {
        thrown = false;
        timer = 0;
    }

    exit;
}

// ============================================================
// RETURNING / HELD
// ============================================================
var _dist = point_distance(x, y, _player.x, _player.y);

if (_dist > fly_speed)
{
    var _dir = point_direction(x, y, _player.x, _player.y);
    x += lengthdir_x(fly_speed, _dir);
    y += lengthdir_y(fly_speed, _dir);
    image_angle = _dir;
}
else
{
    x = _player.x;
    y = _player.y;
    image_angle = 0;

    if (variable_instance_exists(_player, "throwable_instances")
        && visual_weapon >= 0 && visual_weapon <= 1)
    {
        _player.throwable_instances[visual_weapon] = id;
    }

    if (_player.current_weapon == visual_weapon)
        _player.trident_instance = id;
}
