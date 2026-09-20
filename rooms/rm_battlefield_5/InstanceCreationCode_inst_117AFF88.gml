/// @description Campaign route: rm_battlefield_5 -> rm_olympus_1
event_inherited();
target_room = rm_olympus_1;
spawn_tag = "battlefield_5__olympus_1";
exit_direction = "up";
required_item = "sword";
is_locked = false;
lock_reason = "";
show_prompt = true;
exit_width = 160;
exit_height = 128;
_dir_color = _room_route_exit_color(exit_direction);
