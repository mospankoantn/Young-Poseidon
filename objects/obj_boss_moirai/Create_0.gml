/// @description 
/// obj_boss_moirai — Create Event

boss_name = "МОЙРИ";
max_hp    = 50;
hp        = max_hp;
atk       = 10;
phase     = 1;
 
// ---- ГОЛОВНА ТОЧКА (центр бою) ----
var _cx = x; var _cy = y;
center_x = _cx;
center_y = _cy;
 
// ---- 4 ТОЧКИ ПАТРУЛЯ ----
point_count = 4;
point_x[0] = _cx - 250;  point_y[0] = _cy - 120;
point_x[1] = _cx + 250;  point_y[1] = _cy - 120;
point_x[2] = _cx + 250;  point_y[2] = _cy + 80;
point_x[3] = _cx - 250;  point_y[3] = _cy + 80;
current_point = 0;
fly_speed     = 2.5;
 
// ---- 2 ТІНІ-КЛОНИ (рухаються по тих самих точках зі зсувом) ----
shadow_offset_1 = 1;   // Клон 1 = поточна точка + 1
shadow_offset_2 = 2;   // Клон 2 = поточна точка + 2
// Координати клонів обчислюються в Draw Event
 
// ---- АТАКИ ----
 
// Клото: нитки (уповільнення гравця)
clotho_cd     = 0;
clotho_cd_max = room_speed * 4;
 
// Лахесіс: промінь долі (великий урон, але з попередженням)
lachesis_cd     = 0;
lachesis_cd_max = room_speed * 5;
beam_charging   = false;
beam_charge_t   = 0;
beam_charge_max = room_speed * 2;   // 2 секунди заряджання
 
// Атропос: різання нитки (миттєвий удар що знімає 40% поточного HP)
atropos_cd     = 0;
atropos_cd_max = room_speed * 8;
 
is_dead = false;
image_speed = 0.07;