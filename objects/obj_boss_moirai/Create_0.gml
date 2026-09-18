/// @description 
/// obj_boss_moirai — Create Event

boss_name_key = "boss_moirai";
max_hp    = 50;
hp        = max_hp;
// atk = немає (з дизайн-документу "atk = -")
phase     = 1;
 
// ---- 4 ТОЧКИ ПАТРУЛЯ ----
var _cx = x; var _cy = y;
point_count = 4;
point_x[0] = _cx - 200;  point_y[0] = _cy - 100;
point_x[1] = _cx + 200;  point_y[1] = _cy - 100;
point_x[2] = _cx + 200;  point_y[2] = _cy + 60;
point_x[3] = _cx - 200;  point_y[3] = _cy + 60;
current_point = 0;
fly_speed     = 2;
 
// ---- ХВИЛЯ ВІДКИДАННЯ (при отриманні шкоди) ----
last_hp       = max_hp;
wave_knockback = 12;   // Сила відкидання хвилею
wave_cd        = 0;
wave_cd_max    = room_speed * 0.5;  // Не частіше ніж раз на 0.5с
 
// ---- ВИКЛИК ВОГНЮ ----
fire_cd     = 0;
fire_cd_max = room_speed * 1.5;   // Новий вогонь кожні 1.5 секунди
max_fires   = 8;                  // Максимум вогнів одночасно
 
// ---- ДВІ ТІНІ ----
shadow1_point = 1;
shadow2_point = 2;
 
is_dead = false;
image_speed = 0.07;