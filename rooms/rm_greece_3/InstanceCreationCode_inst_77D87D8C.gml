/// @description Campaign route: rm_greece_3 -> rm_greece_2
event_inherited();
target_room = rm_greece_2;
spawn_tag = "greece_2__greece_3";
exit_direction = "left";
required_item = "";
is_locked = false;
lock_reason = "";
show_prompt = true;
exit_width = 96;
exit_height = 160;
_dir_color = _room_route_exit_color(exit_direction);
