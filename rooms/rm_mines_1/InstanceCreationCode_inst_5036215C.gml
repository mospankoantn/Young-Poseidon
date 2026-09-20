/// @description Campaign route: rm_mines_1 -> rm_coast_5
event_inherited();
target_room = rm_coast_5;
spawn_tag = "coast_5__mines_1";
exit_direction = "left";
required_item = "";
is_locked = false;
lock_reason = "";
show_prompt = true;
exit_width = 96;
exit_height = 160;
_dir_color = _room_route_exit_color(exit_direction);
