/// @description obj_underwater_filter — Create Event

// ── Колір фільтра ──
filter_r = 0;
filter_g = 80;
filter_b = 160;
filter_alpha = 0.18;   // Загальна прозорість синього накладання

// ── Промені світла (каустика) ──
ray_count = 6;
ray_x     = array_create(ray_count);
ray_speed = array_create(ray_count);
ray_width = array_create(ray_count);
ray_alpha = array_create(ray_count);
ray_drift = array_create(ray_count);

for (var _i = 0; _i < ray_count; _i++)
{
    ray_x[_i]     = random(display_get_gui_width());
    ray_speed[_i] = random_range(0.2, 0.6);
    ray_width[_i] = random_range(30, 90);
    ray_alpha[_i] = random_range(0.03, 0.09);
    ray_drift[_i] = random(pi * 2);
}

// ── Хвильовий ефект вгорі ──
wave_offset  = 0;
wave_speed   = 0.015;
wave_count   = 5;      // Кількість хвиль у рядку
wave_height  = 18;     // Висота смуги хвиль

// ── Хроматична аберація (ефект заломлення) ──
aberration_offset = 0;
aberration_speed  = 0.008;