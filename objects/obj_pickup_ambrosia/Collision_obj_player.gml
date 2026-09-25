/// @description Амброзія: перманентно збільшує max_hp на 1 і повністю відновлює здоров'я
// obj_pickup_ambrosia — Collision with obj_player

if (can_pickup)
{
    world_state_mark_instance(id, "pickup");
yp_sfx("pickup", x);
    with (other)  // other = obj_player
    {
        max_hp += 1;
        hp      = max_hp;
    }
    yp_trigger_hint("ambrosia", "hint_ambrosia", 260);
    // audio_play_sound(snd_pickup_ambrosia, 1, false);
    instance_destroy();
}
