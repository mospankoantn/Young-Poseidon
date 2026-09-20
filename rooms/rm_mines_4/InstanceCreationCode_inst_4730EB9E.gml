/// @description Campaign route: rm_mines_4 -> rm_mines_5
event_inherited();
target_room = rm_mines_5;
spawn_tag = "mines_4__mines_5";
exit_direction = "right";
required_item = "pickaxe";
is_locked = false;
lock_reason = "";
show_prompt = true;
exit_width = 96;
exit_height = 160;
_dir_color = _room_route_exit_color(exit_direction);
