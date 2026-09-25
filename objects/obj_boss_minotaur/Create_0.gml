/// @description 
/// obj_boss_minotaur — Create Event

boss_name_key = "boss_minotaur";
max_hp    = 60;
hp        = max_hp;
atk       = 2;
contact_damage_enabled = false;
attack_windup = 0;
attack_target_column = noone;
attack_target_x = x;
phase     = 1;
 
// ---- РУХ ----
move_speed = 3;
move_dir   = 1;
vspd = 0;
grv  = 0.6;
 
// ---- АТАКА ПО КОЛОНАХ ----
// obj_minotaur_column розміщені в кімнаті
column_strike_cd     = 0;
column_strike_cd_max = room_speed * 2;
nearest_column       = noone;
 
// ---- ЗВИЧАЙНА АТАКА (якщо гравець на землі) ----
melee_cd     = 0;
melee_cd_max = room_speed * 1.5;
melee_range  = 60;
 
is_dead = false;
image_speed = 0.1;
anim_attack_sprite = -1;
anim_attack_elapsed = -1;
anim_attack_length = 0;
anim_death_started = false;
anim_death_elapsed = 0;
anim_prev_x = x;
anim_prev_y = y;

enemy_combat_init();
