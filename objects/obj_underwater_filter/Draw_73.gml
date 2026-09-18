/// @description obj_underwater_filter — Draw End Event

// ════ КООРДИНАТИ КАМЕРИ (Draw End = світовий простір) ════
var _vx = camera_get_view_x(view_camera[0]);
var _vy = camera_get_view_y(view_camera[0]);
var _vw = camera_get_view_width(view_camera[0]);
var _vh = camera_get_view_height(view_camera[0]);

var _w_h    = wave_height;
var _surf_y = _vy + _w_h;
var _w_step = 8; 

// ════════════════════════════════════
// 1. ГРАДІЄНТ ГЛИБИНИ
// Верх: ясний бірюзовий → Середина: насичений синій → Низ: темно-зелений
// ════════════════════════════════════
var _strip_count = 24;
var _strip_h     = _vh / _strip_count;

for (var _si = 0; _si < _strip_count; _si++)
{
    var _t = _si / (_strip_count - 1);
    var _t3 = _t * _t * _t;   // Кубічна крива — РІЗКЕ потемніння знизу

	var _r = lerp(15,  0,   _t3);
	var _g = lerp(100, 35,  _t3);
	var _b = lerp(195, 85,  _t3);
	var _a = lerp(0.06, 0.65, _t3);   // Було 0.45, стало 0.65

    draw_set_alpha(_a);
    draw_set_color(make_color_rgb(_r, _g, _b));
    draw_rectangle(
        _vx,
        _vy + _si * _strip_h,
        _vx + _vw,
        _vy + (_si + 1) * _strip_h,
        false
    );
}
draw_set_alpha(1);


// ════════════════════════════════════
// 2. ПРОМЕНІ СВІТЛА
// Тільки у верхній половині — глибше не проникають
// ════════════════════════════════════
for (var _i = 0; _i < ray_count; _i++)
{
    ray_drift[@ _i] += ray_speed[_i] * 0.016;
    var _sway  = sin(ray_drift[_i]) * 28;

    var _top_x = _vx + ray_x[_i] + _sway;
    var _top_w = ray_width[_i] * 0.12;

    // Промінь сягає тільки 65% висоти — далі поглинається водою
    var _ray_bottom = _vy + _vh * 0.65;
    var _bot_x = _vx + ray_x[_i] + _sway * 0.4;
    var _bot_w = ray_width[_i] * 1.4;

    var _pulse = sin(ray_drift[_i] * 1.8 + _i * 0.7) * 0.015;
    var _alpha = clamp(ray_alpha[_i] + _pulse, 0, 0.065);

    // 3 шари для м'яких країв
    for (var _ri = 0; _ri < 3; _ri++)
    {
        var _off    = (_ri - 1) * _top_w * 0.6;
        var _falloff = 1 - abs(_ri - 1) * 0.45;

        draw_set_alpha(_alpha * _falloff);
        draw_set_color(make_color_rgb(150, 220, 255));
        draw_triangle(
            _top_x + _off - _top_w * 0.3, _vy,
            _top_x + _off + _top_w * 0.3, _vy,
            _bot_x + _off * 1.8 + _bot_w, _ray_bottom,
            false
        );
        draw_triangle(
            _top_x + _off - _top_w * 0.3, _vy,
            _bot_x + _off * 1.8 - _bot_w, _ray_bottom,
            _bot_x + _off * 1.8 + _bot_w, _ray_bottom,
            false
        );
    }
}
draw_set_alpha(1);


// ════════════════════════════════════
// 3. ХВИЛЬОВА ПОВЕРХНЯ
// ════════════════════════════════════
// Темна смуга між небом і водою
draw_set_alpha(0.65);
draw_set_color(make_color_rgb(0, 15, 50));
draw_rectangle(_vx, _vy, _vx + _vw, _vy + _w_h * 2.5, false);

// Піна (білі цятки на гребенях)
draw_set_alpha(0.4);
draw_set_color(make_color_rgb(220, 240, 255));
for (var _wx = 0; _wx < _vw; _wx += 18)
{
    var _foam_y = sin(wave_offset * 1.1 + _wx / 50.0) * _w_h * 0.8 + _surf_y;
    var _foam_r = random_range(2, 5);
    draw_circle(_vx + _wx + sin(wave_offset + _wx) * 6, _foam_y, _foam_r, false);
}

// Основна хвиля (товща)
draw_set_alpha(0.8);
draw_set_color(make_color_rgb(40, 140, 215));
for (var _wx = 0; _wx < _vw; _wx += _w_step)
{
    var _y1 = sin(wave_offset + _wx          / 55.0) * _w_h * 0.75 + _surf_y;
    var _y2 = sin(wave_offset + (_wx+_w_step)/ 55.0) * _w_h * 0.75 + _surf_y;
    draw_line_width(_vx + _wx, _y1, _vx + _wx + _w_step, _y2, 3.5);
}

