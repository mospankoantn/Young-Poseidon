/// @description 
/// obj_boss_war_ghost — Create Event

boss_name = "ПРИВИД ВІЙНИ";
max_hp    = 50;
hp        = max_hp;
atk       = 13;
phase     = 1;
 
// ---- ТОЧКИ ПАТРУЛЯ ----
var _cx = x; var _cy = y;
point_count = 4;
point_x[0] = _cx - 270;  point_y[0] = _cy - 130;
point_x[1] = _cx + 270;  point_y[1] = _cy - 130;
point_x[2] = _cx + 270;  point_y[2] = _cy + 70;
point_x[3] = _cx - 270;  point_y[3] = _cy + 70;
current_point = 0;
fly_speed     = 3;
 
// ---- АТАКИ ----
spear_cd     = 0;
spear_cd_max = room_speed * 2.5;
 
// Клич підсилення ворогів (фаза 2)
rally_cd     = 0;
rally_cd_max = room_speed * 7;
rally_radius = 400;     // Всі вороги в цьому радіусі отримують бонус
 
is_dead = false;
image_speed = 0.1;
image_alpha = 0.85;