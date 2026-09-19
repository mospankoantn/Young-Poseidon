/// @description
/// obj_pickup_olympus_key — Create Event

event_inherited();
if (world_state_bind(id, world_state_reward_key("moirai"), "pickup")) exit;
weapon_index = -1;          // Не зброя
weapon_label = "Ключ Олімпу";
is_key       = true;
glow_radius  = 55;
image_blend = c_white;
