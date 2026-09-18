draw_sprite_ext(spr_checkpoint,0,x,y,image_xscale,image_yscale,0,is_activated ? c_white : make_color_rgb(120,150,160),1);
if(is_activated) {
    var _cx=(bbox_left+bbox_right)*0.5;
    draw_set_alpha(0.55+0.2*sin(current_time/250));draw_set_color(c_aqua);
    draw_circle(_cx,bbox_top+26,6,true);draw_set_alpha(1);draw_set_color(c_white);
}
