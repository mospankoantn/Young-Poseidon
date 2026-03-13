 /// @description Зілля Гермеса: додає у інвентар одне зілля швидкості
 // obj_pickup_potion_speed — Collision with obj_player
 
if (can_pickup)
{
    with (other)
    {
        potion_speed_count++;
    }
    // audio_play_sound(snd_pickup, 1, false);
    instance_destroy();
}