/// @description 
/// obj_boss_uranus — Create Event

boss_name = "УРАН";
max_hp    = 50;
hp        = max_hp;
atk       = 12;
phase     = 1;
 
// ---- ТОЧКИ ПАТРУЛЯ (у верхній частині кімнати) ----
var _cx = x; var _cy = y;
point_count = 4;
point_x[0] = _cx - 300;  point_y[0] = _cy - 150;
point_x[1] = _cx + 300;  point_y[1] = _cy - 150;
point_x[2] = _cx + 300;  point_y[2] = _cy - 60;
point_x[3] = _cx - 300;  point_y[3] = _cy - 60;
current_point = 0;
fly_speed     = 3.5;
 
// ---- АТАКИ ----
// Блискавка падає з неба на гравця
lightning_cd     = 0;
lightning_cd_max = room_speed * 3;
 
// Попередження перед блискавкою (червоне коло)
// Реалізується через obj_proj_lightning з затримкою
 
// Електричне поле (фаза 2) — шкода всім поблизу
field_cd     = 0;
field_cd_max = room_speed * 2;
field_radius = 120;
 
is_dead = false;
image_speed = 0.1;