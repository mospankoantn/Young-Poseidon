/// @description
/// obj_trident Create Event
/// Shared projectile object used by BOTH throwable weapons. visual_weapon:
/// 0 = trident, 1 = spear. Each weapon owns a separate instance.

damage = 1;
fly_speed = 12;
flight_duration = room_speed * 2;

thrown = false;
stuck = false;
invisible_time = false;
timer = 0;

friction = 0;
gravity = 0;

visual_weapon = 0;
owner_player = noone;
platform_instance = noone;
