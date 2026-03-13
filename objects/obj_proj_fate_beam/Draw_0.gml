/// @description Нитка = пурпурна лінія з ефектом слід
/// obj_proj_fate_beam — Draw Event

draw_set_color(make_color_rgb(200, 100, 255));
draw_set_alpha(0.8);
draw_circle(x, y, 6, false);
draw_set_alpha(1);
draw_set_color(c_white);