if (instance_exists(obj_player) && point_distance(x, y, obj_player.x, obj_player.y) <= 90)
    yp_trigger_hint("mine_cart", "hint_mine_cart", 240);

if(has_player && (!instance_exists(obj_player) || obj_player.is_dead || obj_player.hp<=0)) {
    if(instance_exists(obj_player)) obj_player.riding_cart=noone;
    has_player=false;
}
if(yp_input("E",true)) {
    if(has_player) _exit_cart();
    else if(prop_player_near(interact_range) && instance_nearest(obj_player.x,obj_player.y,obj_mine_cart)==id) _enter_cart();
}
if(has_player && (yp_input("W",true) || keyboard_check_pressed(vk_up) || keyboard_check_pressed(vk_space))) {
    if(_exit_cart()) obj_player.vspd=-10;
}
on_rail=place_meeting(x,y+1,obj_rail) || place_meeting(x,y+1,obj_platform);
vspd=min(vspd+grv,16);
var _remain=vspd;
while(_remain>0){
    var _dy=min(1,_remain);
    if(place_meeting(x,y+_dy,obj_platform)||place_meeting(x,y+_dy,obj_rail)){vspd=0;on_rail=true;break;}
    y+=_dy;_remain-=_dy;
}
if(on_rail && has_player){
    var _dir=(yp_input("D",false)||keyboard_check(vk_right))-(yp_input("A",false)||keyboard_check(vk_left));
    cart_spd=clamp(cart_spd+_dir*cart_accel,-cart_spd_max,cart_spd_max);
}
cart_spd*=1-cart_friction;
if(abs(cart_spd)<0.1) cart_spd=0;
var _remain=abs(cart_spd),_dir=sign(cart_spd);
while(_remain>0){
    var _dx=min(1,_remain)*_dir;
    if(x+_dx<0 || bbox_right+_dx>=room_width || place_meeting(x+_dx,y,obj_platform)){cart_spd=0;break;}
    x+=_dx;_remain-=abs(_dx);
}
_sync_rider();
if(y>room_height+96) {
    if(instance_exists(obj_player) && has_player) obj_player.riding_cart=noone;
    has_player=false;x=xstart;y=ystart;vspd=0;cart_spd=0;
}
