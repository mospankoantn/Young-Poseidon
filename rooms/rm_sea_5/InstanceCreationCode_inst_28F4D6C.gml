/// @description Campaign route: rm_sea_5 -> rm_coast_1
event_inherited();
target_room = rm_coast_1;
spawn_tag = "sea_5__to__coast_1";
exit_direction = "right";
required_item = "";
is_locked = false;
lock_reason = "";
show_prompt = true;
exit_width = 96;
exit_height = 160;
_dir_color = _room_route_exit_color(exit_direction);

 