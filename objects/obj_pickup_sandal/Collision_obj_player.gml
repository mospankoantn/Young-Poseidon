/// @description Сандаль Гермеса: перманентно збільшує швидкість гравця
 // obj_pickup_sandal — Collision with obj_player

if (can_pickup)
{
    with (other)
    {
        perm_spd_bonus += 0.3;  // +30% до базової швидкості
    }
    // audio_play_sound(snd_pickup_sandal, 1, false);
    instance_destroy();
}