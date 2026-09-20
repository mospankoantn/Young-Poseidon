/// @description Draw the independent trident/spear projectile.

if (!instance_exists(obj_player))
{
    draw_self();
    exit;
}

var _player = instance_find(obj_player, 0);
var _dist = point_distance(x, y, _player.x, _player.y);

// Hide only when this exact weapon is back in the player's hand.
if (_dist < 20 && !thrown && !stuck)
    exit;

var _visual = (visual_weapon == 1) ? spr_projectile_spear : spr_projectile_trident;
var _angle = (thrown || stuck) ? (image_xscale > 0 ? 0 : 180) : image_angle;

// The trident artwork is shorter at the tip than the spear while both use the
// same collision mask. Push ONLY its drawing 6 px toward the wall when stuck;
// logical collision/platform coordinates remain unchanged.
var _draw_x = x;
if (stuck && visual_weapon == 0)
    _draw_x += (image_xscale > 0 ? 6 : -6);

draw_sprite_ext(_visual, 0, _draw_x, y, 1, 1, _angle, image_blend, image_alpha);

if (thrown || stuck)
{
    draw_set_color(make_color_rgb(200, 220, 255));
    draw_set_alpha(0.38);
    draw_line(_draw_x, y, _player.x, (_player.bbox_top + _player.bbox_bottom) * 0.5);
    draw_set_alpha(1);
    draw_set_color(c_white);
}

if (stuck)
{
    var _pulse = 0.5 + 0.5 * sin(current_time / 180);
    draw_set_alpha(0.25 + 0.25 * _pulse);
    draw_set_color(visual_weapon == 1 ? c_aqua : c_yellow);
    draw_circle(_draw_x, y, 17, true);
    draw_set_alpha(1);
    draw_set_color(c_white);
}
