if(state==3) exit;
draw_self();
if(state==0 && is_next) {
    var _ground=y;
    while(_ground<room_height && !place_meeting(x,_ground+4,obj_platform)) _ground+=4;
    var _cx=(bbox_left+bbox_right)*0.5;
    var _bottom=_ground+(bbox_bottom-y);
    draw_set_color(make_color_rgb(255,207,93));
    draw_set_alpha(0.6+0.2*sin(current_time/180));
    draw_triangle(_cx-6,bbox_top-9,_cx+6,bbox_top-9,_cx,bbox_top-2,false);
    for(var _dy=bbox_bottom+6;_dy<_bottom;_dy+=16) draw_line(_cx,_dy,_cx,min(_dy+7,_bottom));
    draw_set_color(make_color_rgb(255,116,85));
    draw_ellipse(_cx-24,_bottom-4,_cx+24,_bottom+4,false);
    draw_set_alpha(1);draw_set_color(c_white);
}
