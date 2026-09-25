damage=1;fall_spd=0;grv=0.6;
initial_x=x;initial_y=y;
state=0;is_next=false;show_warning=false;solid=false;
image_speed=0;image_index=0;
debris_timer=0;hit_boss=false;hit_player=false;
rock_reset=function(){
    x=initial_x;y=initial_y;fall_spd=0;state=0;is_next=false;
    hit_boss=false;hit_player=false;debris_timer=0;image_alpha=1;image_index=0;
};
rock_land=function(){
    if(state!=2) yp_sfx("stone", x);
    state=2;fall_spd=0;solid=false;debris_timer=room_speed*3;image_index=1;
};
