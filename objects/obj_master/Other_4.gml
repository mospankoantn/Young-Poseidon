/// @description Apply pending save data after a room has loaded.
// obj_master Room Start Event

room_hud_update_zone();
room_route_exits_rebuild();

if (variable_global_exists("load_pending") && global.load_pending)
{
    if (!instance_exists(obj_player))
        instance_create_layer(global.load_x, global.load_y, "Instances", obj_player);

    apply_pending_load_to_player();
}
