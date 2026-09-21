/// @description
/// obj_pickup_olympus_key — User Event 0

world_state_mark_instance(id, "pickup");
with (obj_player)
{
    has_olympus_key = true;
}

// The key no longer opens every Olympus door automatically. The player must
// approach the final gate and use the normal interaction action [F].
show_weapon_cutscene("key");
autosave_game();

if (instance_exists(obj_ui_controller))
    obj_ui_controller.show_hint(lc("reward_key"), 240);

// audio_play_sound(snd_weapon_get, 1, false);
instance_destroy();
