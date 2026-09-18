cart_spd=0;cart_spd_max=8;cart_accel=0.2;cart_friction=0.05;
has_player=false;interact_range=50;vspd=0;grv=0.5;on_rail=false;
image_speed=0;
_sync_rider=function(){
    if(!has_player || !instance_exists(obj_player)) return;
    obj_player.x=(bbox_left+bbox_right)*0.5;
    obj_player.y=bbox_top+32;
    obj_player.vspd=0;obj_player.hspd=0;
};
_enter_cart=function(){
    if(!prop_player_near(interact_range) || has_player) return false;
    if(instance_exists(obj_player.riding_cart)) return false;
    has_player=true;obj_player.riding_cart=id;_sync_rider();return true;
};
_exit_cart=function(){
    if(!has_player || !instance_exists(obj_player)) return false;
    var _p=obj_player;
    var _candidates=[[(bbox_left+bbox_right)/2,bbox_top-2],[bbox_left-28,bbox_bottom],[bbox_right+28,bbox_bottom]];
    for(var _i=0;_i<array_length(_candidates);_i++){
        var _xx=clamp(_candidates[_i][0],28,room_width-28),_yy=_candidates[_i][1];
        var _blocked=false;with(_p) _blocked=place_meeting(_xx,_yy,obj_platform);
        if(!_blocked){
            has_player=false;_p.riding_cart=noone;_p.x=_xx;_p.y=_yy;
            _p.hspd=cart_spd;_p.vspd=0;return true;
        }
    }
    return false;
};
