if (view_camera[0] == -1) exit;
/// obj_coast_filter — Draw End Event

var _vx = camera_get_view_x(view_camera[0]);
var _vy = camera_get_view_y(view_camera[0]);
var _vw = camera_get_view_width(view_camera[0]);
var _vh = camera_get_view_height(view_camera[0]);
var _dt = clamp(delta_time * 0.000001, 0, 0.05);
fx_time += _dt;

// 1. Теплий градієнт: низ нагрітий піском, верх лишається чистішим.
for (var _s = 0; _s < 9; _s++)
{
    var _t = _s / 8.0;
    var _a = 0.015 + 0.075 * _t * _t;
    draw_set_alpha(yp_fx_alpha(_a));
    draw_set_color(make_color_rgb(255, lerp(220, 165, _t), lerp(145, 65, _t)));
    draw_rectangle(_vx, _vy + _s * (_vh / 9.0), _vx + _vw, _vy + (_s + 1) * (_vh / 9.0), false);
}

// 2. Морський серпанок на горизонті — широкі м'які смуги, а не суцільна біла пляма.
var _horizon = _vy + _vh * 0.36;
for (var _h = 0; _h < 6; _h++)
{
    var _p = _h / 5.0;
    var _dy = (_p - 0.5) * _vh * 0.16;
    draw_set_alpha(yp_fx_alpha(0.028 + 0.038 * (1 - abs(_p * 2 - 1))));
    draw_set_color(make_color_rgb(220, 235, 242));
    draw_rectangle(_vx, _horizon + _dy, _vx + _vw, _horizon + _dy + _vh * 0.045, false);
}

// 3. Марево спеки. Воно ледве помітне, щоб платформи залишалися читабельними.
for (var _h2 = 0; _h2 < 6; _h2++)
{
    var _yy = _vy + _vh * (0.66 + _h2 * 0.045) + sin(fx_time * 1.3 + _h2 * 0.9) * 2.0;
    draw_set_alpha(yp_fx_alpha(0.022 + 0.010 * sin(fx_time * 0.9 + _h2)));
    draw_set_color(make_color_rgb(255, 205, 125));
    draw_rectangle(_vx, _yy, _vx + _vw, _yy + max(1, _vh * 0.014), false);
}

// 4. Сіль/пил у морському бризі.
for (var _i = 0; _i < mote_count; _i++)
{
    mote_x[@ _i] += mote_spd[_i] * _dt;
    mote_phase[@ _i] += _dt * 1.8;
    mote_y[@ _i] += sin(mote_phase[_i]) * _dt * 0.007;
    if (mote_x[_i] > 1.02)
    {
        mote_x[@ _i] = -0.02;
        mote_y[@ _i] = random(1);
    }

    var _mx = _vx + mote_x[_i] * _vw;
    var _my = _vy + mote_y[_i] * _vh;
    var _fade = 0.5 + 0.5 * sin(mote_phase[_i] * 1.7);
    draw_set_alpha(yp_fx_alpha(0.04 + 0.09 * _fade));
    draw_set_color(make_color_rgb(235, 225, 195));
    draw_circle(_mx, _my, mote_size[_i], false);
}

// 5. Сонячний bloom + короткі мерехтіння. Additive blend використовується тільки тут.
gpu_set_blendmode(bm_add);
var _sun_x = _vx + _vw * 0.84;
var _sun_y = _vy + _vh * 0.09;
for (var _r = 4; _r >= 1; _r--)
{
    draw_set_alpha(yp_fx_alpha(0.011 * _r));
    draw_set_color(make_color_rgb(255, 238, 175));
    draw_circle(_sun_x, _sun_y, 25 + _r * 24, false);
}
for (var _g = 0; _g < glint_count; _g++)
{
    glint_phase[@ _g] += _dt * (0.7 + _g * 0.04);
    var _pulse = max(0, sin(glint_phase[_g]));
    if (_pulse > 0.72)
    {
        var _gx = _vx + glint_x[_g] * _vw;
        var _gy = _vy + glint_y[_g] * _vh;
        draw_set_alpha(yp_fx_alpha((_pulse - 0.72) * 0.32));
        draw_set_color(make_color_rgb(255, 250, 215));
        draw_line(_gx - 3, _gy, _gx + 3, _gy);
        draw_line(_gx, _gy - 3, _gx, _gy + 3);
    }
}
gpu_set_blendmode(bm_normal);

// 6. Легка віньєтка з теплим низом.
for (var _v = 0; _v < 6; _v++)
{
    var _p2 = 1 - _v / 6.0;
    var _w = 55 * _p2;
    draw_set_alpha(yp_fx_alpha(0.010 * _p2 * _p2));
    draw_set_color(make_color_rgb(35, 20, 8));
    draw_rectangle(_vx, _vy, _vx + _w, _vy + _vh, false);
    draw_rectangle(_vx + _vw - _w, _vy, _vx + _vw, _vy + _vh, false);
    draw_rectangle(_vx, _vy + _vh - _w, _vx + _vw, _vy + _vh, false);
}

gpu_set_blendmode(bm_normal);
draw_set_alpha(1);
draw_set_color(c_white);
