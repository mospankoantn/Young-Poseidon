/// @description Campaign route: rm_battlefield_2 -> rm_battlefield_3
event_inherited();
target_room = rm_battlefield_3;
spawn_tag = "battlefield_2__battlefield_3";
exit_direction = "up";
required_item = "";
is_locked = false;
lock_reason = "";
show_prompt = true;
exit_width = 160;
exit_height = 128;
_dir_color = _room_route_exit_color(exit_direction);
