/// @description  Блискавка Урана: спочатку попередження, потім удар
/// obj_proj_lightning — Create Event

target_x  = x;
target_y  = y;
damage    = 0;
warn_time = room_speed * 1.5;   // Встановлюється при створенні
timer     = 0;
struck    = false;    // Вже вдарила?

hspd     = 0;        // Встановлюється при створенні
vspd     = 0;
damage   = 0;
lifetime = room_speed * 3;
grv      = 0.15;     // Невелика гравітація — куля трохи падає