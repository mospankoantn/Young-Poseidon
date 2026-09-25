/// @description 
///  obj_harpy_seagull — Create Event

// ---- ХАРАКТЕРИСТИКИ ----
hp  = 2;
atk = 2;
spd = 3;   // пікселів за кадр під час пікірування
 
// ---- ПАТРУЛЬ У ПОВІТРІ ----
// Гарпія-чайка літає між двома точками по горизонталі
left_bound  = x - 150;
right_bound = x + 150;
fly_dir     = 1;    // 1=вправо, -1=вліво
base_y      = y;    // Висота на якій літає
fly_spd     = 2;    // Швидкість горизонтального польоту
 
// ---- ПІКІРУВАННЯ ----
// Гарпія зависає над гравцем, потім пікірує
dive_state    = 0;      // 0=летить, 1=зависає над гравцем, 2=пікірує, 3=повертається
hover_timer   = 0;      // Час зависання перед пікіруванням
hover_x       = x;      // X позиція зависання
dive_target_x = x;
dive_target_y = y;
 
// ---- АТАКА ----
attack_range  = 32;
attack_cd     = 0;
attack_cd_max = 90;   // 1.5 секунди між атаками
 
// ---- ВИЯВЛЕННЯ ГРАВЦЯ ----
sight_range = 250;    // Радіус виявлення гравця
anim_attack_sprite = -1;
anim_attack_elapsed = -1;
anim_attack_length = 0;
anim_death_started = false;
anim_death_elapsed = 0;
anim_prev_x = x;
anim_prev_y = y;

enemy_combat_init();
