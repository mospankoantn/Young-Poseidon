/// @description Ініціалізація тризубця при переході до нової кімнати
// obj_player Room Start Event

// Шукаємо тризубець у кімнаті
trident_instance = instance_find(obj_trident, 0);
 
// Якщо немає — створюємо поруч із гравцем
if (!instance_exists(trident_instance))
{
    trident_instance = instance_create_layer(x + 32, y, "Instances", obj_trident);
}

if (!apply_pending_load_to_player())
    apply_pending_checkpoint_respawn_to_player();
_reset_player_animation();
