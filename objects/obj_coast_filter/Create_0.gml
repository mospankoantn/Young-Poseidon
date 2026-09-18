/// obj_coast_filter — Create Event

// Хвилі тепла (марево)
heat_offset  = 0;
heat_speed   = 0.012;
heat_count   = 8;
 
// Туман на горизонті
fog_alpha    = 0;
fog_target   = 0.18;
 
// Пил
dust_count = 20;
dust_x     = array_create(dust_count);
dust_y     = array_create(dust_count);
dust_spd   = array_create(dust_count);
dust_phase = array_create(dust_count);
dust_size  = array_create(dust_count);
 
for (var _i = 0; _i < dust_count; _i++)
{
    dust_x[_i]     = random(1920);
    dust_y[_i]     = random(1080);
    dust_spd[_i]   = random_range(0.3, 1.2);
    dust_phase[_i] = random(pi * 2);
    dust_size[_i]  = random_range(1, 3);
}
 
// Сонячний відблиск
sun_pulse = 0;