/// obj_mines_filter — Draw End Event

var _vx = camera_get_view_x(view_camera[0]);
var _vy = camera_get_view_y(view_camera[0]);
var _vw = camera_get_view_width(view_camera[0]);
var _vh = camera_get_view_height(view_camera[0]);
 
torch_flicker += torch_speed;
light_pulse   += 0.04;
 
// ── 1. ЗАГАЛЬНЕ ЗАТЕМНЕННЯ ПЕЧЕРИ ──
// Шахти дуже темні — базовий шар 75% темряви
draw_set_alpha(0.75);
draw_set_color(make_color_rgb(5, 3, 8));
draw_rectangle(_vx, _vy, _vx + _vw, _vy + _vh, false);
draw_set_alpha(1);
 
// ── 2. КОЛО СВІТЛА НАВКОЛО ГРАВЦЯ ──
if (instance_exists(obj_player))
{
    var _px = obj_player.x;
    var _py = obj_player.y;
 
    // Мерехтіння ліхтаря
    var _flicker_r = light_radius + sin(light_pulse * 3.7) * 8
                     + sin(light_pulse * 7.1) * 4;
 
    // Теплий жовтий відтінок світла — прорізає темряву
    // Малюємо кілька концентричних кіл від прозорого до темного
    var _light_steps = 16;
    for (var _li = _light_steps; _li >= 0; _li--)
    {
        var _lt = _li / _light_steps;
        var _lr = _flicker_r * _lt;
 
        // Центр: теплий жовтий, краї: темно-синій як печера
        var _lc_r = lerp(255, 5,  _lt);
        var _lc_g = lerp(200, 3,  _lt);
        var _lc_b = lerp(80,  8,  _lt);
        var _la   = lerp(0.0, 0.78, _lt * _lt);
 
        draw_set_alpha(_la);
        draw_set_color(make_color_rgb(_lc_r, _lc_g, _lc_b));
        draw_circle(_px, _py, _lr, false);
    }
}
draw_set_alpha(1);
 
// ── 3. ДОДАТКОВИЙ ТЕМНИЙ ШАР НА КРАЯХ ──
// Вигинаємо темряву ще глибше навколо кола світла
for (var _ci = 0; _ci < 10; _ci++)
{
    var _cp = 1 - _ci / 10.0;
    var _ca = 0.06 * _cp * _cp;
    var _cw = 120 * _cp;
    draw_set_alpha(_ca);
    draw_set_color(make_color_rgb(0, 0, 5));
    draw_rectangle(_vx,             _vy, _vx + _cw,      _vy + _vh, false);
    draw_rectangle(_vx + _vw - _cw, _vy, _vx + _vw,      _vy + _vh, false);
    draw_rectangle(_vx, _vy,        _vx + _vw, _vy + 80,            false);
    draw_rectangle(_vx, _vy + _vh - 80, _vx + _vw, _vy + _vh,       false);
}
draw_set_alpha(1);
 
// ── 4. ПИЛ ЩО ПАДАЄ ──
for (var _di = 0; _di < cave_dust_count; _di++)
{
    cave_dust_y[@ _di] += cave_dust_spd[_di];
    if (cave_dust_y[_di] > _vh + 5)
    {
        cave_dust_y[@ _di] = -5;
        cave_dust_x[@ _di] = random(_vw);
    }
    draw_set_alpha(cave_dust_alpha[_di]);
    draw_set_color(make_color_rgb(160, 140, 100));
    draw_circle(_vx + cave_dust_x[_di], _vy + cave_dust_y[_di], 1, false);
}
draw_set_alpha(1);
 
// ── 5. МЕРЕХТІННЯ СМОЛОСКИПІВ ──
// Теплий помаранчевий спалах що пульсує
var _tf_a = 0.04 + sin(torch_flicker * 4.3) * 0.015
                 + sin(torch_flicker * 11.7) * 0.008;
draw_set_alpha(max(0, _tf_a));
draw_set_color(make_color_rgb(255, 140, 30));
draw_rectangle(_vx, _vy, _vx + _vw, _vy + _vh, false);
draw_set_alpha(1);
draw_set_color(c_white);