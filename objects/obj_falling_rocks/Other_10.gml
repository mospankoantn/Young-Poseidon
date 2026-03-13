/// @description Викликається кнопкою. Запускає падіння.  
// obj_falling_rocks — User Event 0

if (state == 0)
{
    state        = 1;
    show_warning = false;
    // audio_play_sound(snd_rock_fall_start, 1, false);
}