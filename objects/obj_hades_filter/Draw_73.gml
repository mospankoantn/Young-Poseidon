if (view_camera[0] == -1) exit;
/// obj_hades_filter — Draw End Event

var _vx = camera_get_view_x(view_camera[0]);
var _vy = camera_get_view_y(view_camera[0]);
var _vw = camera_get_view_width(view_camera[0]);
var _vh = camera_get_view_height(view_camera[0]);
var _dt = clamp(delta_time * 0.000001, 0, 0.05);
fx_time += _dt;

// 1. Холодний градієнт глибини.
for (var _s = 0; _s < 10; _s++)
{
    var _t = _s / 9.0;
    var _a = lerp(0.045, 0.22, _t * _t);
    draw_set_alpha(yp_fx_alpha(_a));
    draw_set_color(make_color_rgb(lerp(25, 12, _t), lerp(18, 45, _t), lerp(45, 25, _t)));
    draw_rectangle(_vx, _vy + _s * (_vh / 10.0), _vx + _vw, _vy + (_s + 1) * (_vh / 10.0), false);
}

// 2. Болотно-зелений туман біля землі — широкі хвилі з різною фазою.
var _fog_y = _vy + _vh * 0.67;
for (var _f = 0; _f < 8; _f++)
{
    var _cy = _fog_y + _f * (_vh * 0.035) + sin(fx_time * 0.32 + _f * 0.75) * 8;
    var _fa = 0.030 + 0.028 * (1 - _f / 8.0);
    draw_set_alpha(yp_fx_alpha(_fa));
    draw_set_color(make_color_rgb(35, 95, 58));
    draw_ellipse(_vx - 50, _cy - 20, _vx + _vw + 50, _cy + 24, false);
}

// 3. Фіолетовий серпанок угорі.
for (var _f2 = 0; _f2 < 5; _f2++)
{
    var _a2 = 0.022 * (1 - _f2 / 5.0) * (0.75 + 0.25 * sin(fx_time * 0.4 + _f2));
    draw_set_alpha(yp_fx_alpha(_a2));
    draw_set_color(make_color_rgb(80, 25, 105));
    draw_rectangle(_vx, _vy + _f2 * _vh * 0.055, _vx + _vw, _vy + (_f2 + 1) * _vh * 0.070, false);
}

// 4. Блуждаючі вогні. Additive blend робить їх схожими на справжнє світіння.
gpu_set_blendmode(bm_add);
for (var _w = 0; _w < wisp_count; _w++)
{
    wisp_phase[@ _w] += _dt * (0.9 + _w * 0.025);
    wisp_x[@ _w] += sin(wisp_phase[_w] * 0.7) * wisp_spd[_w] * _dt;
    wisp_y[@ _w] -= (wisp_spd[_w] * 0.38) * _dt;
    if (wisp_y[_w] < -0.04)
    {
        wisp_y[@ _w] = 1.04;
        wisp_x[@ _w] = random(1);
    }
    if (wisp_x[_w] < -0.04) wisp_x[@ _w] = 1.04;
    if (wisp_x[_w] > 1.04)  wisp_x[@ _w] = -0.04;

    var _wx = _vx + wisp_x[_w] * _vw;
    var _wy = _vy + wisp_y[_w] * _vh;
    var _pulse = 0.55 + 0.45 * sin(wisp_phase[_w] * 2.1);
    draw_set_alpha(yp_fx_alpha(0.035 + 0.055 * _pulse));
    draw_set_color(make_color_rgb(80, 255, 145));
    draw_circle(_wx, _wy, 12 + wisp_size[_w] * 2.2, false);
    draw_set_alpha(yp_fx_alpha(0.24 + 0.22 * _pulse));
    draw_set_color(make_color_rgb(175, 255, 200));
    draw_circle(_wx, _wy, wisp_size[_w], false);
}

// 5. Маленькі частинки душ підіймаються повільніше за вогники.
for (var _q = 0; _q < soul_count; _q++)
{
    soul_phase[@ _q] += _dt * 0.8;
    soul_y[@ _q] -= soul_spd[_q] * _dt;
    if (soul_y[_q] < -0.02)
    {
        soul_y[@ _q] = 1.02;
        soul_x[@ _q] = random(1);
    }
    var _qx = _vx + (soul_x[_q] + sin(soul_phase[_q]) * 0.010) * _vw;
    var _qy = _vy + soul_y[_q] * _vh;
    draw_set_alpha(yp_fx_alpha(0.04 + 0.07 * max(0, sin(soul_phase[_q] * 1.7))));
    draw_set_color(make_color_rgb(110, 190, 135));
    draw_circle(_qx, _qy, 1.0, false);
}
gpu_set_blendmode(bm_normal);

// 6. Аїд "дихає": м'яка, повільна пульсація темряви.
var _breath = 0.035 + 0.018 * sin(fx_time * 0.72);
draw_set_alpha(yp_fx_alpha(_breath));
draw_set_color(make_color_rgb(2, 2, 12));
draw_rectangle(_vx, _vy, _vx + _vw, _vy + _vh, false);

// 7. Глибока віньєтка, сильніша знизу.
for (var _v = 0; _v < 8; _v++)
{
    var _p = 1 - _v / 8.0;
    var _w2 = 78 * _p;
    draw_set_alpha(yp_fx_alpha(0.020 * _p * _p));
    draw_set_color(make_color_rgb(0, 7, 4));
    draw_rectangle(_vx, _vy, _vx + _w2, _vy + _vh, false);
    draw_rectangle(_vx + _vw - _w2, _vy, _vx + _vw, _vy + _vh, false);
    draw_rectangle(_vx, _vy + _vh - _w2, _vx + _vw, _vy + _vh, false);
}

gpu_set_blendmode(bm_normal);
draw_set_alpha(1);
draw_set_color(c_white);
