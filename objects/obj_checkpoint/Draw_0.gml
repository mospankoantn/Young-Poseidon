/// @description 
/// obj_checkpoint — Draw Event


draw_self();
 
// Мерехтливе сяяння над активним чекпоінтом
if (is_activated)
{
    var _glow = 0.2 + 0.15 * sin(current_time / 300000);
    draw_set_alpha(_glow);
    draw_set_color(c_yellow);
    draw_circle(x, y - sprite_height / 2, 30, false);
    draw_set_alpha(1);
    draw_set_color(c_white);
}