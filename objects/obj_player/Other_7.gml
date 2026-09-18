/// @description Finish death playback once; respawn on the next Step.
if (is_dead && sprite_index == spr_player_death)
{
    image_index = image_number - 1;
    image_speed = 0;
    death_finished = true;
}
