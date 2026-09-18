/// obj_battlefield_filter — Create Event

// Дим
smoke_offset = 0;
 
// Попіл
ash_count = 35;
ash_x     = array_create(ash_count);
ash_y     = array_create(ash_count);
ash_spd   = array_create(ash_count);
ash_phase = array_create(ash_count);
ash_size  = array_create(ash_count);
 
for (var _i = 0; _i < ash_count; _i++)
{
    ash_x[_i]     = random(1920);
    ash_y[_i]     = random(1080);
    ash_spd[_i]   = random_range(0.3, 0.9);
    ash_phase[_i] = random(pi * 2);
    ash_size[_i]  = random_range(1, 4);
}
 
// Спалахи
fire_offset  = 0;
fire_speed   = 0.08;