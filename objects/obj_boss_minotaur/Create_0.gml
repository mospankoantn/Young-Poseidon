/// @description 
///  obj_boss_minotaur — Create Event

boss_name = "МІНОТАВР";
max_hp    = 50;
hp        = max_hp;
atk       = 15;
phase     = 1;
 
// ---- ТОЧКИ (Мінотавр СТРИБАЄ між ними, не літає) ----
var _cx = x; var _cy = y;
point_count = 4;
point_x[0] = _cx - 50;  point_y[0] = _cy;
point_x[1] = _cx - 80;   point_y[1] = _cy;
point_x[2] = _cx + 80;   point_y[2] = _cy;
point_x[3] = _cx + 50;  point_y[3] = _cy;
current_point = 0;
 
// ---- ФІЗИКА (Мінотавр — наземний, але стрибає) ----
vspd       = 0;
grv        = 0.8;
is_jumping = false;
 
// ---- АТАКИ ----
// Удар кулаком при посадці — хвиля ударна
slam_range  = 100;     // Радіус удару при посадці
slam_cd     = 0;
slam_cd_max = room_speed;
 
// Заряд (фаза 2)
charge_cd     = 0;
charge_cd_max = room_speed * 2;
is_charging   = false;
charge_spd    = 6;
charge_dir    = 1;
 
// Тупання (фаза 2) — трясе камінь з неба
stomp_cd      = 0;
stomp_cd_max  = room_speed * 6;
 
// ---- СТАН ----
state     = 0;   // 0=на землі, 1=стрибає, 2=заряд
just_landed = false;
 
is_dead = false;
image_speed = 0.1;