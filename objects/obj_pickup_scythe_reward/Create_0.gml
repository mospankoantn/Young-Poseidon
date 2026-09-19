/// @description Нагорода після Привида Війни (Поле Битви)
// obj_pickup_scythe_reward — Create Event

event_inherited();
if (world_state_bind(id, world_state_reward_key("charon"), "pickup")) exit;
weapon_index = 3;       // Коса (індекс 3!)
weapon_label = "Коса";
image_blend = c_white;
