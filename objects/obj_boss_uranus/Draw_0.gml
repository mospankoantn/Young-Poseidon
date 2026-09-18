/// @description Підсвічування червоним коли застряг (вразливий)
/// obj_boss_uranus — Draw Event

// Підсвічування червоним коли застряг (вразливий)
if (is_stuck)
{
    var _flash = 0.5 + 0.5 * sin(current_time / 80000);
    image_blend = merge_color(c_white, c_red, _flash);
    // Текст над босом
    draw_set_halign(fa_center);
    draw_set_color(c_red);
    if (font_exists(fnt_main)) draw_set_font(fnt_main);
    draw_text(x, y - sprite_height / 2 - 20, "ВРАЗЛИВИЙ!");
    draw_set_halign(fa_left);
    draw_set_color(c_white);
    draw_set_font(-1);
}
else
{
    image_blend = c_white;
}
draw_self();