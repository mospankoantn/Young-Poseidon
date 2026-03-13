/// @description 
/// obj_pickup_trident_reward — User Event 0

with (obj_player)
{
    _unlock_weapon(0);
    // Також знаходимо тризубець у кімнаті
    trident_instance = instance_find(obj_trident, 0);
    if (!instance_exists(trident_instance))
        trident_instance = instance_create_layer(x + 32, y, "Instances", obj_trident);
}
// audio_play_sound(snd_weapon_get, 1, false);
instance_destroy();