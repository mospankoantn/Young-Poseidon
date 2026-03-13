/// @description 
/// obj_falling_rocks — Draw Event

draw_self();
 
// Тінь-попередження на підлозі поки каміння ще не впало
if (show_warning && state == 0)
{
    // Малюємо пунктирне коло на підлозі прямо під камінням
    var _ground_y = y;
    // Шукаємо підлогу нижче
    var _check_y = y;
    while (!place_meeting(x, _check_y + 1, obj_platform) && _check_y < room_height)
        _check_y++;
 
    var _pulse = 0.3 + 0.2 * sin(current_time / 200000);
    draw_set_alpha(_pulse);
    draw_set_color(c_red);
    draw_ellipse(x - 20, _check_y - 4, x + 20, _check_y + 4, false);
    draw_set_alpha(1);
    draw_set_color(c_white);
}