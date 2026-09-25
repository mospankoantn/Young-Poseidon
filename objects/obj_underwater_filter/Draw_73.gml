if (view_camera[0] == -1) exit;
/// @description obj_underwater_filter — Draw End Event

var _vx = camera_get_view_x(view_camera[0]);
var _vy = camera_get_view_y(view_camera[0]);
var _vw = camera_get_view_width(view_camera[0]);
var _vh = camera_get_view_height(view_camera[0]);
var _dt = clamp(delta_time * 0.000001, 0, 0.05);
fx_time += _dt;

// 1. Градієнт глибини: бірюзовий верх -> холодний темно-синій низ.
for (var _s = 0; _s < 16; _s++)
{
    var _t = _s / 15.0;
    var _deep = _t * _t * _t;
    var _r = lerp(20, 2, _deep);
    var _g = lerp(120, 42, _deep);
    var _b = lerp(205, 105, _deep);
    var _a = lerp(0.035, 0.32, _deep);
    draw_set_alpha(yp_fx_alpha(_a));
    draw_set_color(make_color_rgb(_r, _g, _b));
    draw_rectangle(_vx, _vy + _s * (_vh / 16.0), _vx + _vw, _vy + (_s + 1) * (_vh / 16.0), false);
}

// 2. Промені світла з поверхні. Плавний drift, без випадкового тремтіння кадр-за-кадром.
gpu_set_blendmode(bm_add);
for (var _r_i = 0; _r_i < ray_count; _r_i++)
{
    ray_phase[@ _r_i] += _dt * (0.28 + _r_i * 0.018);
    var _top_x = _vx + (ray_x[_r_i] + sin(ray_phase[_r_i]) * 0.025) * _vw;
    var _bottom_x = _top_x + sin(ray_phase[_r_i] * 0.7) * _vw * 0.08;
    var _top_w = max(3, ray_width[_r_i] * _vw * 0.16);
    var _bot_w = ray_width[_r_i] * _vw;
    var _bottom_y = _vy + _vh * 0.66;
    var _a2 = ray_alpha[_r_i] * (0.75 + 0.25 * sin(ray_phase[_r_i] * 1.7));
    draw_set_alpha(yp_fx_alpha(_a2));
    draw_set_color(make_color_rgb(145, 220, 255));
    draw_triangle(_top_x - _top_w, _vy, _top_x + _top_w, _vy, _bottom_x + _bot_w, _bottom_y, false);
    draw_triangle(_top_x - _top_w, _vy, _bottom_x - _bot_w, _bottom_y, _bottom_x + _bot_w, _bottom_y, false);
}
gpu_set_blendmode(bm_normal);

// 3. Жива поверхня води. Піна тепер детермінована — немає random() у Draw.
var _surface_y = _vy + wave_height + 2;
draw_set_alpha(yp_fx_alpha(0.32));
draw_set_color(make_color_rgb(5, 55, 105));
draw_rectangle(_vx, _vy, _vx + _vw, _vy + wave_height * 2.3, false);

var _step = 8;
for (var _x = 0; _x < _vw; _x += _step)
{
    var _y1 = _surface_y + sin(fx_time * 1.45 + _x / 52.0) * wave_height * 0.58;
    var _y2 = _surface_y + sin(fx_time * 1.45 + (_x + _step) / 52.0) * wave_height * 0.58;
    draw_set_alpha(yp_fx_alpha(0.62));
    draw_set_color(make_color_rgb(75, 170, 225));
    draw_line_width(_vx + _x, _y1, _vx + _x + _step, _y2, 2.5);

    if ((_x div _step) mod 4 == 0)
    {
        var _foam = 1.6 + 1.1 * (0.5 + 0.5 * sin(fx_time * 2.2 + _x * 0.07));
        draw_set_alpha(yp_fx_alpha(0.18 + 0.12 * (0.5 + 0.5 * sin(fx_time * 1.8 + _x))));
        draw_set_color(make_color_rgb(220, 245, 255));
        draw_circle(_vx + _x, _y1 - 1, _foam, false);
    }
}

