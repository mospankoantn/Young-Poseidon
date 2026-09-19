/// @description Event Нагорода після Урана (Небо → Шахти)
// obj_pickup_pickaxe_reward — Create

event_inherited();
if (world_state_bind(id, world_state_reward_key("uranus"), "pickup")) exit;
weapon_index = 2;       // Кайло
weapon_label = "Кайло";
image_blend = c_white;
