life_timer--;
if(life_timer<=0 || y>room_height+96){instance_destroy();exit;}
if(landed) {
    debris_timer--;image_alpha=clamp(debris_timer/room_speed,0,1);
    if(debris_timer<=0) instance_destroy();
    exit;
}
vspd=min(vspd+grv,20);
var _remaining=vspd;
while(_remaining>0) {
    var _dy=min(1,_remaining);
    if(place_meeting(x,y+_dy,obj_platform)){landed=true;image_index=1;vspd=0;break;}
    y+=_dy;_remaining-=_dy;
    if(!hit_boss && instance_exists(obj_boss_charon) && place_meeting(x,y,obj_boss_charon)){
        if(obj_boss_charon.hp>0) obj_boss_charon.hp-=damage;
        hit_boss=true;
    }
    if(!hit_player && instance_exists(obj_player) && !obj_player.is_dead
        && place_meeting(x,y,obj_player) && !obj_player.is_damage) {
        obj_player.hp-=damage;obj_player.vspd=-3;
        obj_player.is_damage=true;obj_player.alarm[0]=room_speed;hit_player=true;
    }
}
