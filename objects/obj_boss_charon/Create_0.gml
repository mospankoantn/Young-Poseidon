/// @description 
/// obj_boss_charon — Create Event

boss_name_key = "boss_charon";
max_hp    = 100;
hp        = max_hp;
atk       = 3;
phase     = 1;
 
// ---- РУХ ЧОВНОМ ----
// Харон плаває ліво-право по воді
water_left  = x - 350;
water_right = x + 350;
boat_speed  = 3;
move_dir    = 1;
 
// ---- КОСА-БУМЕРАНГ ----
scythe_instance  = noone;  // ID кинутої коси
scythe_cd        = 0;
scythe_cd_max    = room_speed * 3;   // Кидає кожні 3 секунди
scythe_fly_speed = 7;
scythe_damage    = atk;
 
// ---- СТАЛАКТИТИ ----
// obj_stalactite розміщені в кімнаті. У кожного є 4 каміння.
// Гравець б'є кайлом → падає 1 камінь → шкода 10 і боссу і гравцю
// Після 4 каменів сталактит зникає.
 
// ---- ФІЗИКА (човен ковзає по воді) ----
// Вертикального руху немає — човен на рівні води
 
is_dead = false;
image_speed = 0.08;