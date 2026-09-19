/// @description Event Нагорода після Німфи (Узбережжя)
// obj_pickup_spear_reward — Create

event_inherited();
if (world_state_bind(id, world_state_reward_key("nymph"), "pickup")) exit;
weapon_index = 1;       // Спис
weapon_label = "Спис";
image_blend = c_white;
