/// @description Campaign route: rm_battlefield_4 -> rm_battlefield_5
event_inherited();
target_room = rm_battlefield_5;
spawn_tag = "battlefield_4__battlefield_5";
exit_direction = "right";
required_item = "";
is_locked = false;
lock_reason = "";
show_prompt = true;
exit_width = 96;
exit_height = 160;
_dir_color = _room_route_exit_color(exit_direction);
