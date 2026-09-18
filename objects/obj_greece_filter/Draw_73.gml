/// obj_greece_filter — Draw End Event

var _vx = camera_get_view_x(view_camera[0]);
var _vy = camera_get_view_y(view_camera[0]);
var _vw = camera_get_view_width(view_camera[0]);
var _vh = camera_get_view_height(view_camera[0]);
 
sun_offset += sun_speed;
 
// ── 1. ТЕПЛЕ ЗОЛОТЕ ПОВІТРЯ ──
// Греція = яскрава і тепла, майже без тіней
for (var _si = 0; _si < 10; _si++)
{
    var _t  = _si / 9.0;
    // Верх холодніший (небо), низ теплий (земля нагріта)
    var _r  = lerp(0,  40,  _t * _t);
    var _g  = lerp(0,  15,  _t * _t);
    var _b  = lerp(0,  0,   _t);
    var _a  = lerp(0.0, 0.1, _t * _t);
    draw_set_alpha(_a);
    draw_set_color(make_color_rgb(_r, _g, _b));
    draw_rectangle(_vx, _vy + _si * (_vh/10.0),
                   _vx + _vw, _vy + (_si+1)*(_vh/10.0), false);
}
draw_set_alpha(1);
 
// ── 2. СОНЯЧНІ ПРОМЕНІ (від кута) ──
var _sun_x = _vx + _vw * 0.75;
var _sun_y = _vy - 50;
 
for (var _ri = 0; _ri < 6; _ri++)
{
    var _angle  = -60 + _ri * 30;
    var _rlen   = _vh * 1.5;
    var _rw_top = 20 + _ri * 8;
    var _rw_bot = 80 + _ri * 40;
    var _ra     = (0.03 + sin(sun_offset * 0.8 + _ri) * 0.012)
                  * (1 - abs(_ri - 2.5) * 0.15);
 
    var _end_x  = _sun_x + lengthdir_x(_rlen, _angle + 90);
    var _end_y  = _sun_y + lengthdir_y(_rlen, _angle + 90);
 
    draw_set_alpha(max(0, _ra));
    draw_set_color(make_color_rgb(255, 240, 180));
    draw_triangle(
        _sun_x - _rw_top, _sun_y,
        _sun_x + _rw_top, _sun_y,
        _end_x  + _rw_bot, _end_y,
        false
    );
    draw_triangle(
        _sun_x - _rw_top, _sun_y,
        _end_x  - _rw_bot, _end_y,
        _end_x  + _rw_bot, _end_y,
        false
    );
}
draw_set_alpha(1);
 
// ── 3. ТІНІ ВІД ХМАР ──
for (var _ci = 0; _ci < cloud_count; _ci++)
{
    cloud_x[@ _ci] += cloud_spd[_ci];
    if (cloud_x[_ci] > _vw + cloud_w[_ci])
        cloud_x[@ _ci] = -cloud_w[_ci];
 
    var _shadow_y  = _vy;
    var _shadow_h  = _vh;
    var _cx        = _vx + cloud_x[_ci];
 
    draw_set_alpha(cloud_alpha[_ci]);
    draw_set_color(make_color_rgb(30, 40, 60));
    // М'яка тінь через кілька смуг
    for (var _csi = 0; _csi < 5; _csi++)
    {
        var _csf = 1 - _csi / 5.0;
        draw_set_alpha(cloud_alpha[_ci] * _csf);
        draw_rectangle(_cx - _csi * 15, _shadow_y,
                       _cx + cloud_w[_ci] + _csi * 15, _shadow_y + _shadow_h, false);
    }
}
draw_set_alpha(1);
 
// ── 4. ЛИСТЯ НА ВІТРІ ──
for (var _li = 0; _li < leaf_count; _li++)
{
    leaf_x[@ _li]     += leaf_spd[_li];
    leaf_y[@ _li]     += sin(leaf_phase[_li]) * 0.4;
    leaf_phase[@ _li] += 0.04;
 
    if (leaf_x[_li] > _vw + 10)
    {
        leaf_x[@ _li] = -10;
        leaf_y[@ _li] = random(_vh);
    }
 
    var _la = 0.2 + sin(leaf_phase[_li] * 1.5) * 0.08;
    draw_set_alpha(_la);
    draw_set_color(make_color_rgb(80, 140, 50));
    // Маленький ромб = листочок
    var _lx = _vx + leaf_x[_li];
    var _ly = _vy + leaf_y[_li];
    draw_triangle(_lx, _ly - 4, _lx - 3, _ly, _lx, _ly + 4, false);
    draw_triangle(_lx, _ly - 4, _lx + 3, _ly, _lx, _ly + 4, false);
}
draw_set_alpha(1);
 
// ── 5. БЛИСК МАРМУРУ (спалахи на білих поверхнях) ──
var _glow_a = 0.04 + sin(sun_offset * 2.1) * 0.015;
draw_set_alpha(_glow_a);
draw_set_color(make_color_rgb(255, 250, 230));
draw_rectangle(_vx, _vy, _vx + _vw, _vy + _vh, false);
draw_set_alpha(1);
draw_set_color(c_white);