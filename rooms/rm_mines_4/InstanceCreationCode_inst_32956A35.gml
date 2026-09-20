/// @description Campaign route: rm_mines_4 -> rm_mines_3
event_inherited();
target_room = rm_mines_3;
spawn_tag = "mines_3__mines_4";
exit_direction = "up";
required_item = "";
is_locked = false;
lock_reason = "";
show_prompt = true;
exit_width = 160;
exit_height = 128;
_dir_color = _room_route_exit_color(exit_direction);
