/// @description
/// obj_room_transition — Create Event

if (instance_number(obj_room_transition) > 1)
{
    instance_destroy();
    exit;
}

target_room  = rm_sea_1;   // Встановлюється при створенні
fade_alpha   = 0;          // Поточна прозорість затемнення
state       = -1;          // 0=затемнення, 1=зміна кімнати, 2=освітлення
fade_speed   = 0.06;
depth        = -9999;      // Поверх всього
