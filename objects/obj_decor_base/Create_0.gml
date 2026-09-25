zone = string_replace(object_get_name(object_index), "obj_decor_", "");
phase = random(pi * 2);
age = 0;
drift = random_range(8, 22);
home_y = y;
ambient_timer = room_speed * irandom_range(5, 12);
ambient_source = false;
depth = 100;
