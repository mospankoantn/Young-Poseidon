/// @description Амфора з цілющим зіллям: додає у інвентар одне зілля здоров'я
// obj_pickup_potion_heal — Collision with obj_player

if (can_pickup)
{
    world_state_mark_instance(id, "pickup");
    with (other)
    {
        potion_heal_count++;
    }
    yp_trigger_hint("potion_heal", "hint_potion_heal", 260);
    // audio_play_sound(snd_pickup, 1, false);
    instance_destroy();
}
