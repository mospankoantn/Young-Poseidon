if (instance_exists(obj_player) && point_distance(x, y, obj_player.x, obj_player.y) <= 100)
    yp_trigger_hint("thicket", "hint_thicket", 240);

if(is_cutting){
    cut_timer++;image_alpha=max(0,1-cut_timer/20);
    if(cut_timer>=20) instance_destroy();
    exit;
}
if(!prop_player_near(interact_range)) exit;
if(obj_player.current_weapon==3 && (yp_input("E",true) || place_meeting(x,y,obj_player))) _start_cut();
