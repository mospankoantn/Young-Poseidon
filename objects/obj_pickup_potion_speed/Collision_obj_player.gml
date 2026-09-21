 /// @description Зілля Гермеса: додає у інвентар одне зілля швидкості
 // obj_pickup_potion_speed — Collision with obj_player
 
if (can_pickup)
{
    world_state_mark_instance(id, "pickup");
    with (other)
    {
        potion_speed_count++;
    }
    yp_trigger_hint("potion_speed", "hint_potion_speed", 260);
    // audio_play_sound(snd_pickup, 1, false);
    instance_destroy();
}
