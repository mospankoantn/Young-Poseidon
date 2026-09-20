/// @description Campaign route: rm_mines_3 -> rm_mines_2
event_inherited();
target_room = rm_mines_2;
spawn_tag = "mines_2__mines_3";
exit_direction = "down";
required_item = "";
is_locked = false;
lock_reason = "";
show_prompt = true;
exit_width = 160;
exit_height = 128;
_dir_color = _room_route_exit_color(exit_direction);
