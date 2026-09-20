/// @description Campaign route: rm_hades_2 -> rm_hades_3
event_inherited();
target_room = rm_hades_3;
spawn_tag = "hades_2__to__hades_3";
exit_direction = "up";
required_item = "";
is_locked = false;
lock_reason = ""; 
show_prompt = true;
exit_width = 160;
exit_height = 128;
_dir_color = _room_route_exit_color(exit_direction);
spawn_x = 704;
spawn_y = 512; // one-way route: safe fallback in destination
