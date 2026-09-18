/// @description 
/// obj_boss_uranus — Create Event

boss_name_key = "boss_uranus";
max_hp    = 40;
hp        = max_hp;
atk       = 5;
phase     = 1;
 
// ---- ПОЗИЦІЯ ----
spawn_x = x;   // Стартова X — бос стоїть тут весь бій
 
// ---- ЗАВАЛИ (4 штуки між босом і гравцем) ----
// Завали створюються в кімнаті як obj_uranus_barrier
// Бос знає про них через instance_find
barrier_hp      = [3, 3, 3, 3];   // HP кожного завалу
barrier_current = 0;              // Який завал зараз б'є (0-3)
 
// ---- СТАНИ ----
// 0=стоїть і чекає, 1=б'є завал, 2=застряг (вразливий!),
// 3=атакує гравця кайлом
state      = 0;
action_cd  = 0;
swing_cd   = 0;     // Кулдаун удару кайлом
is_stuck   = false; // Застряг у завалі — вразливий
 
// ---- АТАКА КАЙЛОМ ----
swing_range   = 80;
swing_cd_max  = room_speed * 1.5;
 
// ---- ФІЗИКА ----
vspd = 0;
grv  = 0.6;
 
is_dead = false;
image_speed = 0.1;