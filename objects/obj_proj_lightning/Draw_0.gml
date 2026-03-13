/// @description 
/// obj_proj_lightning — Draw Event

if (!struck)
{
    // Попередження: мерехтливе коло на цільовій позиції
    var _progress = timer / warn_time;
    var _col      = merge_color(c_yellow, c_red, _progress);
    draw_set_alpha(0.3 + 0.4 * sin(current_time / 50000));
    draw_set_color(_col);
    draw_circle(target_x, target_y, 50, false);
    draw_set_alpha(1);
    draw_set_color(c_white);
}
else
{
    // Спалах після удару
    draw_set_alpha(1 - timer / (room_speed * 0.5));
    draw_set_color(c_white);
    draw_circle(target_x, target_y, 60, false);
    // Малюємо лінію блискавки від верху екрану
    draw_set_color(make_color_rgb(200, 220, 255));
    draw_line_width(target_x, 0, target_x, target_y, 4);
    draw_set_alpha(1);
    draw_set_color(c_white);
}
