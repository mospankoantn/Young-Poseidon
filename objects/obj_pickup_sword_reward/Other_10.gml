/// @description
/// obj_pickup_sword_reward — User Event 0

with (obj_player) { _unlock_weapon(5); }
if (instance_exists(obj_ui_controller))
    obj_ui_controller.show_hint(lc("reward_sword"), 240);

// audio_play_sound(snd_weapon_get, 1, false);
instance_destroy();