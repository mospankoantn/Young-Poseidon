function prop_player_near(_range) {
    return instance_exists(obj_player) && !obj_player.is_dead && obj_player.hp>0
        && distance_to_object(obj_player)<=_range;
}
function prop_hint(_text,_color) {
    if(variable_global_exists("yp_settings") && !global.yp_settings.hints) return;
    draw_set_font(fnt_main);draw_set_halign(fa_center);draw_set_valign(fa_bottom);
    draw_set_color(c_black);draw_set_alpha(0.8);
    var _cx=(bbox_left+bbox_right)*0.5,_top=bbox_top-10;
    var _w=string_width(_text)+14;
    var _view=view_camera[0],_left=0,_width=room_width;
    if(_view!=-1){_left=camera_get_view_x(_view);_width=camera_get_view_width(_view);}
    _cx=clamp(_cx,_left+_w/2+8,_left+_width-_w/2-8);
    draw_rectangle(_cx-_w/2,_top-24,_cx+_w/2,_top+2,false);
    draw_set_alpha(1);draw_set_color(_color);draw_text(_cx,_top,_text);
    draw_set_font(-1);draw_set_halign(fa_left);draw_set_valign(fa_top);draw_set_color(c_white);
}
function prop_health(_hp,_max) {
    var _cx=(bbox_left+bbox_right)*0.5,_top=bbox_top-5;
    draw_set_color(make_color_rgb(26,38,43));draw_rectangle(_cx-20,_top,_cx+20,_top+3,false);
    draw_set_color(make_color_rgb(232,187,93));draw_rectangle(_cx-20,_top,_cx-20+40*clamp(_hp/_max,0,1),_top+3,false);
    draw_set_color(c_white);
}
function prop_draw_damage(_hp,_max) {
    draw_self();
    if(_hp<_max) {
        var _cx=(bbox_left+bbox_right)*0.5,_cy=(bbox_top+bbox_bottom)*0.5;
        draw_set_color(make_color_rgb(39,42,40));
        draw_line_width(_cx-4,bbox_top+6,_cx+4,_cy,2);
        draw_line_width(_cx+4,_cy,_cx-7,bbox_bottom-5,2);
        if(_hp<=_max/2) draw_line_width(_cx+4,_cy,bbox_right-6,_cy-9,2);
        draw_set_color(c_white);
        prop_health(_hp,_max);
    }
}
function prop_nearest_button() {
    if(!instance_exists(obj_player)) return noone;
    var _best=noone,_distance=infinity;
    with(obj_interactive_button) {
        var _d=distance_to_object(obj_player);
        if(_d<=interact_range && _d<_distance){_best=id;_distance=_d;}
    }
    return _best;
}
