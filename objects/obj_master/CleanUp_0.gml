/// @description obj_master — Cleanup Event

if (skip_cleanup) exit;

if (variable_global_exists("room_names") && ds_exists(global.room_names, ds_type_map))
    ds_map_destroy(global.room_names);
