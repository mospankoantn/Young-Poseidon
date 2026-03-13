/// @description 
/// obj_boss_nymph — Create Event

boss_name = "НІМФА";
max_hp    = 50;
hp        = max_hp;
atk       = 6;
phase     = 1;
 
// ---- ТОЧКИ ПАТРУЛЯ ----
var _cx = x; var _cy = y;
point_count = 4;
point_x[0] = _cx - 240;  point_y[0] = _cy - 100;
point_x[1] = _cx + 240;  point_y[1] = _cy - 100;
point_x[2] = _cx + 240;  point_y[2] = _cy + 60;
point_x[3] = _cx - 240;  point_y[3] = _cy + 60;
current_point = 0;
fly_speed     = 2.5;
 
// ---- АТАКИ ----
// Чари уповільнення
charm_cd     = 0;
charm_cd_max = room_speed * 5;
 
// Самолікування (фаза 2)
heal_cd     = 0;
heal_cd_max = room_speed * 6;
heal_amount = 5;
 
// Квіти-снаряди (фаза 2)
flower_cd     = 0;
flower_cd_max = room_speed * 1.5;
 
is_dead = false;
image_speed = 0.08;