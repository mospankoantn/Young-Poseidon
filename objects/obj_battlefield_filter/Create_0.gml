/// obj_battlefield_filter — Create Event
/// Атмосфера поля битви: дим, попіл, жар і далекі пожежі.

fx_time = 0;

// Попіл — координати зберігаються нормалізовано (0..1), щоб ефект
// коректно працював при будь-якому розмірі камери.
ash_count = 44;
ash_x     = array_create(ash_count);
ash_y     = array_create(ash_count);
ash_spd   = array_create(ash_count);
ash_phase = array_create(ash_count);
ash_size  = array_create(ash_count);
for (var _i = 0; _i < ash_count; _i++)
{
    ash_x[_i]     = random(1);
    ash_y[_i]     = random(1);
    ash_spd[_i]   = random_range(0.035, 0.11);
    ash_phase[_i] = random(pi * 2);
    ash_size[_i]  = random_range(0.8, 2.4);
}

// Жарини піднімаються над нижньою частиною кадру.
ember_count = 14;
ember_x     = array_create(ember_count);
ember_y     = array_create(ember_count);
ember_spd   = array_create(ember_count);
ember_phase = array_create(ember_count);
ember_size  = array_create(ember_count);
for (var _e = 0; _e < ember_count; _e++)
{
    ember_x[_e]     = random(1);
    ember_y[_e]     = random_range(0.58, 1.0);
    ember_spd[_e]   = random_range(0.045, 0.13);
    ember_phase[_e] = random(pi * 2);
    ember_size[_e]  = random_range(0.8, 1.8);
}
