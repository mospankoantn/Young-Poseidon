/// obj_greece_filter — Create Event
/// Греція: чисте золоте сонце, повільні хмарні тіні, листя і пилок.

fx_time = 0;

cloud_count = 4;
cloud_x     = array_create(cloud_count);
cloud_w     = array_create(cloud_count);
cloud_spd   = array_create(cloud_count);
cloud_alpha = array_create(cloud_count);
for (var _i = 0; _i < cloud_count; _i++)
{
    cloud_x[_i]     = random(1);
    cloud_w[_i]     = random_range(0.16, 0.32);
    cloud_spd[_i]   = random_range(0.008, 0.020);
    cloud_alpha[_i] = random_range(0.018, 0.042);
}

leaf_count = 18;
leaf_x     = array_create(leaf_count);
leaf_y     = array_create(leaf_count);
leaf_phase = array_create(leaf_count);
leaf_spd   = array_create(leaf_count);
leaf_size  = array_create(leaf_count);
for (var _l = 0; _l < leaf_count; _l++)
{
    leaf_x[_l]     = random(1);
    leaf_y[_l]     = random(1);
    leaf_phase[_l] = random(pi * 2);
    leaf_spd[_l]   = random_range(0.012, 0.036);
    leaf_size[_l]  = random_range(2.0, 4.0);
}

pollen_count = 18;
pollen_x     = array_create(pollen_count);
pollen_y     = array_create(pollen_count);
pollen_phase = array_create(pollen_count);
for (var _p = 0; _p < pollen_count; _p++)
{
    pollen_x[_p]     = random(1);
    pollen_y[_p]     = random(1);
    pollen_phase[_p] = random(pi * 2);
}
