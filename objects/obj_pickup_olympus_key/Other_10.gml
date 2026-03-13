/// @description
/// obj_pickup_olympus_key — User Event 0

with (obj_player)
{
    has_olympus_key = true;
}
 
// Активуємо всі двері в кімнаті
with (obj_olympus_door)
{
    event_user(0);   // Відкрити двері
}
 
// audio_play_sound(snd_key_get, 1, false);
instance_destroy();