/// @description 
/// obj_falling_rocks — Draw Event

draw_self();

// Показуємо тільки камінь, який впаде після наступного натискання кнопки.
if (state == 0 && is_next)
{
    // Шукаємо підлогу нижче
    var _check_y = y;
    while (!place_meeting(x, _check_y + 1, obj_platform) && _check_y < room_height)
        _check_y++;
 
    var _pulse = 0.55 + 0.25 * sin(current_time / 180);

    draw_set_alpha(_pulse);
    draw_set_color(c_yellow);
    draw_circle(x, y, 24, true);
    draw_line(x, y + 12, x, _check_y);

    draw_set_alpha(_pulse);
    draw_set_color(c_red);
    draw_ellipse(x - 24, _check_y - 5, x + 24, _check_y + 5, false);
    draw_set_alpha(1);
    draw_set_color(c_white);
}
