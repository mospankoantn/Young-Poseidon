/// @description 
/// obj_boss_moirai — Draw Event

// Дві напівпрозорі тіні
var _s1x = point_x[shadow1_point];
var _s1y = point_y[shadow1_point];
var _s2x = point_x[shadow2_point];
var _s2y = point_y[shadow2_point];
 
draw_set_alpha(0.3);
draw_sprite_ext(sprite_index, image_index, _s1x, _s1y,
    image_xscale, 1, 0, make_color_rgb(180, 100, 255), 1);
draw_sprite_ext(sprite_index, image_index, _s2x, _s2y,
    image_xscale, 1, 0, make_color_rgb(180, 100, 255), 1);
draw_set_alpha(1);
 
enemy_draw_body();
 