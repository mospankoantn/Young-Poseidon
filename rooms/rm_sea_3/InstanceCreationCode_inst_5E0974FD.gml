/// @description Campaign route: rm_sea_3 -> rm_sea_2
event_inherited();
target_room = rm_sea_2;
spawn_tag = "sea_2__to__sea_3";
exit_direction = "down"; 
required_item = "trident";
is_locked = false;
lock_reason = ""; 
show_prompt = true;
exit_width = 160;
exit_height = 128;
_dir_color = _room_route_exit_color(exit_direction);
