/// @description Зілля Геракла: додає у інвентар одне зілля сили
 // obj_pickup_potion_strength — Collision with obj_player


if (can_pickup)
{
    world_state_mark_instance(id, "pickup");
    with (other)
    {
        potion_strength_count++;
    }
    // audio_play_sound(snd_pickup, 1, false);
    instance_destroy();
}
