if (view_camera[0] == -1) exit;
/// obj_olympus_filter — Draw End Event

var _vx = camera_get_view_x(view_camera[0]);
var _vy = camera_get_view_y(view_camera[0]);
var _vw = camera_get_view_width(view_camera[0]);
var _vh = camera_get_view_height(view_camera[0]);
var _dt = clamp(delta_time * 0.000001, 0, 0.05);
fx_time += _dt;

// 1. Небесний градієнт — золото зверху переходить у холодніший ефір унизу.
for (var _s = 0; _s < 10; _s++)
{
    var _t = _s / 9.0;
    draw_set_alpha(yp_fx_alpha(lerp(0.095, 0.025, _t)));
    draw_set_color(make_color_rgb(lerp(255, 170, _t), lerp(235, 205, _t), lerp(165, 255, _t)));
    draw_rectangle(_vx, _vy + _s * (_vh / 10.0), _vx + _vw, _vy + (_s + 1) * (_vh / 10.0), false);
}

// 2. Ефірні хмари у верхній третині.
for (var _c = 0; _c < 7; _c++)
{
    var _cx = _vx + _vw * ((_c + 0.25) / 7.0) + sin(fx_time * 0.12 + _c * 0.9) * 30;
    var _cy = _vy + _vh * (0.14 + 0.035 * (_c mod 3)) + cos(fx_time * 0.10 + _c) * 11;
    var _rw = _vw * (0.055 + 0.012 * (_c mod 2));
    var _rh = _vh * 0.028;
    for (var _l = 0; _l < 3; _l++)
    {
        var _k = 1 + _l * 0.55;
        draw_set_alpha(yp_fx_alpha(0.035 / _k));
        draw_set_color(make_color_rgb(245, 250, 255));
        draw_ellipse(_cx - _rw * _k, _cy - _rh * _k, _cx + _rw * _k, _cy + _rh * _k, false);
    }
}

// 3. Божественні промені.
gpu_set_blendmode(bm_add);
var _top_x = _vx + _vw * 0.52;
for (var _r = 0; _r < 6; _r++)
{
    var _bottom_x = _vx + _vw * (0.05 + _r * 0.18) + sin(fx_time * 0.16 + _r) * 22;
    draw_set_alpha(yp_fx_alpha(0.016 + 0.007 * sin(fx_time * 0.45 + _r * 0.8)));
    draw_set_color(make_color_rgb(255, 240, 175));
    draw_triangle(_top_x - 6, _vy, _top_x + 6, _vy, _bottom_x + _vw * 0.075, _vy + _vh, false);
    draw_triangle(_top_x - 6, _vy, _bottom_x - _vw * 0.075, _vy + _vh, _bottom_x + _vw * 0.075, _vy + _vh, false);
}

// 4. Золоті іскри богів.
for (var _i = 0; _i < spark_count; _i++)
{
    spark_x[@ _i] += spark_vx[_i] * _dt;
    spark_y[@ _i] += spark_vy[_i] * _dt;
    spark_phase[@ _i] += _dt * (1.0 + _i * 0.006);
    if (spark_y[_i] < -0.03)
    {
        spark_y[@ _i] = 1.03;
        spark_x[@ _i] = random(1);
    }
    if (spark_x[_i] < -0.02) spark_x[@ _i] = 1.02;
    if (spark_x[_i] > 1.02)  spark_x[@ _i] = -0.02;

    var _sx = _vx + spark_x[_i] * _vw;
    var _sy = _vy + spark_y[_i] * _vh;
    var _pulse = max(0, sin(spark_phase[_i] * 1.7));
    draw_set_alpha(yp_fx_alpha(0.05 + 0.22 * _pulse));
    draw_set_color(make_color_rgb(255, 220, 105));
    draw_circle(_sx, _sy, spark_size[_i], false);
    if (_pulse > 0.80)
    {
        draw_set_alpha(yp_fx_alpha((_pulse - 0.80) * 0.35));
        draw_set_color(c_white);
        draw_line(_sx - 3, _sy, _sx + 3, _sy);
        draw_line(_sx, _sy - 3, _sx, _sy + 3);
    }
}

gpu_set_blendmode(bm_normal);

// 5. Повільне загальне боже сяйво.
draw_set_alpha(yp_fx_alpha(0.022 + 0.011 * sin(fx_time * 0.70)));
draw_set_color(make_color_rgb(255, 242, 190));
draw_rectangle(_vx, _vy, _vx + _vw, _vy + _vh, false);

// 6. Холодний ефірний туман у верхній частині.
var _ea = 0.022 + 0.012 * sin(fx_time * 0.42);
draw_set_alpha(yp_fx_alpha(_ea));
draw_set_color(make_color_rgb(195, 220, 255));
draw_rectangle(_vx, _vy, _vx + _vw, _vy + _vh * 0.34, false);

// 7. На Олімпі краї не темніють — вони трохи світяться.
gpu_set_blendmode(bm_add);
for (var _v = 0; _v < 5; _v++)
{
    var _p = 1 - _v / 5.0;
    var _w = 42 * _p;
    draw_set_alpha(yp_fx_alpha(0.006 * _p));
    draw_set_color(make_color_rgb(255, 235, 175));
    draw_rectangle(_vx, _vy, _vx + _w, _vy + _vh, false);
    draw_rectangle(_vx + _vw - _w, _vy, _vx + _vw, _vy + _vh, false);
}

gpu_set_blendmode(bm_normal);
draw_set_alpha(1);
draw_set_color(c_white);
