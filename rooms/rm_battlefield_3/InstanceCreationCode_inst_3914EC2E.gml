/// @description Campaign route: rm_battlefield_3 -> rm_battlefield_4
event_inherited();
target_room = rm_battlefield_4;
spawn_tag = "battlefield_3__battlefield_4";
exit_direction = "right";
required_item = "";
is_locked = false;
lock_reason = "";
show_prompt = true;
exit_width = 96;
exit_height = 160;
_dir_color = _room_route_exit_color(exit_direction);
