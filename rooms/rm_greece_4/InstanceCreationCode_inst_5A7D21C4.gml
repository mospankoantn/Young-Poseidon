/// @description Campaign route: rm_greece_4 -> rm_greece_5
event_inherited();
target_room = rm_greece_5;
spawn_tag = "greece_4__greece_5";
exit_direction = "right";
required_item = "oar";
is_locked = false;
lock_reason = "";
show_prompt = true;
exit_width = 96;
exit_height = 160;
_dir_color = _room_route_exit_color(exit_direction);
