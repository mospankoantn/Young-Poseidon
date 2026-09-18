report_path = "__REPORT__";
global.load_pending = false;
p = instance_create_layer(400, 300, "Instances", obj_player);
p.grv = 0;
p.anim_was_on_ground = true;
floor_instance = instance_create_layer(0, 0, "Instances", obj_platform);
floor_instance.image_xscale = 40;
floor_instance.y += p.bbox_bottom - floor_instance.bbox_top;
t = instance_create_layer(p.x, p.y, "Instances", obj_trident);
p.trident_instance = t;
tick = 0;
check = function(ok, message)
{
    if (!ok && !file_exists(report_path))
    {
        var f = file_text_open_write(report_path);
        file_text_write_string(f, "FAIL: " + message);
        file_text_close(f);
        game_end();
    }
};
rewards = [obj_pickup_trident_reward, obj_pickup_spear_reward,
    obj_pickup_pickaxe_reward, obj_pickup_scythe_reward,
    obj_pickup_oar_reward, obj_pickup_sword_reward];
