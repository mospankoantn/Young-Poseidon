tick++;
if (tick > 300) { check(false, "timeout"); exit; }
check(p.mask_index == spr_player, "collision mask changed");
switch (stage)
{
    case -1:
        if (p.death_finished)
        {
            var f = file_text_open_write(report_path);
            file_text_write_string(f, "RESTART_PENDING");
            file_text_close(f);
        }
        break;
    case 0:
        p.hp = 0;
        p.alarm[0] = 2;
        keyboard_key_press(ord("D"));
        keyboard_key_press(ord("W"));
        keyboard_key_press(ord("E"));
        keyboard_key_press(ord("Z"));
        stage = 1;
        break;
    case 1:
        if (p.is_dead)
        {
            death_ticks++;
            check(p.hp <= 0, "HP restored during death");
            check(p.x == 120 && p.y == 300, "movement during death");
            check(p.potion_heal_count == 2, "potion consumed during death");
            check(p.hspd == 0 && p.vspd == 0, "attack or jump during death");
            check(p.image_xscale == -1, "facing changed during death");
            check(p.sprite_index == spr_player_death, "death interrupted");
            check(p.is_damage, "damage immunity ended before death");
            var frame = floor(p.image_index);
            check(frame >= previous_frame, "death animation looped");
            previous_frame = frame;
            seen[frame] = true;
            p._play_player_action(spr_player_attack);
            check(p.sprite_index == spr_player_death, "action overrides death");
            if (p.death_finished)
            {
                keyboard_key_release(ord("D"));
                keyboard_key_release(ord("W"));
                keyboard_key_release(ord("E"));
                keyboard_key_release(ord("Z"));
            }
        }
        else if (death_ticks > 0)
        {
            for (var i = 0; i < array_length(seen); i++)
                check(seen[i], "missing death frame " + string(i));
            check(death_ticks >= 35, "respawn before clip completed");
            check(p.hp == p.max_hp, "HP not restored");
            check(p.x == 600 && p.y == 300, "same-room checkpoint changed");
            check(!p.is_damage, "expired damage immunity persists");
            global.checkpoint_room = rm_sea_1;
            p.hp = -2;
            with (p) event_perform(ev_step, ev_step_end);
            check(p.is_dead && p.image_index == 0, "End Step lethal damage");
            stage = 2;
        }
        break;
    case 2:
        if (room == rm_sea_1)
        {
            check(p.hp == p.max_hp && !p.is_dead, "cross-room respawn");
            check(p.sprite_index != spr_player_death, "death state not reset");
            var f = file_text_open_write(report_path);
            file_text_write_string(f, "PASS: all death frames once, input lock, facing, mask, same-room and cross-room checkpoint");
            file_text_writeln(f);
            file_text_write_string(f, "PASS: no-checkpoint game_restart");
            file_text_writeln(f);
            file_text_close(f);
            game_end();
        }
        break;
}
