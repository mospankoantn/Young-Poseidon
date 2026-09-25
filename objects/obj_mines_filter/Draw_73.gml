if (view_camera[0] == -1) exit;
/// obj_mines_filter — Draw End Event

var _vx = camera_get_view_x(view_camera[0]);
var _vy = camera_get_view_y(view_camera[0]);
var _vw = camera_get_view_width(view_camera[0]);
var _vh = camera_get_view_height(view_camera[0]);
var _dt = clamp(delta_time * 0.000001, 0, 0.05);
fx_time += _dt;

// 1. Загальна темрява. Трохи слабша за стару версію, щоб деталі тайлів не губилися повністю.
draw_set_alpha(yp_fx_alpha(0.58));
draw_set_color(make_color_rgb(5, 5, 10));
draw_rectangle(_vx, _vy, _vx + _vw, _vy + _vh, false);

// 2. Теплий ореол навколо героя. Additive blend не "вирізає" темряву,
// але повертає локальну яскравість і колір без дорогих surfaces/shaders.
var _player_found = instance_exists(obj_player);
var _px = _vx + _vw * 0.5;
var _py = _vy + _vh * 0.5;
if (_player_found)
{
    _px = obj_player.x;
    _py = obj_player.y;
}
var _radius = light_radius + sin(fx_time * 4.1) * 5 + sin(fx_time * 9.3) * 2.5;

gpu_set_blendmode(bm_add);
for (var _l = 7; _l >= 1; _l--)
{
    var _t = _l / 7.0;
    var _rr = _radius * _t;
    var _aa = 0.010 + (1 - _t) * 0.030;
    draw_set_alpha(yp_fx_alpha(_aa));
    draw_set_color(make_color_rgb(255, lerp(150, 215, 1 - _t), 70));
    draw_circle(_px, _py, _rr, false);
}
// Маленький центр світла.
draw_set_alpha(yp_fx_alpha(0.07 + 0.018 * sin(fx_time * 7.2)));
draw_set_color(make_color_rgb(255, 190, 80));
draw_circle(_px, _py, _radius * 0.28, false);
gpu_set_blendmode(bm_normal);

// 3. Пил. Частинки біля джерела світла помітніші, у темряві майже зникають.
for (var _d = 0; _d < cave_dust_count; _d++)
{
    cave_dust_y[@ _d] += cave_dust_spd[_d] * _dt;
    cave_dust_phase[@ _d] += _dt * 1.3;
    cave_dust_x[@ _d] += sin(cave_dust_phase[_d]) * _dt * 0.003;
    if (cave_dust_y[_d] > 1.02)
    {
        cave_dust_y[@ _d] = -0.02;
        cave_dust_x[@ _d] = random(1);
    }

    var _dxp = _vx + cave_dust_x[_d] * _vw;
    var _dyp = _vy + cave_dust_y[_d] * _vh;
    var _dist = point_distance(_dxp, _dyp, _px, _py);
    var _lit = 1 - clamp(_dist / (_radius * 1.35), 0, 1);
    draw_set_alpha(yp_fx_alpha(cave_dust_alpha[_d] * (0.18 + 0.82 * _lit)));
    draw_set_color(make_color_rgb(185, 160, 110));
    draw_circle(_dxp, _dyp, cave_dust_size[_d], false);
}

// 4. Тепле нерівне мерехтіння від смолоскипів/ламп у просторі шахти.
var _tf = 0.010 + 0.009 * sin(fx_time * 3.6) + 0.004 * sin(fx_time * 9.9);
draw_set_alpha(yp_fx_alpha(max(0, _tf)));
draw_set_color(make_color_rgb(255, 125, 28));
draw_rectangle(_vx, _vy, _vx + _vw, _vy + _vh, false);

// 5. Глибокі краї печери.
for (var _v = 0; _v < 8; _v++)
{
    var _p = 1 - _v / 8.0;
    var _w = 95 * _p;
    var _a = 0.032 * _p * _p;
    draw_set_alpha(yp_fx_alpha(_a));
    draw_set_color(make_color_rgb(0, 0, 5));
    draw_rectangle(_vx, _vy, _vx + _w, _vy + _vh, false);
    draw_rectangle(_vx + _vw - _w, _vy, _vx + _vw, _vy + _vh, false);
    draw_rectangle(_vx, _vy, _vx + _vw, _vy + _w * 0.65, false);
    draw_rectangle(_vx, _vy + _vh - _w * 0.75, _vx + _vw, _vy + _vh, false);
}

gpu_set_blendmode(bm_normal);
draw_set_alpha(1);
draw_set_color(c_white);
