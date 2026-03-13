/// @description 
/// obj_boss_charon — Create Event

boss_name = "ХАРОН";
max_hp    = 50;
hp        = max_hp;
atk       = 10;
phase     = 1;
 
// ---- ТОЧКИ ПАТРУЛЯ ----
var _cx = x; var _cy = y;
point_count = 4;
point_x[0] = _cx - 260;  point_y[0] = _cy - 110;
point_x[1] = _cx + 260;  point_y[1] = _cy - 110;
point_x[2] = _cx + 260;  point_y[2] = _cy + 70;
point_x[3] = _cx - 260;  point_y[3] = _cy + 70;
current_point = 0;
fly_speed     = 2.8;
 
// ---- АТАКИ ----
coin_cd      = 0;
coin_cd_max  = room_speed * 2.5;
 
// Монетний дощ (фаза 2) — кидає 8 монет по колу
rain_cd      = 0;
rain_cd_max  = room_speed * 5;
 
// Виклик духів (фаза 2)
summon_cd     = 0;
summon_cd_max = room_speed * 10;
 
is_dead = false;
image_speed = 0.08;