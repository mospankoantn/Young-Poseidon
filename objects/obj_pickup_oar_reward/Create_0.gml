/// @description  Event Нагорода після Харона (Аїд — Річка Стікс)
// obj_pickup_oar_reward — Create

event_inherited();
if (world_state_bind(id, world_state_reward_key("minotaur"), "pickup")) exit;
weapon_index = 4;       // Весло (індекс 4!)
weapon_label = "Весло";
image_blend = c_white;
