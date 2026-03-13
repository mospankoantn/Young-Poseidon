/// @description 
/// obj_boss_moirai — Draw Event

// ---- МАЛЮЄМО ДВІ ТІНІ-КЛОНИ ----
var _p1 = (current_point + shadow_offset_1) mod point_count;
var _p2 = (current_point + shadow_offset_2) mod point_count;
 
// Тінь 1 (напівпрозора)
draw_set_alpha(0.35);
draw_set_color(make_color_rgb(180, 100, 255));
draw_sprite_ext(sprite_index, image_index,
    point_x[_p1], point_y[_p1],
    image_xscale, image_yscale, image_angle, image_blend, 1);
 
// Тінь 2
draw_sprite_ext(sprite_index, image_index,
    point_x[_p2], point_y[_p2],
    image_xscale, image_yscale, image_angle, image_blend, 1);
 
draw_set_alpha(1);
draw_set_color(c_white);
 
// ---- ГОЛОВНА ФІГУРА ----
draw_self();
 
// ---- ПРОМІНЬ ЛАХЕСІС (заряджання) ----
if (beam_charging)
{
    var _progress = beam_charge_t / beam_charge_max;
    draw_set_alpha(_progress * 0.7);
    draw_set_color(make_color_rgb(255, 200, 50));
    draw_line_width(x, y, obj_player.x, obj_player.y, 3 + _progress * 5);
    draw_set_alpha(1);
    draw_set_color(c_white);
}