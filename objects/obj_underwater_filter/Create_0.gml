/// @description obj_underwater_filter — Create Event
/// Підводна атмосфера: глибина, промені, поверхня, каустика, планктон і бульбашки.

fx_time = 0;
wave_height = 14;

ray_count = 6;
ray_x     = array_create(ray_count);
ray_width = array_create(ray_count);
ray_phase = array_create(ray_count);
ray_alpha = array_create(ray_count);
for (var _i = 0; _i < ray_count; _i++)
{
    ray_x[_i]     = random(1);
    ray_width[_i] = random_range(0.035, 0.085);
    ray_phase[_i] = random(pi * 2);
    ray_alpha[_i] = random_range(0.018, 0.045);
}

plankton_count = 30;
plankton_x     = array_create(plankton_count);
plankton_y     = array_create(plankton_count);
plankton_spd   = array_create(plankton_count);
plankton_phase = array_create(plankton_count);
plankton_size  = array_create(plankton_count);
for (var _p = 0; _p < plankton_count; _p++)
{
    plankton_x[_p]     = random(1);
    plankton_y[_p]     = random(1);
    plankton_spd[_p]   = random_range(0.008, 0.026);
    plankton_phase[_p] = random(pi * 2);
    plankton_size[_p]  = random_range(0.6, 1.7);
}

bubble_count = 14;
bubble_x     = array_create(bubble_count);
bubble_y     = array_create(bubble_count);
bubble_spd   = array_create(bubble_count);
bubble_phase = array_create(bubble_count);
bubble_size  = array_create(bubble_count);
for (var _b = 0; _b < bubble_count; _b++)
{
    bubble_x[_b]     = random(1);
    bubble_y[_b]     = random_range(0.18, 1.0);
    bubble_spd[_b]   = random_range(0.018, 0.060);
    bubble_phase[_b] = random(pi * 2);
    bubble_size[_b]  = random_range(1.8, 4.5);
}
