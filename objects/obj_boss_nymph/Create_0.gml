/// @description 
/// obj_boss_nymph — Create Event

boss_name_key = "boss_nymph";
max_hp    = 10;
hp        = max_hp;
atk       = 2;
phase     = 1;
 
// ---- ДВІ ТОЧКИ БІГУ ----
left_x    = x - 280;
right_x   = x + 280;
ground_y  = y;         // Висота землі (встановлюється в кімнаті)
move_dir  = 1;         // 1=вправо, -1=вліво
run_speed = 4;
 
// ---- СТАНИ ----
// 0=біжить, 1=зупинилась+заряджає стріли, 2=стріляє, 3=пауза
state      = 0;
stop_timer = 0;        // Таймер зупинки
shoot_cd   = 0;
barrage_count = 0;     // Скільки разів уже вистрілила в поточному залпі
 
// ---- ФІЗИКА (кінь є наземним) ----
vspd = 0;
grv  = 0.8;
 
// ---- ЗАЛП СТРІЛ ----
// Стріли закривають все поле АЛЕ є 2-3 безпечних пропуски
barrage_gap_positions = [];   // Безпечні X-позиції (рандомні)
barrage_arrows_total  = 20;   // Всього стріл у залпі
barrage_gap_width     = 50;   // Ширина безпечного пропуску
 
is_dead = false;
image_speed = 0.12;
anim_attack_sprite = -1;
anim_attack_elapsed = -1;
anim_attack_length = 0;
anim_death_started = false;
anim_death_elapsed = 0;
anim_prev_x = x;
anim_prev_y = y;
