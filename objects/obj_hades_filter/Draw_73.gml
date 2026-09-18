/// obj_hades_filter — Draw End Event

var _vx = camera_get_view_x(view_camera[0]);
var _vy = camera_get_view_y(view_camera[0]);
var _vw = camera_get_view_width(view_camera[0]);
var _vh = camera_get_view_height(view_camera[0]);
 
fog_offset    += fog_speed;
shadow_offset += 0.007;
pulse_offset  += 0.02;
 
// ── 1. БАЗОВИЙ КОЛІР АЇДА ──
// Темно-фіолетово-зелений — колір смерті і болота
for (var _si = 0; _si < 16; _si++)
{
    var _t  = _si / 15.0;
    var _t2 = _t * _t;
    var _r  = lerp(5,   15,  _t2);
    var _g  = lerp(20,  35,  _t2);
    var _b  = lerp(25,  15,  _t2);
    var _a  = lerp(0.05, 0.45, _t2);
    draw_set_alpha(_a);
    draw_set_color(make_color_rgb(_r, _g, _b));
    draw_rectangle(_vx, _vy + _si * (_vh/16.0),
                   _vx + _vw, _vy + (_si+1)*(_vh/16.0), false);
}
draw_set_alpha(1);
 
// ── 2. ЗЕЛЕНИЙ ТУМАН БІЛЯ ЗЕМЛІ ──
var _fog_base = _vy + _vh * 0.65;
for (var _fi = 0; _fi < 12; _fi++)
{
    var _ft     = _fi / 11.0;
    var _fshift = sin(fog_offset + _fi * 0.6) * 15;
    var _fa     = (0.08 + sin(fog_offset * 0.7 + _fi) * 0.03) * (1 - _ft * 0.6);
 
    draw_set_alpha(_fa);
    draw_set_color(make_color_rgb(20, 80, 40));
    draw_rectangle(_vx, _fog_base + _fi * 8 + _fshift,
                   _vx + _vw, _fog_base + (_fi+1) * 8 + _fshift + 12, false);
}
draw_set_alpha(1);
 
// ── 3. ФІОЛЕТОВИЙ ТУМАН ВГОРІ ──
for (var _fi = 0; _fi < 8; _fi++)
{
    var _ft  = _fi / 7.0;
    var _fa  = 0.06 * (1 - _ft) * (0.7 + sin(fog_offset * 1.3 + _fi) * 0.3);
    draw_set_alpha(_fa);
    draw_set_color(make_color_rgb(60, 10, 80));
    draw_rectangle(_vx, _vy + _fi * (_vh * 0.05),
                   _vx + _vw, _vy + (_fi+1) * (_vh * 0.05), false);
}
draw_set_alpha(1);
 
// ── 4. ВОГНИКИ МЕРТВИХ ──
for (var _wi = 0; _wi < wisp_count; _wi++)
{
    wisp_x[@ _wi]     += wisp_spd[_wi] * sin(wisp_phase[_wi] * 0.3) * 0.5;
    wisp_y[@ _wi]     += wisp_spd[_wi] * cos(wisp_phase[_wi] * 0.4) * 0.3;
    wisp_phase[@ _wi] += 0.03;
 
    if (wisp_x[_wi] < 0)    wisp_x[@ _wi] = _vw;
    if (wisp_x[_wi] > _vw)  wisp_x[@ _wi] = 0;
    if (wisp_y[_wi] < 0)    wisp_y[@ _wi] = _vh;
    if (wisp_y[_wi] > _vh)  wisp_y[@ _wi] = 0;
 
    var _wa = 0.3 + sin(wisp_phase[_wi] * 2.1) * 0.15;
 
    // Зовнішнє сяяння
    draw_set_alpha(_wa * 0.12);
    draw_set_color(make_color_rgb(80, 255, 120));
    draw_circle(_vx + wisp_x[_wi], _vy + wisp_y[_wi], 18, false);
 
    // Ядро вогника
    draw_set_alpha(_wa * 0.6);
    draw_set_color(make_color_rgb(160, 255, 180));
    draw_circle(_vx + wisp_x[_wi], _vy + wisp_y[_wi], 4, false);
}
draw_set_alpha(1);
 
// ── 5. ПУЛЬСАЦІЯ ТЕМРЯВИ ──
// Аїд "дихає" — темрява то наступає то відступає
var _pulse_a = 0.08 + sin(pulse_offset) * 0.04;
draw_set_alpha(_pulse_a);
draw_set_color(make_color_rgb(0, 0, 10));
draw_rectangle(_vx, _vy, _vx + _vw, _vy + _vh, false);
draw_set_alpha(1);
 
// ── 6. КУТИ ──
for (var _ci = 0; _ci < 10; _ci++)
{
    var _cp = 1 - _ci / 10.0;
    var _cw = 80 * _cp;
    draw_set_alpha(0.02 * _cp * _cp);
    draw_set_color(make_color_rgb(0, 5, 0));
    draw_rectangle(_vx,             _vy, _vx + _cw,     _vy + _vh, false);
    draw_rectangle(_vx + _vw - _cw, _vy, _vx + _vw,     _vy + _vh, false);
    draw_rectangle(_vx, _vy + _vh - _cw, _vx + _vw, _vy + _vh,    false);
}
draw_set_alpha(1);
draw_set_color(c_white);