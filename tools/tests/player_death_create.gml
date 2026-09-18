persistent = true;
report_path = "__REPORT__";
restart_ok = file_exists(report_path);
global.load_pending = false;
p = instance_create_layer(120, 300, "Instances", obj_player);
p.grv = 0;
p.l_right = false;
p.image_xscale = -1;
p.current_weapon = 5;
p.weapon_unlocked[5] = true;
p.potion_heal_count = 2;
stage = -1;
if (restart_ok)
{
    global.checkpoint_room = room;
    global.checkpoint_x = 600;
    global.checkpoint_y = 300;
    stage = 0;
}
else p.hp = 0;
tick = 0;
death_ticks = 0;
seen = array_create(sprite_get_number(spr_player_death), false);
previous_frame = -1;
check = function(ok, message)
{
    if (!ok)
    {
        var f = file_text_open_write(report_path);
        file_text_write_string(f, "FAIL: " + message);
        file_text_close(f);
        game_end();
    }
};
