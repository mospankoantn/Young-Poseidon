/// @description Campaign route: rm_sea_2 -> rm_sea_1
event_inherited();
target_room = rm_sea_1;
spawn_tag = "sea_1__sea_2";
exit_direction = "left";
required_item = "";
is_locked = false;
lock_reason = "";
show_prompt = true;
exit_width = 96;
exit_height = 160;
_dir_color = _room_route_exit_color(exit_direction);
