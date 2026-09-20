/// obj_mines_filter — Create Event
/// Шахти: темрява, тепле світло навколо героя, пил і слабке мерехтіння вогню.

fx_time = 0;
light_radius = 225;

cave_dust_count = 34;
cave_dust_x     = array_create(cave_dust_count);
cave_dust_y     = array_create(cave_dust_count);
cave_dust_spd   = array_create(cave_dust_count);
cave_dust_alpha = array_create(cave_dust_count);
cave_dust_phase = array_create(cave_dust_count);
cave_dust_size  = array_create(cave_dust_count);
for (var _i = 0; _i < cave_dust_count; _i++)
{
    cave_dust_x[_i]     = random(1);
    cave_dust_y[_i]     = random(1);
    cave_dust_spd[_i]   = random_range(0.018, 0.060);
    cave_dust_alpha[_i] = random_range(0.05, 0.16);
    cave_dust_phase[_i] = random(pi * 2);
    cave_dust_size[_i]  = random_range(0.7, 1.6);
}
