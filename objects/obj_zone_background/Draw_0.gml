var _sprite=asset_get_index("spr_background_"+yp_zone_id());
if (_sprite == -1) exit;
var _camera=view_camera[0];
var _x=0,_y=0,_w=room_width,_h=room_height;
if (_camera != -1) {
    _x=camera_get_view_x(_camera);_y=camera_get_view_y(_camera);
    _w=camera_get_view_width(_camera);_h=camera_get_view_height(_camera);
}
draw_sprite_stretched(_sprite,0,_x,_y,_w,_h);
draw_set_color(make_color_rgb(12,25,32));draw_set_alpha(0.13);
draw_rectangle(_x,_y,_x+_w,_y+_h,false);
draw_set_alpha(1);draw_set_color(c_white);
