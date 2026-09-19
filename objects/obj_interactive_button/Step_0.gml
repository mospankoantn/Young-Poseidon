if(one_time_use && world_state_has(world_state_instance_key(id,"activated")))
{
    is_pressed=true;
    image_index=1;
    exit;
}
if(!prop_player_near(interact_range) || prop_nearest_button()!=id) exit;
if(yp_input("E",true)) press_button();
