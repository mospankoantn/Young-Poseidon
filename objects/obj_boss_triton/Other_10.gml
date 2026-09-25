/// @description Викликається obj_falling_rocks коли попадає в Тритона.
// obj_boss_triton — User Event 0
// 10 шкоди за кожен камінь.

enemy_take_hit(id, 10, x);
// Ефект попадання каміння
// audio_play_sound(snd_triton_hit, 1, false);
