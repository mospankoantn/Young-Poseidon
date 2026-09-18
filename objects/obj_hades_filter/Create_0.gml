/// obj_hades_filter — Create Event

// Туман
fog_offset = 0;
fog_speed  = 0.005;
 
// Вогники мертвих (блуждаючі вогні)
wisp_count = 8;
wisp_x     = array_create(wisp_count);
wisp_y     = array_create(wisp_count);
wisp_phase = array_create(wisp_count);
wisp_spd   = array_create(wisp_count);
 
for (var _i = 0; _i < wisp_count; _i++)
{
    wisp_x[_i]     = random(1920);
    wisp_y[_i]     = random(1080);
    wisp_phase[_i] = random(pi * 2);
    wisp_spd[_i]   = random_range(0.2, 0.8);
}
 
// Тіні
shadow_offset = 0;
pulse_offset  = 0;