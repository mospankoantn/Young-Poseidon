/// @description Campaign route: rm_sea_3 -> rm_sea_5
event_inherited();
target_room = rm_sea_5;
spawn_tag = "sea_3__sea_5";
exit_direction = "right";
required_item = "trident";
is_locked = false;
lock_reason = "";
show_prompt = true;
exit_width = 96;
exit_height = 160;
_dir_color = _room_route_exit_color(exit_direction);
