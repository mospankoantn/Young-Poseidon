/// @description Campaign route: rm_coast_1 -> rm_sea_3
event_inherited();
target_room = rm_sea_5;
spawn_tag = "sea_5__to__coast_1";
exit_direction = "left";
required_item = "";
is_locked = false; 
lock_reason = "";
show_prompt = true;
exit_width = 96;
exit_height = 160;
_dir_color = _room_route_exit_color(exit_direction);
spawn_x = x;
spawn_y = y; // one-way route: safe fallback in destination