// Друга хвиля (глибша тінь)
draw_set_alpha(0.35);
draw_set_color(make_color_rgb(20, 80, 160));
for (var _wx = 0; _wx < _vw; _wx += _w_step)
{
    var _y1 = sin(wave_offset * 0.8 + _wx          / 70.0) * _w_h * 0.5 + _surf_y + _w_h;
    var _y2 = sin(wave_offset * 0.8 + (_wx+_w_step)/ 70.0) * _w_h * 0.5 + _surf_y + _w_h;
    draw_line_width(_vx + _wx, _y1, _vx + _wx + _w_step, _y2, 2);
}
draw_set_alpha(1);


// ════════════════════════════════════
// 4. КАУСТИКА (тільки нижня третина)
// ════════════════════════════════════
var _caust_top = _vy + _vh * 0.68;

for (var _ci = 0; _ci < 10; _ci++)
{
    var _cx = _vx + (_vw / 10.0) * _ci
              + sin(wave_offset * 0.6 + _ci * 1.4) * 22;
    var _cy = _caust_top
              + cos(wave_offset * 0.45 + _ci * 1.1) * (_vh * 0.08)
              + (_vh * 0.1);
    var _cr  = random_range(10, 28);
    var _ca  = 0.045 + sin(wave_offset * 1.2 + _ci) * 0.025;

    draw_set_alpha(max(0, _ca));
    draw_set_color(make_color_rgb(100, 200, 255));
    draw_ellipse(_cx - _cr, _cy - _cr * 0.35,
                 _cx + _cr, _cy + _cr * 0.35, false);
}
draw_set_alpha(1);


// ════════════════════════════════════
// 5. ПЛАВАЮЧИЙ ПЛАНКТОН
// Дрібні частинки повільно дрейфують
// ════════════════════════════════════
if (!variable_instance_exists(id, "plankton_x"))
{
    plankton_count = 25;
    plankton_x     = array_create(plankton_count);
    plankton_y     = array_create(plankton_count);
    plankton_spd   = array_create(plankton_count);
    plankton_phase = array_create(plankton_count);
    plankton_size  = array_create(plankton_count);

    for (var _pi = 0; _pi < plankton_count; _pi++)
    {
        plankton_x[_pi]     = random(_vw);
        plankton_y[_pi]     = random(_vh);
        plankton_spd[_pi]   = random_range(0.1, 0.4);
        plankton_phase[_pi] = random(pi * 2);
        plankton_size[_pi]  = random_range(1, 3.5);
    }
}

for (var _pi = 0; _pi < plankton_count; _pi++)
{
    plankton_y[@ _pi]     -= plankton_spd[_pi];
    plankton_phase[@ _pi] += 0.025;
    var _px = _vx + plankton_x[_pi] + sin(plankton_phase[_pi]) * 8;
    var _py = _vy + plankton_y[_pi];

    if (plankton_y[_pi] < -10)
    {
        plankton_y[@ _pi] = _vh + 5;
        plankton_x[@ _pi] = random(_vw);
    }

    // Яскравіший вгорі (там більше світла), темніший внизу
    var _depth = plankton_y[_pi] / _vh;
    var _pa    = lerp(0.25, 0.07, _depth);
    var _sz    = plankton_size[_pi];

    draw_set_alpha(_pa);
    draw_set_color(make_color_rgb(180, 230, 255));
    draw_circle(_px, _py, _sz, false);
}
draw_set_alpha(1);


// ════════════════════════════════════
// 6. М'ЯКІ КУТИ (без жорстких рамок)
// ════════════════════════════════════
var _steps = 12;
for (var _ci = 0; _ci < _steps; _ci++)
{
    var _progress = 1 - (_ci / _steps);
    var _ca = 0.018 * _progress * _progress;
    var _cw = 70 * _progress;

    draw_set_alpha(_ca);
    draw_set_color(make_color_rgb(0, 10, 40));
    draw_rectangle(_vx,             _vy, _vx + _cw,      _vy + _vh, false);
    draw_rectangle(_vx + _vw - _cw, _vy, _vx + _vw,      _vy + _vh, false);
    draw_rectangle(_vx, _vy + _vh - _cw, _vx + _vw, _vy + _vh,      false);
}
draw_set_alpha(1);

// Загальний приглушуючий шар — імітує поглинання кольору водою
// Чим глибше, тим більше червоний і жовтий спектр поглинається
draw_set_alpha(0.12);
draw_set_color(make_color_rgb(0, 30, 80));
draw_rectangle(_vx, _vy + _vh * 0.5, _vx + _vw, _vy + _vh, false);

draw_set_alpha(0.08);
draw_set_color(make_color_rgb(0, 15, 50));
draw_rectangle(_vx, _vy + _vh * 0.75, _vx + _vw, _vy + _vh, false);
draw_set_alpha(1);

// ════ СКИДАННЯ ════
draw_set_color(c_white);
draw_set_alpha(1);