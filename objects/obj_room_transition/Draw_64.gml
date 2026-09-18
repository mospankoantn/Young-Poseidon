/// @description
/// obj_room_transition — Draw GUI Event

if (fade_alpha <= 0) exit;
 
draw_set_alpha(fade_alpha);
draw_set_color(c_black);
draw_rectangle(0, 0,
    display_get_gui_width(),
    display_get_gui_height(), false);
draw_set_alpha(1);