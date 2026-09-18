/// @description 
/// obj_mine_cart — Draw Event

draw_self();
 
// Підказка "E" якщо гравець поруч і не всередині
if (!has_player
    && instance_exists(obj_player)
    && distance_to_object(obj_player) <= interact_range)
{
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    var _alpha = 0.7 + 0.3 * sin(current_time / 200000);
    draw_set_alpha(_alpha);
    draw_set_color(c_yellow);
    if (font_exists(fnt_main)) draw_set_font(fnt_main);
    draw_text(x, y - sprite_height / 2 - 8, lc("interact_sit"));
    draw_set_alpha(1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
    draw_set_font(-1);
}