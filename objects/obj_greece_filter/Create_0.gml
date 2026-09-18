/// obj_greece_filter — Create Event

// Сонячне світло
sun_offset = 0;
sun_speed  = 0.006;
 
// Хмарні тіні
cloud_count = 4;
cloud_x     = array_create(cloud_count);
cloud_w     = array_create(cloud_count);
cloud_spd   = array_create(cloud_count);
cloud_alpha = array_create(cloud_count);
 
for (var _i = 0; _i < cloud_count; _i++)
{
    cloud_x[_i]     = random(2000) - 200;
    cloud_w[_i]     = random_range(200, 500);
    cloud_spd[_i]   = random_range(0.3, 0.8);
    cloud_alpha[_i] = random_range(0.06, 0.15);
}
 
// Листя на вітрі
leaf_count = 15;
leaf_x     = array_create(leaf_count);
leaf_y     = array_create(leaf_count);
leaf_phase = array_create(leaf_count);
leaf_spd   = array_create(leaf_count);
 
for (var _i = 0; _i < leaf_count; _i++)
{
    leaf_x[_i]     = random(1920);
    leaf_y[_i]     = random(1080);
    leaf_phase[_i] = random(pi * 2);
    leaf_spd[_i]   = random_range(0.4, 1.2);
}