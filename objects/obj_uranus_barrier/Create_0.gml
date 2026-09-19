/// @description Завал між Ураном і гравцем
/// obj_uranus_barrier — Create Event

hp          = 3;    // 3 удари кайлом до руйнування
image_index = 0;    // 0=цілий, 1=тріснутий, 2=сильно тріснутий
image_speed = 0;
hit_flash   = 0;
if (world_state_restore_instance(id, "destroyed")) exit;
