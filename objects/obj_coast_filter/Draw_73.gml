/// obj_coast_filter — Draw End Event

var _vx = camera_get_view_x(view_camera[0]);
var _vy = camera_get_view_y(view_camera[0]);
var _vw = camera_get_view_width(view_camera[0]);
var _vh = camera_get_view_height(view_camera[0]);
 
heat_offset += heat_speed;
sun_pulse   += 0.008;
 
// ── 1. ТЕПЛИЙ ЗАГАЛЬНИЙ ВІДТІНОК ──
// Узбережжя = тепле жовтувато-помаранчеве повітря
for (var _si = 0; _si < 12; _si++)
{
    var _t  = _si / 11.0;
    var _t2 = _t * _t;
    // Знизу тепліше (розпечений пісок), вгорі холодніше (небо)
    var _r  = lerp(0,   60,  _t2);
    var _g  = lerp(0,   25,  _t2);
    var _b  = lerp(0,   0,   _t2);
    var _a  = lerp(0.0, 0.14, _t2);
    draw_set_alpha(_a);
    draw_set_color(make_color_rgb(_r, _g, _b));
    draw_rectangle(_vx, _vy + _si * (_vh/12.0),
                   _vx + _vw, _vy + (_si+1) * (_vh/12.0), false);
}
draw_set_alpha(1);
 
// ── 2. ТУМАН НА ГОРИЗОНТІ ──
fog_alpha = lerp(fog_alpha, fog_target, 0.02);
var _fog_y  = _vy + _vh * 0.35;   // Лінія горизонту
var _fog_h  = _vh * 0.25;
 
for (var _fi = 0; _fi < 8; _fi++)
{
    var _ft = _fi / 7.0;
    var _fa = fog_alpha * sin(_ft * pi);   // М'яко зростає і спадає
    draw_set_alpha(_fa);
    draw_set_color(make_color_rgb(220, 230, 240));
    draw_rectangle(_vx, _fog_y + _ft * _fog_h * 0.5,
                   _vx + _vw, _fog_y + (_ft + 0.15) * _fog_h, false);
}
draw_set_alpha(1);
 
// ── 3. МАРЕВО СПЕКИ (горизонтальні хвилі) ──
draw_set_alpha(0.06);
draw_set_color(make_color_rgb(255, 200, 100));
for (var _hi = 0; _hi < heat_count; _hi++)
{
    var _hy     = _vy + _vh * 0.6 + _hi * (_vh * 0.05);
    var _hshift = sin(heat_offset * 1.3 + _hi * 0.8) * 3;
    draw_rectangle(_vx, _hy + _hshift,
                   _vx + _vw, _hy + _hshift + _vh * 0.04, false);
}
draw_set_alpha(1);
 
// ── 4. ПИЛОВІ ЧАСТИНКИ ──
for (var _di = 0; _di < dust_count; _di++)
{
    dust_x[@ _di]     += dust_spd[_di] * 0.8;
    dust_phase[@ _di] += 0.02;
    var _dpx = _vx + dust_x[_di] + sin(dust_phase[_di]) * 5;
    var _dpy = _vy + dust_y[_di]  + cos(dust_phase[_di] * 0.7) * 3;
 
    if (dust_x[_di] > _vw + 10)
    {
        dust_x[@ _di] = -10;
        dust_y[@ _di] = random(_vh);
    }
 
    var _depth_d = dust_y[_di] / _vh;
    var _da      = lerp(0.15, 0.05, _depth_d);
    draw_set_alpha(_da);
    draw_set_color(make_color_rgb(210, 190, 150));
    draw_circle(_dpx, _dpy, dust_size[_di], false);
}
draw_set_alpha(1);
 
// ── 5. СОНЯЧНИЙ ВІДБЛИСК (кут вгорі) ──
var _sun_x = _vx + _vw * 0.85;
var _sun_y = _vy + _vh * 0.08;
var _sun_a = 0.06 + sin(sun_pulse) * 0.02;
 
for (var _sri = 0; _sri < 5; _sri++)
{
    var _sr = 40 + _sri * 25;
    draw_set_alpha(_sun_a * (1 - _sri * 0.18));
    draw_set_color(make_color_rgb(255, 240, 180));
    draw_circle(_sun_x, _sun_y, _sr, false);
}
draw_set_alpha(1);
 
// ── 6. М'ЯКЕ ЗАТЕМНЕННЯ КРАЇВ ──
for (var _ci = 0; _ci < 8; _ci++)
{
    var _cp = 1 - _ci / 8.0;
    draw_set_alpha(0.015 * _cp * _cp);
    draw_set_color(make_color_rgb(20, 10, 0));
    var _cw = 60 * _cp;
    draw_rectangle(_vx,            _vy, _vx + _cw,     _vy + _vh, false);
    draw_rectangle(_vx + _vw - _cw,_vy, _vx + _vw,     _vy + _vh, false);
    draw_rectangle(_vx, _vy + _vh - _cw, _vx + _vw, _vy + _vh,   false);
}
draw_set_alpha(1);
draw_set_color(c_white);