/// @description 
/// obj_boss_uranus — Draw Event

draw_self();
 
// Електричне поле у фазі 2 (візуальний ефект кола)
if (phase == 2)
{
    var _alpha = 0.2 + 0.15 * sin(current_time / 100000);
    draw_set_alpha(_alpha);
    draw_set_color(make_color_rgb(100, 180, 255));
    draw_circle(x, y, field_radius, false);
    draw_set_alpha(1);
    draw_set_color(c_white);
}