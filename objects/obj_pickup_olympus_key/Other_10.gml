/// @description
/// obj_pickup_olympus_key — User Event 0

world_state_mark_instance(id, "pickup");
with (obj_player)
{
    has_olympus_key = true;
}
 
// Активуємо всі двері в кімнаті
with (obj_olympus_door)
{
    event_user(0);   // Відкрити двері
}

if (instance_exists(obj_ui_controller))
    obj_ui_controller.show_hint(lc("reward_key"), 240);

// audio_play_sound(snd_weapon_get, 1, false);
instance_destroy();
