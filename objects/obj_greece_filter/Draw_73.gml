/// obj_greece_filter — Draw End Event

var _vx = camera_get_view_x(view_camera[0]);
var _vy = camera_get_view_y(view_camera[0]);
var _vw = camera_get_view_width(view_camera[0]);
var _vh = camera_get_view_height(view_camera[0]);
var _dt = clamp(delta_time * 0.000001, 0, 0.05);
fx_time += _dt;

// 1. Чисте золоте повітря — тепле знизу, майже прозоре вгорі.
for (var _s = 0; _s < 8; _s++)
{
    var _t = _s / 7.0;
    draw_set_alpha(0.008 + 0.052 * _t * _t);
    draw_set_color(make_color_rgb(255, 225, 155));
    draw_rectangle(_vx, _vy + _s * (_vh / 8.0), _vx + _vw, _vy + (_s + 1) * (_vh / 8.0), false);
}

// 2. Сонячні промені з верхнього правого кута.
gpu_set_blendmode(bm_add);
var _sx = _vx + _vw * 0.82;
var _sy = _vy - 12;
for (var _r = 0; _r < 5; _r++)
{
    var _bx = _vx + _vw * (0.10 + _r * 0.20) + sin(fx_time * 0.18 + _r) * 22;
    draw_set_alpha(0.018 + 0.006 * sin(fx_time * 0.5 + _r));
    draw_set_color(make_color_rgb(255, 238, 180));
    draw_triangle(_sx - 7, _sy, _sx + 7, _sy, _bx + _vw * 0.10, _vy + _vh, false);
    draw_triangle(_sx - 7, _sy, _bx - _vw * 0.10, _vy + _vh, _bx + _vw * 0.10, _vy + _vh, false);
}
gpu_set_blendmode(bm_normal);

// 3. Повільні хмарні тіні. Нормалізовані координати не залежать від розміру вікна.
for (var _c = 0; _c < cloud_count; _c++)
{
    cloud_x[@ _c] += cloud_spd[_c] * _dt;
    if (cloud_x[_c] > 1.25) cloud_x[@ _c] = -cloud_w[_c] - 0.10;
    var _cx = _vx + cloud_x[_c] * _vw;
    var _cw = cloud_w[_c] * _vw;
    for (var _l = 0; _l < 3; _l++)
    {
        var _expand = _l * 18;
        draw_set_alpha(cloud_alpha[_c] * (1 - _l * 0.28));
        draw_set_color(make_color_rgb(45, 55, 65));
        draw_rectangle(_cx - _expand, _vy, _cx + _cw + _expand, _vy + _vh, false);
    }
}

// 4. Оливкове листя у теплому вітрі.
for (var _i = 0; _i < leaf_count; _i++)
{
    leaf_x[@ _i] += leaf_spd[_i] * _dt;
    leaf_phase[@ _i] += _dt * 2.2;
    leaf_y[@ _i] += sin(leaf_phase[_i]) * _dt * 0.010;
    if (leaf_x[_i] > 1.03)
    {
        leaf_x[@ _i] = -0.03;
        leaf_y[@ _i] = random(1);
    }
    var _lx = _vx + leaf_x[_i] * _vw;
    var _ly = _vy + leaf_y[_i] * _vh;
    var _sz = leaf_size[_i];
    draw_set_alpha(0.11 + 0.07 * (0.5 + 0.5 * sin(leaf_phase[_i])));
    draw_set_color(make_color_rgb(85, 135, 55));
    draw_triangle(_lx, _ly - _sz, _lx - _sz * 0.65, _ly, _lx, _ly + _sz, false);
    draw_triangle(_lx, _ly - _sz, _lx + _sz * 0.65, _ly, _lx, _ly + _sz, false);
}

// 5. Золотий пилок — дуже дрібний, додає життя без шуму.
gpu_set_blendmode(bm_add);
for (var _p = 0; _p < pollen_count; _p++)
{
    pollen_phase[@ _p] += _dt * (0.45 + 0.02 * _p);
    var _px = _vx + (pollen_x[_p] + sin(pollen_phase[_p]) * 0.006) * _vw;
    var _py = _vy + (pollen_y[_p] + cos(pollen_phase[_p] * 0.8) * 0.008) * _vh;
    var _pa = 0.04 + 0.08 * max(0, sin(pollen_phase[_p] * 1.3));
    draw_set_alpha(_pa);
    draw_set_color(make_color_rgb(255, 230, 145));
    draw_circle(_px, _py, 1.0, false);
}
gpu_set_blendmode(bm_normal);

// 6. Ледь помітний сонячний блиск мармуру.
draw_set_alpha(0.018 + 0.010 * sin(fx_time * 0.65));
draw_set_color(make_color_rgb(255, 250, 230));
draw_rectangle(_vx, _vy, _vx + _vw, _vy + _vh, false);

gpu_set_blendmode(bm_normal);
draw_set_alpha(1);
draw_set_color(c_white);
