/// @description Амброзія: перманентно збільшує max_hp на 1 і повністю відновлює здоров'я
// obj_pickup_ambrosia — Collision with obj_player

if (can_pickup)
{
    with (other)  // other = obj_player
    {
        max_hp += 1;
        hp      = max_hp;
    }
    // audio_play_sound(snd_pickup_ambrosia, 1, false);
    instance_destroy();
}