/// @description Campaign route: rm_hades_1 -> rm_hades_2
event_inherited();
target_room = rm_hades_2;
spawn_tag = "hades_1__to__hades_2";
exit_direction = "down";
required_item = "";
is_locked = false;
lock_reason = "";
show_prompt = true;
exit_width = 96;
exit_height = 160;
_dir_color = _room_route_exit_color(exit_direction);
spawn_x = 704;
spawn_y = 512; // one-way route: safe fallback in destination
