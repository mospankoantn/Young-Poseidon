if(!is_open && prop_player_near(interact_range) && obj_player.has_olympus_key && yp_input("E",true)) event_user(0);
if(is_open) {
    open_timer=min(open_timer+1,30);
    if(open_timer>=30){solid=false;sprite_index=-1;mask_index=-1;}
}
