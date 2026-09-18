/// @description 
/// obj_pickup_weapon_base — Draw Event

// Сяяння під предметом
var _glow_alpha = 0.15 + 0.1 * sin(bob_offset * 2);
draw_set_alpha(_glow_alpha);
draw_set_color(is_key ? c_yellow : make_color_rgb(100, 200, 255));
draw_circle(x, base_y, glow_radius + sin(bob_offset) * 5, false);
draw_set_alpha(1);
 
// Сам спрайт
draw_self();
 
// Підказка над предметом
draw_set_halign(fa_center);
draw_set_valign(fa_bottom);
draw_set_color(c_white);
if (font_exists(fnt_main)) draw_set_font(fnt_main);
 
var _bounce = sin(bob_offset * 2) * 3;
draw_text(x, base_y - sprite_height / 2 - 20 + _bounce,
    weapon_label);
 
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_font(-1);
