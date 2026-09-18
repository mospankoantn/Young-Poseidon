/// @description 
/// obj_thicket_platform — Draw Event

draw_self();
 
// Підказка якщо гравець поруч
if (!is_cutting
    && instance_exists(obj_player)
    && distance_to_object(obj_player) <= interact_range)
{
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
 
    if (obj_player.current_weapon == 3)
    {
        var _alpha = 0.7 + 0.3 * sin(current_time / 200000);
        draw_set_alpha(_alpha);
        draw_set_color(c_yellow);
        if (font_exists(fnt_main)) draw_set_font(fnt_main);
        draw_text(x, y - sprite_height / 2 - 8, lc("interact_cut"));
    }
    else
    {
        draw_set_alpha(0.6);
        draw_set_color(make_color_rgb(100, 200, 100));
        if (font_exists(fnt_main)) draw_set_font(fnt_main);
        draw_text(x, y - sprite_height / 2 - 8, lc("need_scythe"));
    }
 
    draw_set_alpha(1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
    draw_set_font(-1);
}