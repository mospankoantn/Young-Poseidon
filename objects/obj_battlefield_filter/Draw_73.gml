/// obj_battlefield_filter — Draw End Event

var _vx = camera_get_view_x(view_camera[0]);
var _vy = camera_get_view_y(view_camera[0]);
var _vw = camera_get_view_width(view_camera[0]);
var _vh = camera_get_view_height(view_camera[0]);
 
smoke_offset += 0.006;
fire_offset  += fire_speed;
 
// ── 1. КРИВАВИЙ ВІДТІНОК ──
// Поле битви = червоне небо, попіл, смерть
for (var _si = 0; _si < 14; _si++)
{
    var _t  = _si / 13.0;
    var _t2 = _t * _t;
    // Вгорі темно-червоний (небо в диму), внизу коричнево-сірий (земля)
    var _r  = lerp(60, 30,  _t2);
    var _g  = lerp(5,  15,  _t2);
    var _b  = lerp(5,  8,   _t2);
    var _a  = lerp(0.12, 0.30, _t2);
    draw_set_alpha(_a);
    draw_set_color(make_color_rgb(_r, _g, _b));
    draw_rectangle(_vx, _vy + _si * (_vh/14.0),
                   _vx + _vw, _vy + (_si+1)*(_vh/14.0), false);
}
draw_set_alpha(1);
 
// ── 2. ДИМ ──
for (var _smi = 0; _smi < 10; _smi++)
{
    var _smoke_x = _vx + (_vw / 10.0) * _smi
                   + sin(smoke_offset * 0.5 + _smi * 0.9) * 40;
    var _smoke_y = _vy + _vh * 0.1
                   + cos(smoke_offset * 0.3 + _smi * 1.2) * 30;
    var _smoke_r = 60 + _smi * 10;
    var _smoke_a = 0.06 + sin(smoke_offset + _smi) * 0.02;
 
    draw_set_alpha(max(0, _smoke_a));
    draw_set_color(make_color_rgb(30, 25, 20));
    draw_ellipse(_smoke_x - _smoke_r, _smoke_y - _smoke_r * 0.5,
                 _smoke_x + _smoke_r, _smoke_y + _smoke_r * 0.5, false);
}
draw_set_alpha(1);
 
// ── 3. ПОПІЛ ЩО ПАДАЄ ──
for (var _ai = 0; _ai < ash_count; _ai++)
{
    ash_y[@ _ai]     += ash_spd[_ai];
    ash_x[@ _ai]     += sin(ash_phase[_ai]) * 0.5;
    ash_phase[@ _ai] += 0.025;
 
    if (ash_y[_ai] > _vh + 5)
    {
        ash_y[@ _ai] = -5;
        ash_x[@ _ai] = random(_vw);
    }
 
    // Попіл темний, майже чорний
    var _aa = 0.15 + sin(ash_phase[_ai] * 2) * 0.06;
    draw_set_alpha(_aa);
    draw_set_color(make_color_rgb(40, 35, 30));
    draw_circle(_vx + ash_x[_ai], _vy + ash_y[_ai], ash_size[_ai], false);
}
draw_set_alpha(1);
 
// ── 4. СПАЛАХИ ВОГНЮ НА ГОРИЗОНТІ ──
var _fire_y = _vy + _vh * 0.55;
for (var _fi = 0; _fi < 6; _fi++)
{
    var _fx   = _vx + (_vw / 6.0) * _fi + (_vw / 12.0);
    var _fa   = 0.08 + sin(fire_offset * 1.5 + _fi * 1.1) * 0.04
                     + sin(fire_offset * 3.7 + _fi * 0.8) * 0.02;
    var _fh   = 40 + sin(fire_offset * 2.1 + _fi) * 15;
    var _fw   = 30 + sin(fire_offset + _fi * 1.3) * 10;
 
    // Помаранчеве полум'я
    draw_set_alpha(max(0, _fa));
    draw_set_color(make_color_rgb(255, 100, 10));
    draw_ellipse(_fx - _fw, _fire_y - _fh,
                 _fx + _fw, _fire_y, false);
 
    // Жовте ядро
    draw_set_alpha(max(0, _fa * 0.6));
    draw_set_color(make_color_rgb(255, 220, 60));
    draw_ellipse(_fx - _fw * 0.4, _fire_y - _fh * 0.6,
                 _fx + _fw * 0.4, _fire_y, false);
}
draw_set_alpha(1);
 
// ── 5. ЗАГАЛЬНЕ ЧЕРВОНЕ МЕРЕХТІННЯ ──
var _flicker_a = 0.05 + sin(fire_offset * 3.1) * 0.02
                      + sin(fire_offset * 7.3) * 0.01;
draw_set_alpha(max(0, _flicker_a));
draw_set_color(make_color_rgb(180, 20, 0));
draw_rectangle(_vx, _vy, _vx + _vw, _vy + _vh, false);
draw_set_alpha(1);
 
// ── 6. ТЕМНІ КУТИ ──
for (var _ci = 0; _ci < 8; _ci++)
{
    var _cp = 1 - _ci / 8.0;
    var _cw = 90 * _cp;
    draw_set_alpha(0.025 * _cp * _cp);
    draw_set_color(make_color_rgb(10, 0, 0));
    draw_rectangle(_vx,             _vy, _vx + _cw,     _vy + _vh, false);
    draw_rectangle(_vx + _vw - _cw, _vy, _vx + _vw,     _vy + _vh, false);
    draw_rectangle(_vx, _vy + _vh - _cw, _vx + _vw, _vy + _vh,    false);
}
draw_set_alpha(1);
draw_set_color(c_white);