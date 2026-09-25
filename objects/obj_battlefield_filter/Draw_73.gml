if (view_camera[0] == -1) exit;
/// obj_battlefield_filter — Draw End Event

var _vx = camera_get_view_x(view_camera[0]);
var _vy = camera_get_view_y(view_camera[0]);
var _vw = camera_get_view_width(view_camera[0]);
var _vh = camera_get_view_height(view_camera[0]);
var _dt = clamp(delta_time * 0.000001, 0, 0.05);
fx_time += _dt;

// 1. Брудно-червоне повітря: сильніше біля землі, але без втрати читабельності.
for (var _si = 0; _si < 10; _si++)
{
    var _t = _si / 9.0;
    var _a = lerp(0.05, 0.20, _t * _t);
    draw_set_alpha(yp_fx_alpha(_a));
    draw_set_color(make_color_rgb(lerp(70, 45, _t), lerp(12, 18, _t), lerp(8, 10, _t)));
    draw_rectangle(_vx, _vy + _si * (_vh / 10.0), _vx + _vw, _vy + (_si + 1) * (_vh / 10.0), false);
}

// 2. Далекі банки диму. Кілька напівпрозорих еліпсів дають м'які краї.
for (var _s = 0; _s < 7; _s++)
{
    var _cx = _vx + _vw * ((_s + 0.35) / 7.0) + sin(fx_time * 0.18 + _s * 1.7) * 34;
    var _cy = _vy + _vh * (0.20 + 0.05 * (_s mod 3)) + cos(fx_time * 0.12 + _s) * 16;
    var _rw = _vw * (0.10 + 0.018 * (_s mod 4));
    var _rh = _vh * (0.045 + 0.012 * (_s mod 3));
    for (var _l = 0; _l < 3; _l++)
    {
        var _k = 1 + _l * 0.45;
        draw_set_alpha(yp_fx_alpha(0.055 / _k));
        draw_set_color(make_color_rgb(30, 27, 24));
        draw_ellipse(_cx - _rw * _k, _cy - _rh * _k, _cx + _rw * _k, _cy + _rh * _k, false);
    }
}

// 3. Попіл. Є легкий боковий вітер, тому частинки не падають вертикальними смугами.
for (var _a_i = 0; _a_i < ash_count; _a_i++)
{
    ash_y[@ _a_i] += ash_spd[_a_i] * _dt;
    ash_phase[@ _a_i] += _dt * 1.7;
    ash_x[@ _a_i] += sin(ash_phase[_a_i]) * _dt * 0.012;

    if (ash_y[_a_i] > 1.03)
    {
        ash_y[@ _a_i] = -0.03;
        ash_x[@ _a_i] = random(1);
    }
    if (ash_x[_a_i] < -0.03) ash_x[@ _a_i] = 1.03;
    if (ash_x[_a_i] > 1.03)  ash_x[@ _a_i] = -0.03;

    var _px = _vx + ash_x[_a_i] * _vw;
    var _py = _vy + ash_y[_a_i] * _vh;
    var _pulse = 0.65 + 0.35 * sin(ash_phase[_a_i] * 2.3);
    draw_set_alpha(yp_fx_alpha(0.10 + 0.10 * _pulse));
    draw_set_color(make_color_rgb(65, 58, 50));
    draw_circle(_px, _py, ash_size[_a_i], false);
}

// 4. Далекі пожежі + жарини. Additive blend дає світіння, після чого режим ОБОВ'ЯЗКОВО скидається.
gpu_set_blendmode(bm_add);
var _fire_y = _vy + _vh * 0.69;
for (var _f = 0; _f < 5; _f++)
{
    var _fx = _vx + _vw * ((_f + 0.5) / 5.0);
    var _pulse_f = 0.55 + 0.45 * sin(fx_time * (2.6 + _f * 0.17) + _f * 1.4);
    var _fw = _vw * (0.025 + 0.006 * (_f mod 2));
    var _fh = _vh * (0.045 + 0.015 * _pulse_f);
    draw_set_alpha(yp_fx_alpha(0.025 + 0.035 * _pulse_f));
    draw_set_color(make_color_rgb(255, 85, 12));
    draw_ellipse(_fx - _fw, _fire_y - _fh, _fx + _fw, _fire_y + _fh * 0.25, false);
}

for (var _e_i = 0; _e_i < ember_count; _e_i++)
{
    ember_y[@ _e_i] -= ember_spd[_e_i] * _dt;
    ember_phase[@ _e_i] += _dt * 2.2;
    ember_x[@ _e_i] += sin(ember_phase[_e_i]) * _dt * 0.018;
    if (ember_y[_e_i] < 0.50)
    {
        ember_y[@ _e_i] = random_range(0.82, 1.03);
        ember_x[@ _e_i] = random(1);
    }

    var _ex = _vx + ember_x[_e_i] * _vw;
    var _ey = _vy + ember_y[_e_i] * _vh;
    var _ea = 0.18 + 0.22 * (0.5 + 0.5 * sin(ember_phase[_e_i] * 3));
    draw_set_alpha(yp_fx_alpha(_ea));
    draw_set_color(make_color_rgb(255, 140, 35));
    draw_circle(_ex, _ey, ember_size[_e_i], false);
}
gpu_set_blendmode(bm_normal);

// 5. Дуже слабке червоне "дихання" сцени.
var _flicker = 0.018 + 0.010 * sin(fx_time * 2.2) + 0.005 * sin(fx_time * 6.7);
draw_set_alpha(yp_fx_alpha(max(0, _flicker)));
draw_set_color(make_color_rgb(170, 25, 5));
draw_rectangle(_vx, _vy, _vx + _vw, _vy + _vh, false);

// 6. М'яка віньєтка по краях — не перекриває HUD, бо це Draw End у світовому просторі.
for (var _v = 0; _v < 7; _v++)
{
    var _p = 1 - _v / 7.0;
    var _w = 72 * _p;
    draw_set_alpha(yp_fx_alpha(0.022 * _p * _p));
    draw_set_color(make_color_rgb(8, 2, 2));
    draw_rectangle(_vx, _vy, _vx + _w, _vy + _vh, false);
    draw_rectangle(_vx + _vw - _w, _vy, _vx + _vw, _vy + _vh, false);
    draw_rectangle(_vx, _vy + _vh - _w, _vx + _vw, _vy + _vh, false);
}

// Reset draw state.
gpu_set_blendmode(bm_normal);
draw_set_alpha(1);
draw_set_color(c_white);
