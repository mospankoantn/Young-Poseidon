/// @description Викликається кнопкою. Запускає падіння.  
// obj_falling_rocks — User Event 0

if (state == 0 && is_next)
{
    state        = 1;
    show_warning = false;
    is_next      = false;
    // audio_play_sound(snd_rock_fall_start, 1, false);
}
