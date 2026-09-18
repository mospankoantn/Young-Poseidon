/// obj_olympus_filter — Draw End Event

var _vx = camera_get_view_x(view_camera[0]);
var _vy = camera_get_view_y(view_camera[0]);
var _vw = camera_get_view_width(view_camera[0]);
var _vh = camera_get_view_height(view_camera[0]);
 
glow_offset  += glow_speed;
cloud_drift  += 0.004;
ether_pulse  += 0.015;
 
// ── 1. ЕФІРНИЙ ВІДТІНОК ──
// Олімп = золотаво-білий, майже сліпучий вгорі
for (var _si = 0; _si < 12; _si++)
{
    var _t  = _si / 11.0;
    // Вгорі золоте сяяння, внизу трохи блакитне (небо нижче)
    var _r  = lerp(80,  20,  _t);
    var _g  = lerp(60,  20,  _t);
    var _b  = lerp(20,  30,  _t);
    var _a  = lerp(0.18, 0.04, _t);
    draw_set_alpha(_a);
    draw_set_color(make_color_rgb(_r, _g, _b));
    draw_rectangle(_vx, _vy + _si * (_vh/12.0),
                   _vx + _vw, _vy + (_si+1)*(_vh/12.0), false);
}
draw_set_alpha(1);
 
// ── 2. ХМАРИ ──
for (var _ci = 0; _ci < 8; _ci++)
{
    var _cx   = _vx + (_vw / 8.0) * _ci
                + sin(cloud_drift + _ci * 0.7) * 30;
    var _cy   = _vy + _vh * 0.15
                + cos(cloud_drift * 0.6 + _ci * 0.5) * 20;
    var _cr   = 80 + sin(cloud_drift + _ci) * 20;
    var _ca   = 0.12 + sin(cloud_drift * 1.3 + _ci) * 0.04;
 
    // Пухнаста хмара з кількох кіл
    for (var _cri = 0; _cri < 4; _cri++)
    {
        var _off_x = (_cri - 1.5) * _cr * 0.4;
        var _off_y = sin(_cri * 0.8) * _cr * 0.2;
        var _cr2   = _cr * (0.6 + _cri * 0.1);
        draw_set_alpha(_ca * (0.5 + _cri * 0.1));
        draw_set_color(make_color_rgb(255, 255, 255));
        draw_circle(_cx + _off_x, _cy + _off_y, _cr2 * 0.5, false);
    }
}
draw_set_alpha(1);
 
// ── 3. ЗОЛОТІ ІСКРИ БОГІВ ──
for (var _si = 0; _si < spark_count; _si++)
{
    spark_x[@ _si]    += spark_vx[_si];
    spark_y[@ _si]    += spark_vy[_si];
    spark_vy[@ _si]   -= 0.005;
    spark_life[@ _si] += 1;
 
    if (spark_life[_si] >= spark_maxl[_si])
    {
        spark_x[@ _si]    = random(_vw);
        spark_y[@ _si]    = random(_vh);
        spark_vx[@ _si]   = random_range(-0.5, 0.5);
        spark_vy[@ _si]   = random_range(-1.0, -0.2);
        spark_maxl[@ _si] = random_range(60, 180);
        spark_life[@ _si] = 0;
    }
 
    var _lt  = spark_life[_si] / spark_maxl[_si];
    var _sa  = (1 - abs(_lt * 2 - 1)) * 0.7;  // Народжується і зникає
 
    // Золота іскра
    draw_set_alpha(_sa);
    draw_set_color(make_color_rgb(255, 215, 80));
    draw_circle(_vx + spark_x[_si], _vy + spark_y[_si], 2, false);
 
    // Білий центр
    draw_set_alpha(_sa * 0.6);
    draw_set_color(c_white);
    draw_circle(_vx + spark_x[_si], _vy + spark_y[_si], 1, false);
}
draw_set_alpha(1);
 
// ── 4. ПУЛЬСУЮЧЕ БОЖЕ СЯЯННЯ ──
var _divine_a = 0.06 + sin(glow_offset * 1.5) * 0.025
                     + sin(glow_offset * 3.7) * 0.01;
draw_set_alpha(max(0, _divine_a));
draw_set_color(make_color_rgb(255, 240, 180));
draw_rectangle(_vx, _vy, _vx + _vw, _vy + _vh, false);
draw_set_alpha(1);
 
// ── 5. ЕФІРНИЙ ТУМАН (дихання Олімпу) ──
var _ether_a = 0.04 + sin(ether_pulse * 0.7) * 0.02;
draw_set_alpha(max(0, _ether_a));
draw_set_color(make_color_rgb(200, 220, 255));
draw_rectangle(_vx, _vy, _vx + _vw, _vy + _vh * 0.4, false);
draw_set_alpha(1);
 
// ── 6. М'ЯКЕ СЯЯННЯ КРАЇВ ──
// Олімп = краї ЯСКРАВІШІ а не темніші
for (var _ci = 0; _ci < 6; _ci++)
{
    var _cp = 1 - _ci / 6.0;
    var _cw = 50 * _cp;
    draw_set_alpha(0.015 * _cp);
    draw_set_color(make_color_rgb(255, 240, 180));
    draw_rectangle(_vx,             _vy, _vx + _cw,     _vy + _vh, false);
    draw_rectangle(_vx + _vw - _cw, _vy, _vx + _vw,     _vy + _vh, false);
}
draw_set_alpha(1);
draw_set_color(c_white);