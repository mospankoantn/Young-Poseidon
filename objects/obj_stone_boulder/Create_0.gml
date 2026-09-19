/// @description 
/// obj_stone_boulder — Create Event

// ---- МІЦНІСТЬ ----
hp           = 3;       // Скільки ударів кайлом потрібно
interact_range = 55;    // Відстань для взаємодії
 
// ---- АНІМАЦІЯ РУЙНУВАННЯ ----
// image_index: 0=ціла, 1=тріснута, 2=сильно тріснута, 3=зруйнована
image_index = 0;
image_speed = 0;
 
// ---- ХИТ-ЕФЕКТ ----
hit_flash   = 0;   // Лічильник спалаху при ударі
hit_cd = 0;
if (world_state_restore_instance(id, "destroyed")) exit;
