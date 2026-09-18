/// @description 
/// obj_boss_war_ghost — Create Event

boss_name_key = "boss_war_ghost";
max_hp    = 50;
hp        = max_hp;
atk       = 4;
phase     = 1;
 
// ---- 5 ТОЧОК ЗИГЗАГУ (верхня частина кімнати) ----
var _cx = x; var _cy = y;
point_count = 5;
point_x[0] = _cx - 300;  point_y[0] = _cy - 150;
point_x[1] = _cx - 100;  point_y[1] = _cy - 80;
point_x[2] = _cx;        point_y[2] = _cy - 160;
point_x[3] = _cx + 100;  point_y[3] = _cy - 80;
point_x[4] = _cx + 300;  point_y[4] = _cy - 150;
current_point = 0;
fly_speed     = 4;
 
// ---- ПІДЙОМ ДУХІВ ----
summon_wave    = 0;         // Номер хвилі
spirits_alive  = 0;        // Скільки духів зараз живе
is_vulnerable  = false;    // Чи вразливий бос
summon_cd      = 0;
summon_cd_max  = room_speed * 1;   // Затримка перед підйомом
 
// ---- СТАНИ ----
// 0=зигзаг+вразлив, 1=очікує поки духи живуть, 2=спустився+вразливий
state     = 1;   // Починаємо з підйому першої хвилі
action_cd = room_speed * 2;
 
// ---- АТАКА ВНИЗУ ----
melee_range  = 60;
melee_cd     = 0;
melee_cd_max = room_speed;
 
// ---- ПОЗИЦІЯ КІСТОК (звідки підіймаються духи) ----
// obj_bone_pile розміщений в кімнаті внизу
bone_pile_x = x;   // Встановити в кімнаті
 
image_alpha = 0.85;
is_dead     = false;
image_speed = 0.1;
anim_attack_sprite = -1;
anim_attack_elapsed = -1;
anim_attack_length = 0;
anim_death_started = false;
anim_death_elapsed = 0;
anim_prev_x = x;
anim_prev_y = y;
