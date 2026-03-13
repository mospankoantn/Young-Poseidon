/// @description 
///  obj_fallen_spirit — Create Event

// ---- ХАРАКТЕРИСТИКИ ----
hp  = 15;
atk = 15;
spd = 4;     // Швидкість переслідування
 
// ---- ПАТРУЛЬ ----
left_bound  = x - 160;
right_bound = x + 160;
patrol_spd  = 2;
move_dir    = 1;
 
// ---- ВИЯВЛЕННЯ ----
sight_range  = 350;   // Дух полеглого бачить далеко
melee_range  = 50;    // Відстань для удару мечем
bow_range    = 300;   // Відстань для стрільби з лука
state        = 0;     // 0=патруль, 1=переслідує, 2=атака_лук, 3=атака_меч
 
// ---- АТАКА ----
melee_cd     = 0;
melee_cd_max = 50;
bow_cd       = 0;
bow_cd_max   = room_speed * 2;   // Стріляє раз на 2 секунди
 
// ---- ФІЗИКА ----
vspd = 0;
grv  = 0.5;