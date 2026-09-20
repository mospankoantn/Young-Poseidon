/// @description Campaign route: rm_coast_3 -> rm_coast_4
event_inherited();
target_room = rm_coast_4;
spawn_tag = "coast_3__coast_4";
exit_direction = "up";
required_item = "";
is_locked = false;
lock_reason = "";
show_prompt = true;
exit_width = 160;
exit_height = 128;
_dir_color = _room_route_exit_color(exit_direction);
