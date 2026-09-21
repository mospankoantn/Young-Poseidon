if (instance_exists(obj_player) && point_distance(x, y, obj_player.x, obj_player.y) <= 110)
    yp_trigger_hint("raft", "hint_raft", 240);

has_player=false;
if(instance_exists(obj_player) && !obj_player.is_dead && obj_player.hp>0) {
    has_player=obj_player.bbox_right>bbox_left && obj_player.bbox_left<bbox_right
        && abs(obj_player.bbox_bottom-(bbox_top-1))<=5 && obj_player.vspd>=0 && obj_player.drop_timer<=0;
}
if(has_player && obj_player.current_weapon==4) {
    var _dir=(yp_input("D",false)||keyboard_check(vk_right))-(yp_input("A",false)||keyboard_check(vk_left));
    raft_spd=clamp(raft_spd+_dir*0.3,-raft_spd_max,raft_spd_max);
    if(_dir!=0 && obj_player.anim_action_timer<=0) obj_player._play_weapon_action("special");
}
raft_spd*=1-raft_friction;
if(abs(raft_spd)<0.1) raft_spd=0;
var _old_x=x;
if(bbox_left+raft_spd>=0 && bbox_right+raft_spd<room_width && !place_meeting(x+raft_spd,y,obj_platform))
    x+=raft_spd;
else raft_spd=0;
bob_timer+=0.04;
var _new_y=base_y+sin(bob_timer)*3;
if(!place_meeting(x,_new_y,obj_platform)) y=_new_y;
if(has_player){
    var _dx=x-_old_x;
    // Contact with this raft is allowed; walls and ceilings are not.
    with(obj_player){
        if(!place_meeting(x+_dx,y,obj_platform)) x+=_dx;
        var _dy=other.bbox_top-1-bbox_bottom;
        if(!place_meeting(x,y+_dy,obj_platform)) y+=_dy;
    }
}
player_was_on=has_player;
