/// @description 
/// obj_boss_triton — Create Event

// ---- МЕТА-ДАНІ ----
boss_name = "ТРИТОН";
max_hp    = 50;
hp        = max_hp;
atk       = 8;
phase     = 1;    // Поточна фаза бою
 
// ---- 4 ТОЧКИ ПАТРУЛЯ (відносно стартової позиції) ----
// Тритон літає між цими 4 точками по черзі
var _cx = x;
var _cy = y;
point_count = 4;
point_x[0] = _cx - 280;  point_y[0] = _cy - 120;   // Ліво-вверх
point_x[1] = _cx + 280;  point_y[1] = _cy - 120;   // Право-вверх
point_x[2] = _cx + 280;  point_y[2] = _cy + 80;    // Право-вниз
point_x[3] = _cx - 280;  point_y[3] = _cy + 80;    // Ліво-вниз
current_point = 0;        // До якої точки летимо зараз
fly_speed     = 3;        // Швидкість переміщення між точками
 
// ---- АТАКИ ----
// Водяна куля
ball_cd     = 0;
ball_cd_max = room_speed * 2;    // Кожні 2 секунди
 
// Хвиля (фаза 2)
wave_cd     = 0;
wave_cd_max = room_speed * 4;
 
// Виклик крабів (фаза 2)
summon_cd     = 0;
summon_cd_max = room_speed * 8;  // Кожні 8 секунд
 
// ---- СТАН ----
state        = 0;   // 0=переміщення, 1=атака
attack_timer = 0;   // Таймер паузи під час атаки
is_dead      = false;
 
// ---- АНІМАЦІЯ ----
image_speed = 0.1;