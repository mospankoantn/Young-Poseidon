/// @description Campaign route: rm_greece_2 -> rm_greece_1
event_inherited();
target_room = rm_greece_1;
spawn_tag = "greece_1__greece_2";
exit_direction = "down";
required_item = "";
is_locked = false;
lock_reason = "";
show_prompt = true;
exit_width = 160;
exit_height = 128;
_dir_color = _room_route_exit_color(exit_direction);
