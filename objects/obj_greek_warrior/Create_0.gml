/// @description 
/// obj_greek_warrior — Create Event

// ---- ХАРАКТЕРИСТИКИ ----
hp  = 10;
atk = 10;
spd = 4;    // Швидкість переслідування (sp=3)
 
// ---- ПАТРУЛЬ ----
left_bound   = x - 150;
right_bound  = x + 150;
patrol_spd   = 2;       // Повільніша швидкість патрулювання
move_dir     = 1;
patrol_timer = 0;       // Таймер паузи при розвороті
 
// ---- ВИЯВЛЕННЯ ----
sight_range = 250;      // Широкий зір (воїн пильний)
state       = 0;        // 0=патруль, 1=переслідує, 2=атака
 
// ---- АТАКА ----
attack_range  = 40;
attack_cd     = 0;
attack_cd_max = 45;     // 0.75 секунди
 
// ---- ФІЗИКА ----
vspd = 0;
grv  = 0.5;