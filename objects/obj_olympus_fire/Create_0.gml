/// @description 
/// obj_olympus_fire — Create Event

// ---- ХАРАКТЕРИСТИКИ ----
hp  = 5;
atk = 5;
spd = 6;    // Дуже швидкий (sp=5)
 
// ---- ПОВЕДІНКА ----
// Вогонь літає по синусоїді у бік гравця
// Як тільки торкнувся гравця — наносить шкоду і знищується
fly_angle   = random(360);   // Початковий кут синусоїди
base_x      = x;             // Стартова X для синусоїди
wave_amp    = 60;            // Амплітуда хвилеподібного руху
wave_spd    = 0.07;          // Частота хвилі
 
// ---- АТАКА ----
has_attacked = false;        // Чи вже атакував (гине після першої атаки)
attack_range = 28;
 
// ---- ФІЗИКА (немає гравітації — літає) ----
// Вогонь не підпадає під гравітацію
 
// ---- ВІЗУАЛ ----
image_angle = random(360);
image_blend = c_orange;

anim_attack_sprite = -1;
anim_attack_elapsed = -1;
anim_attack_length = 0;
anim_death_started = false;
anim_death_elapsed = 0;
anim_prev_x = x;
anim_prev_y = y;
