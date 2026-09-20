/// obj_coast_filter — Create Event
/// Узбережжя: тепле повітря, морський серпанок, сіль і сонячні відблиски.

fx_time = 0;

mote_count = 28;
mote_x     = array_create(mote_count);
mote_y     = array_create(mote_count);
mote_spd   = array_create(mote_count);
mote_phase = array_create(mote_count);
mote_size  = array_create(mote_count);
for (var _i = 0; _i < mote_count; _i++)
{
    mote_x[_i]     = random(1);
    mote_y[_i]     = random(1);
    mote_spd[_i]   = random_range(0.018, 0.055);
    mote_phase[_i] = random(pi * 2);
    mote_size[_i]  = random_range(0.7, 1.8);
}

// Короткі блиски солі/водяного пилу.
glint_count = 8;
glint_x     = array_create(glint_count);
glint_y     = array_create(glint_count);
glint_phase = array_create(glint_count);
for (var _g = 0; _g < glint_count; _g++)
{
    glint_x[_g]     = random(1);
    glint_y[_g]     = random_range(0.10, 0.70);
    glint_phase[_g] = random(pi * 2);
}
