/// @description obj_pickup_pickaxe_reward — User Event 0
/// obj_pickup_pickaxe_reward — User Event 0

world_state_mark_instance(id, "pickup");
with (obj_player) { _unlock_weapon(2); }
autosave_game();

if (instance_exists(obj_ui_controller))
    obj_ui_controller.show_hint(lc("reward_pickaxe"), 240);

// audio_play_sound(snd_weapon_get, 1, false);
instance_destroy();
