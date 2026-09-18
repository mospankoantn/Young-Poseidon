/// @description 
/// obj_miner_spirit — Create Event

// ---- ХАРАКТЕРИСТИКИ ----
hp  = 5;
atk = 3;
spd = 3.5;   // Швидкість переслідування (sp=2.2 * 10 / 6 ≈ 3.5)
 
// ---- ВИЯВЛЕННЯ ----
sight_range = 200;   // Радіус "зору"
state       = 0;     // 0=стоїть, 1=переслідує
 
// ---- АТАКА ----
attack_range  = 36;
attack_cd     = 0;
attack_cd_max = 50;
 
// ---- ФІЗИКА ----
vspd = 0;
grv  = 0.5;
 
// ---- АНІМАЦІЯ ----
// Дух може бути напівпрозорим
image_alpha = 0.85;
anim_attack_sprite = -1;
anim_attack_elapsed = -1;
anim_attack_length = 0;
anim_death_started = false;
anim_death_elapsed = 0;
anim_prev_x = x;
anim_prev_y = y;
