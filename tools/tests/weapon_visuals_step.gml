// Let the startup display reset finish before injecting keyboard input.
if (warmup > 0) { warmup--; exit; }
tick++;
if (tick == 1)
{
    for (var w = 0; w < 6; w++)
    {
        var reward = instance_create_layer(100, 100, "Instances", rewards[w]);
        check(reward.sprite_index == p.weapon_sprites[w], "reward sprite " + string(w));
        check(reward.mask_index == spr_weapon_collision, "reward mask " + string(w));
        check(reward.image_blend == c_white, "reward tint " + string(w));
        with (reward) event_user(0);
        check(p.current_weapon == w && p.weapon_unlocked[w], "unlock " + string(w));
        check(p.anim_action_sprite == p.weapon_animations[w].pickup, "pickup clip " + string(w));
        check(p._weapon_locomotion(false) == p.weapon_animations[w].idle, "idle mapping");
        check(p._weapon_locomotion(true) == p.weapon_animations[w].run, "run mapping");
        p.anim_action_timer = 0;
        p.anim_was_on_ground = true;
        p.anim_last_x = p.x;
        p.vspd = 0;
        with (p) event_perform(ev_step, ev_step_end);
        check(p.sprite_index == p.weapon_animations[w].idle, "grounded idle " + string(w) + " sprite=" + sprite_get_name(p.sprite_index) + " ground=" + string(p.anim_was_on_ground) + " bottom=" + string(p.bbox_bottom) + " floor=" + string(floor_instance.bbox_top) + " hand=" + string(p._weapon_in_hand()));
        p.anim_last_x = p.x - 10;
        p.l_right = false;
        with (p) event_perform(ev_step, ev_step_end);
        check(p.sprite_index == p.weapon_animations[w].run && p.image_xscale == -1, "left run");
        p._play_weapon_action("attack");
        check(p.sprite_index == p.weapon_animations[w].attack, "attack mapping");
        p.current_weapon = (w + 1) mod 6;
        with (p) event_perform(ev_step, ev_step_end);
        check(p.anim_action_timer == 0, "old action after switching " + string(w) + " sprite=" + sprite_get_name(p.sprite_index) + " marker=" + string(p.anim_action_weapon));
        p.current_weapon = w;
        p._play_player_action(spr_player_hurt);
        p._play_weapon_action("pickup");
        check(p.sprite_index == spr_player_hurt, "pickup overrides hurt");
        p.anim_action_timer = 0;
        check(p.mask_index == spr_player, "player mask");
    }
    p.current_weapon = 1;
    t.thrown = true;
    check(p._weapon_locomotion(false) == spr_player_idle, "duplicate held projectile");
    t.thrown = false;
    t.stuck = true;
    check(!p._weapon_in_hand(), "stuck weapon still in hand");
    var ledge = instance_create_layer(700, 100, "Instances", obj_trident_platform);
    check(ledge.mask_index == spr_weapon_collision && !ledge.visible, "stuck weapon ledge mask or duplicate artwork");
    check(sprite_get_width(ledge.mask_index) == 32 && sprite_get_height(ledge.mask_index) == 10, "ledge dimensions changed");
    instance_destroy(ledge);
    t.stuck = false;
    p.l_right = true;
    global.test_attack_pressed = true;
    with (p) event_perform(ev_step, ev_step_normal);
    global.test_attack_pressed = false;
}
if (tick == 3)
{
    check(t.visual_weapon == 1, "spear throw appearance: weapon=" + string(p.current_weapon) + " thrown=" + string(t.thrown));
    check(p.anim_action_sprite == spr_player_spear_cast, "cast input");
    check(t.mask_index == spr_weapon_collision, "throw mask");
    global.test_recall_pressed = true;
    with (p) event_perform(ev_step, ev_step_normal);
    global.test_recall_pressed = false;
}
if (tick == 5)
{
    check(!t.thrown && !t.stuck, "recall input");
    check(p.anim_action_sprite == spr_player_spear_recall, "recall clip");
    var key = instance_create_layer(80, 80, "Instances", obj_pickup_olympus_key);
    check(key.sprite_index == spr_olympus_key, "key sprite");
    with (key) event_user(0);
    check(p.has_olympus_key, "key reward");
    var objs = [obj_proj_water_ball, obj_proj_coin, obj_proj_spear_ghost,
        obj_proj_fate_beam, obj_proj_lightning, obj_charon_scythe];
    var sprs = [spr_projectile_water, spr_projectile_coin, spr_projectile_ghost_spear,
        spr_projectile_fate, spr_projectile_lightning, spr_projectile_scythe];
    var masks = [spr_test_proj, spr_test_proj, spr_test_arrow,
        spr_test_arrow, spr_test_proj, spr_test_arrow];
    for (var i = 0; i < array_length(objs); i++)
    {
        var proj = instance_create_layer(100 + i * 100, 150, "Instances", objs[i]);
        check(proj.sprite_index == sprs[i], "projectile sprite " + string(i));
        check(proj.mask_index == masks[i], "projectile mask " + string(i));
    }
    p.current_weapon = 2;
    p._play_weapon_action("special");
}
if (tick == 10)
    check(p.sprite_index == spr_player_pickaxe_special, "action interrupted early");
if (tick == 45)
{
    check(p.anim_action_timer <= 0 && p.sprite_index == spr_player_pickaxe_idle, "action did not finish");
    var f = file_text_open_write(report_path);
    file_text_write_string(f, "PASS: weapon visuals: six pickups, idle/run, facing, actions, switching, hurt priority, throw/recall, key, ledge and six projectile masks.");
    file_text_close(f);
    game_end();
}
