/// @description Гравець може стояти на завалі (він є платформою)
///  obj_uranus_barrier — Step Event

// Гравець може стояти на завалі (він є платформою)
if (hp <= 0) { instance_destroy(); exit; }
image_index = 0;
if (hit_flash > 0) { hit_flash--; image_blend = merge_color(c_white, c_orange, hit_flash/8); }
else image_blend = c_white;