// 4. Каустика — сталі форми, що пливуть по нижній половині.
gpu_set_blendmode(bm_add);
for (var _c = 0; _c < 11; _c++)
{
    var _cx = _vx + _vw * ((_c + 0.35) / 11.0) + sin(fx_time * 0.52 + _c * 1.3) * 18;
    var _cy = _vy + _vh * (0.62 + 0.025 * (_c mod 5)) + cos(fx_time * 0.37 + _c) * 12;
    var _rw = 10 + (_c mod 4) * 4;
    var _a3 = 0.018 + 0.020 * (0.5 + 0.5 * sin(fx_time * 0.9 + _c));
    draw_set_alpha(yp_fx_alpha(_a3));
    draw_set_color(make_color_rgb(100, 210, 255));
    draw_ellipse(_cx - _rw, _cy - _rw * 0.28, _cx + _rw, _cy + _rw * 0.28, false);
}

// 5. Планктон.
for (var _p = 0; _p < plankton_count; _p++)
{
    plankton_y[@ _p] -= plankton_spd[_p] * _dt;
    plankton_phase[@ _p] += _dt * 1.1;
    if (plankton_y[_p] < -0.02)
    {
        plankton_y[@ _p] = 1.02;
        plankton_x[@ _p] = random(1);
    }
    var _px = _vx + (plankton_x[_p] + sin(plankton_phase[_p]) * 0.006) * _vw;
    var _py = _vy + plankton_y[_p] * _vh;
    var _depth = clamp(plankton_y[_p], 0, 1);
    draw_set_alpha(yp_fx_alpha(lerp(0.12, 0.035, _depth)));
    draw_set_color(make_color_rgb(175, 230, 255));
    draw_circle(_px, _py, plankton_size[_p], false);
}
gpu_set_blendmode(bm_normal);

// 6. Бульбашки — контурні, щоб не перетворюватися на білі кульки.
for (var _b = 0; _b < bubble_count; _b++)
{
    bubble_y[@ _b] -= bubble_spd[_b] * _dt;
    bubble_phase[@ _b] += _dt * 1.9;
    if (bubble_y[_b] < 0.08)
    {
        bubble_y[@ _b] = random_range(0.72, 1.05);
        bubble_x[@ _b] = random(1);
    }
    var _bx = _vx + (bubble_x[_b] + sin(bubble_phase[_b]) * 0.008) * _vw;
    var _by = _vy + bubble_y[_b] * _vh;
    draw_set_alpha(yp_fx_alpha(0.12 + 0.06 * (0.5 + 0.5 * sin(bubble_phase[_b]))));
    draw_set_color(make_color_rgb(185, 235, 255));
    draw_circle(_bx, _by, bubble_size[_b], true);
}

// 7. Поглинання кольору на глибині + м'які краї.
draw_set_alpha(yp_fx_alpha(0.060));
draw_set_color(make_color_rgb(0, 28, 75));
draw_rectangle(_vx, _vy + _vh * 0.58, _vx + _vw, _vy + _vh, false);
draw_set_alpha(yp_fx_alpha(0.045));
draw_set_color(make_color_rgb(0, 16, 48));
draw_rectangle(_vx, _vy + _vh * 0.78, _vx + _vw, _vy + _vh, false);

for (var _v = 0; _v < 7; _v++)
{
    var _p2 = 1 - _v / 7.0;
    var _w2 = 62 * _p2;
    draw_set_alpha(yp_fx_alpha(0.014 * _p2 * _p2));
    draw_set_color(make_color_rgb(0, 18, 48));
    draw_rectangle(_vx, _vy, _vx + _w2, _vy + _vh, false);
    draw_rectangle(_vx + _vw - _w2, _vy, _vx + _vw, _vy + _vh, false);
    draw_rectangle(_vx, _vy + _vh - _w2, _vx + _vw, _vy + _vh, false);
}

gpu_set_blendmode(bm_normal);
draw_set_alpha(1);
draw_set_color(c_white);
