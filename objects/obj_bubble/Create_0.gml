 /// @description створення бульбашки
 /// obj_bubble — Create Event
 
// ── Розмір ──
var _scale     = random_range(0.3, 1.2);
image_xscale   = _scale;
image_yscale   = _scale;
image_speed    = 0;

// ── Рух ──
rise_speed     = random_range(0.4, 1.5);    // Швидкість підйому
drift_speed    = random_range(-0.3, 0.3);   // Горизонтальне дрейфування
drift_offset   = random(pi * 2);            // Фаза синусоїди дрейфу

// ── Прозорість ──
image_alpha    = random_range(0.3, 0.8);
fade_start_y   = y - random_range(60, 150); // На якій висоті починає зникати

// ── Стан ──
// 0 = піднімається, 1 = лопається
state          = 0;
pop_timer      = 0;
pop_timer_max  = 6;    // Кадрів анімації лопання

// ── Стартова позиція для наступного спауну ──
spawn_x        = x;
spawn_y        = y; 