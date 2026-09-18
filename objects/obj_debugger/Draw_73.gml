/// @description obj_debugger — Draw End Event
// Хітбокси і вектори швидкості у просторі гри

if (!is_open) exit;

// ── ХІТБОКСИ ──
if (show_hitbox)
{
    // Гравець
    if (instance_exists(obj_player))
    {
        var _p  = obj_player;
        var _bx = _p.bbox_left;
        var _by = _p.bbox_top;
        var _br = _p.bbox_right;
        var _bb = _p.bbox_bottom;
        draw_set_alpha(0.6);
        draw_set_color(make_color_rgb(100, 255, 100));
        draw_rectangle(_bx, _by, _br, _bb, true);
        draw_set_alpha(1);
    }

    // Вороги
    with (obj_enemy)
    {
        draw_set_alpha(0.5);
        draw_set_color(make_color_rgb(255, 80, 80));
        draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, true);
        draw_set_alpha(1);
    }

    // Платформи
    with (obj_platform)
    {
        draw_set_alpha(0.2);
        draw_set_color(c_yellow);
        draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, true);
        draw_set_alpha(1);
    }
}

// ── ВЕКТОР ШВИДКОСТІ ──
if (show_velocity && instance_exists(obj_player))
{
    var _p  = obj_player;
    var _cx = _p.x;
    var _cy = _p.y;
    var _sc = 5;

    // hspd — синій
    draw_set_alpha(0.9);
    draw_set_color(c_blue);
    draw_arrow(_cx, _cy, _cx + _p.hspd * _sc, _cy, 2);

    // vspd — червоний
    draw_set_color(c_red);
    draw_arrow(_cx, _cy, _cx, _cy + _p.vspd * _sc, 2);
    draw_set_alpha(1);
}

draw_set_color(c_white);
draw_set_alpha(1);
