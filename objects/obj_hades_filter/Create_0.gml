/// obj_hades_filter — Create Event
/// Аїд: зелено-фіолетовий туман, душі, блуждаючі вогні та "дихання" темряви.

fx_time = 0;

wisp_count = 10;
wisp_x     = array_create(wisp_count);
wisp_y     = array_create(wisp_count);
wisp_phase = array_create(wisp_count);
wisp_spd   = array_create(wisp_count);
wisp_size  = array_create(wisp_count);
for (var _i = 0; _i < wisp_count; _i++)
{
    wisp_x[_i]     = random(1);
    wisp_y[_i]     = random(1);
    wisp_phase[_i] = random(pi * 2);
    wisp_spd[_i]   = random_range(0.008, 0.022);
    wisp_size[_i]  = random_range(2.0, 4.5);
}

soul_count = 20;
soul_x     = array_create(soul_count);
soul_y     = array_create(soul_count);
soul_phase = array_create(soul_count);
soul_spd   = array_create(soul_count);
for (var _s = 0; _s < soul_count; _s++)
{
    soul_x[_s]     = random(1);
    soul_y[_s]     = random(1);
    soul_phase[_s] = random(pi * 2);
    soul_spd[_s]   = random_range(0.010, 0.030);
}
