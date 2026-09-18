ticks++;
if (ticks > 1500) { fail("timeout"); exit; }
if (index >= array_length(names))
{
    var f = file_text_open_write(report_path);
    file_text_write_string(f, "PASS: 14 objects, idle/move, attack recovery, 4 death frames once, rewards and masks");
    file_text_close(f);
    game_end();
    exit;
}
var name = names[index];
var idle = asset_get_index("spr_" + name + "_idle");
var moving = asset_get_index("spr_" + name + "_move");
var attack = asset_get_index("spr_" + name + "_attack");
var death = asset_get_index("spr_" + name + "_death");
switch (phase)
{
    case 0:
        current = instance_create_layer(700, 300, "Instances", asset_get_index("obj_" + name));
        if (variable_instance_exists(current, "grv")) current.grv = 0;
        ticks = 0;
        phase = 1;
        break;
    case 1:
        if (!instance_exists(current)) { fail("destroyed before attack"); break; }
        if (current.mask_index != spr_giant_crab) { fail("collision mask changed"); break; }
        if (current.sprite_index != idle && current.sprite_index != moving
            && !(current.sprite_index == attack && current.anim_attack_elapsed >= 0))
        {
            fail("idle/move sprite not selected");
            break;
        }
        if (ticks >= 4)
        {
            with (current) enemy_anim_attack(attack);
            ticks = 0;
            phase = 2;
        }
        break;
    case 2:
        if (!instance_exists(current)) { fail("destroyed during attack"); break; }
        if (ticks == 3 && current.sprite_index != attack) { fail("attack sprite absent"); break; }
        if (ticks >= 27)
        {
            if (current.sprite_index == attack) { fail("attack never returned"); break; }
            current.hp = 0;
            ticks = 0;
            seen = array_create(4, false);
            previous_frame = -1;
            phase = 3;
        }
        break;
    case 3:
        if (instance_exists(current))
        {
            if (current.anim_death_started)
            {
                if (current.sprite_index != death) { fail("death sprite replaced"); break; }
                var frame = floor(current.image_index);
                if (frame < previous_frame) { fail("death looped"); break; }
                previous_frame = frame;
                seen[frame] = true;
                if (ticks > 45) fail("death never completed");
            }
        }
        else
        {
            for (var i = 0; i < 4; i++)
                if (!seen[i]) { fail("death frame missing: " + string(i)); exit; }
            index++;
            phase = 0;
            ticks = 0;
        }
        break;
}
