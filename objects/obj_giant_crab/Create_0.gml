/// @description 
// obj_giant_crab Create Event

// ---- ХАРАКТЕРИСТИКИ ----
hp  = 1;
atk = 1;
spd = 2;   // пікселів за кадр
 
// ---- ПАТРУЛЬ ----
// Межі патруля: від стартової позиції ±120 пікселів
left_bound  = x - 120;
right_bound = x + 120;
move_dir    = 1;   // 1=вправо, -1=вліво
 
// ---- АТАКА ----
attack_range  = 20;   // Відстань щоб завдати шкоди
attack_cd     = 0;    // Поточний кулдаун
attack_cd_max = 60;   // 1 секунда між атаками (60 кадрів)
 
// ---- ФІЗИКА ----
vspd = 0;
grv  = 0.5;
 
// ---- СТАН ----
state = 0;   // 0=патруль, 3=смерть
anim_attack_sprite = -1;
anim_attack_elapsed = -1;
anim_attack_length = 0;
anim_death_started = false;
anim_death_elapsed = 0;
anim_prev_x = x;
anim_prev_y = y;
