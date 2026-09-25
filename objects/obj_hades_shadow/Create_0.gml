/// @description 
/// obj_hades_shadow — Create Event

// ---- ХАРАКТЕРИСТИКИ ----
hp  = 20;
atk = 20;
spd = 1.5;   // Повільна тінь (sp=1 з документу)
 
// ---- ВИЯВЛЕННЯ ----
sight_range  = 220;
scream_range = 180;   // Відстань для крику-заморозки
state        = 0;     // 0=стоїть, 1=переслідує
 
// ---- АТАКА ----
attack_range  = 40;
attack_cd     = 0;
attack_cd_max = 60;
 
scream_cd     = 0;
scream_cd_max = room_speed * 4;  // Крик раз на 4 секунди
 
// ---- ФІЗИКА ----
vspd = 0;
grv  = 0.5;
 
// ---- ВІЗУАЛ ----
image_alpha = 0.7;  // Напівпрозора тінь
anim_attack_sprite = -1;
anim_attack_elapsed = -1;
anim_attack_length = 0;
anim_death_started = false;
anim_death_elapsed = 0;
anim_prev_x = x;
anim_prev_y = y;

enemy_combat_init();
