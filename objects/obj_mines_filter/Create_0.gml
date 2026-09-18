/// obj_mines_filter — Create Event

// Смолоскипи (мерехтіння)
torch_flicker   = 0;
torch_speed     = 0.15;
 
// Пил що падає
cave_dust_count = 30;
cave_dust_x     = array_create(cave_dust_count);
cave_dust_y     = array_create(cave_dust_count);
cave_dust_spd   = array_create(cave_dust_count);
cave_dust_alpha = array_create(cave_dust_count);
 
for (var _i = 0; _i < cave_dust_count; _i++)
{
    cave_dust_x[_i]     = random(1920);
    cave_dust_y[_i]     = random(1080);
    cave_dust_spd[_i]   = random_range(0.15, 0.6);
    cave_dust_alpha[_i] = random_range(0.05, 0.2);
}
 
// Радіус видимості навколо гравця
light_radius = 200;
light_pulse  = 0;