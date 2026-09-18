is_cleared=false;interact_range=60;cut_timer=0;is_cutting=false;image_speed=0;
_start_cut=function(){
    if(is_cutting) return;
    is_cutting=true;is_cleared=true;cut_timer=0;
    sprite_index=-1;mask_index=-1;solid=false;
    if(instance_exists(obj_player)) obj_player._play_weapon_action("special");
};
