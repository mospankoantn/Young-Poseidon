if(is_cutting){
    cut_timer++;image_alpha=max(0,1-cut_timer/20);
    if(cut_timer>=20) instance_destroy();
    exit;
}
if(!prop_player_near(interact_range)) exit;
if(obj_player.current_weapon==3 && (yp_input("E",true) || place_meeting(x,y,obj_player))) _start_cut();
