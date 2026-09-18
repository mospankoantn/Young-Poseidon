/// @description 
/// obj_pickup_trident_reward — User Event 0

with (obj_player) { _unlock_weapon(0); }
if (instance_exists(obj_ui_controller))
    obj_ui_controller.show_hint(lc("reward_trident"), 240);
// audio_play_sound(snd_weapon_get, 1, false);
instance_destroy();