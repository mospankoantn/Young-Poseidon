if(state==1) {
    fall_spd=min(fall_spd+grv,20);
    // Sweep at one-pixel intervals so thin ledges and the boss cannot be skipped.
    var _remaining=fall_spd;
    while(_remaining>0) {
        var _dy=min(1,_remaining);
        if(place_meeting(x,y+_dy,obj_platform)){rock_land();break;}
        y+=_dy;_remaining-=_dy;
        if(!hit_boss && instance_exists(obj_boss_triton) && place_meeting(x,y,obj_boss_triton)) {
            if(obj_boss_triton.hp>0) with(obj_boss_triton) event_user(0);
            hit_boss=true;
        }
        if(!hit_player && instance_exists(obj_player) && !obj_player.is_dead
            && place_meeting(x,y,obj_player) && !obj_player.is_damage) {
            obj_player.hp-=damage;obj_player.vspd=-5;
            obj_player.is_damage=true;obj_player.alarm[0]=room_speed;
            hit_player=true;
        }
    }
    if(y>room_height+64) rock_land();
}
if(state==2) {
    debris_timer--;
    image_alpha=clamp(debris_timer/room_speed,0,1);
    if(debris_timer<=0) {state=3;image_alpha=0;}
}
if(state==3 && !instance_exists(obj_boss_triton)) instance_destroy();
