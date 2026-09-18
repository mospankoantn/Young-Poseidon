/// @description Animated fate thread, aligned with its existing velocity.
draw_sprite_ext(sprite_index, image_index, x - hspd, y - vspd,
    image_xscale, image_yscale, image_angle, c_white, 0.25);
draw_self();
