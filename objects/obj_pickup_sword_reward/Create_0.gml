/// @description Нагорода після Мінотавра (Лабіринт)
// obj_pickup_sword_reward — Create Event

event_inherited();
if (world_state_bind(id, world_state_reward_key("war_ghost"), "pickup")) exit;
weapon_index = 5;       // Меч (індекс 5!)
weapon_label = "Меч";
image_blend = c_white;
