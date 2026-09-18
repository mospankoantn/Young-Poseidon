/// @description Keep the warning radius and damage timing visible.
if (!struck)
{
    var _progress = clamp(timer / max(1, warn_time), 0, 1);
    draw_set_color(merge_color(c_yellow, c_red, _progress));
    draw_set_alpha(0.15 + 0.15 * _progress);
    draw_circle(target_x, target_y, 50, false);
    draw_set_alpha(0.8);
    draw_circle(target_x, target_y, 50, true);
    draw_circle(target_x, target_y, 50 * (1 - _progress), true);
}
else
{
    var _fade = clamp(1 - timer / (room_speed * 0.5), 0, 1);
    draw_set_color(make_color_rgb(180, 235, 255));
    draw_set_alpha(_fade * 0.3);
    draw_circle(target_x, target_y, 50, false);
    draw_sprite_ext(spr_projectile_lightning, image_index, target_x, target_y,
        1, max(1, target_y / 128), 0, c_white, _fade);
}
draw_set_alpha(1);
draw_set_color(c_white);
