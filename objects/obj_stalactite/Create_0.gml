/// @description Сталактит: гравець б'є кайлом → падає каміння → шкода 10
/// obj_stalactite — Create Event

stones_left = 4;      // Скільки каменів може впасти
hit_cd      = 0;      // Кулдаун удару (щоб не спамити)
interact_range = 60;
image_speed = 0;
strike_flash = 0;
if (world_state_restore_instance(id, "destroyed")) exit;
