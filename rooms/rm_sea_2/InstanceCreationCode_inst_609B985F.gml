/// @description Campaign route: rm_sea_2 -> rm_sea_3
event_inherited();
target_room = rm_sea_3;
spawn_tag = "sea_2__to__sea_3";
exit_direction = "up";
required_item = "";
is_locked = false;
lock_reason = "";
show_prompt = true;
exit_width = 160;
exit_height = 128;
_dir_color = _room_route_exit_color(exit_direction);
spawn_x = 128;
spawn_y = 512; // one-way route: safe fallback in destination
