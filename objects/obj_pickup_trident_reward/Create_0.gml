/// @description Нагорода після Тритона (Море)
// obj_pickup_trident_reward — Create Event

event_inherited();      // Виконуємо Create батька
if (world_state_bind(id, world_state_reward_key("triton"), "pickup")) exit;
weapon_index = 0;       // Тризубець
weapon_label = "Тризубець";
image_blend = c_white;
