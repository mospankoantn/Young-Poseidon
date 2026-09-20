/// @description Campaign route: rm_coast_3 -> rm_coast_2
event_inherited();
target_room = rm_coast_2;
spawn_tag = "coast_2__coast_3";
exit_direction = "down";
required_item = "";
is_locked = false;
lock_reason = "";
show_prompt = true;
exit_width = 160;
exit_height = 128;
_dir_color = _room_route_exit_color(exit_direction);
