/// @description Campaign route: rm_mines_1 -> rm_mines_2
event_inherited();
target_room = rm_mines_2;
spawn_tag = "mines_1__mines_2";
exit_direction = "right";
required_item = "";
is_locked = false;
lock_reason = "";
show_prompt = true;
exit_width = 96;
exit_height = 160;
_dir_color = _room_route_exit_color(exit_direction);
