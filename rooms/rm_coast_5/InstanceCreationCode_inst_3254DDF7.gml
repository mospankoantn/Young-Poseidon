/// @description Campaign route: rm_coast_5 -> rm_mines_1
event_inherited();
target_room = rm_mines_1;
spawn_tag = "coast_5__mines_1";
exit_direction = "right";
required_item = "spear";
is_locked = false;
lock_reason = "";
show_prompt = true;
exit_width = 96;
exit_height = 160;
_dir_color = _room_route_exit_color(exit_direction);
