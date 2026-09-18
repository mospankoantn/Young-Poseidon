/// @description
/// obj_room_exit — Draw Event

// Зона переходу (видима лише в редакторі — можна вимкнути в грі)
// Якщо хочеш бачити зону під час гри — розкоментуй:
/*
draw_set_alpha(0.15);
draw_set_color(_dir_color);
draw_rectangle(x - exit_width/2, y - exit_height/2,
               x + exit_width/2, y + exit_height/2, false);
draw_set_alpha(0.4);
draw_set_color(_dir_color);
draw_rectangle(x - exit_width/2, y - exit_height/2,
               x + exit_width/2, y + exit_height/2, true);
draw_set_alpha(1);
*/
 
// Стрілка напрямку (завжди видна)
var _arrow_alpha = 0.4 + 0.3 * sin(current_time / 300000);
draw_set_alpha(_arrow_alpha);
draw_set_color(_dir_color);
var _ax = x;
var _ay = y;
var _as = 12;   // Розмір стрілки
 
switch (exit_direction)
{
    case "right":
        draw_triangle(_ax + _as, _ay, _ax - _as, _ay - _as, _ax - _as, _ay + _as, false);
        break;
    case "left":
        draw_triangle(_ax - _as, _ay, _ax + _as, _ay - _as, _ax + _as, _ay + _as, false);
        break;
    case "up":
        draw_triangle(_ax, _ay - _as, _ax - _as, _ay + _as, _ax + _as, _ay + _as, false);
        break;
    case "down":
        draw_triangle(_ax, _ay + _as, _ax - _as, _ay - _as, _ax + _as, _ay - _as, false);
        break;
}
draw_set_alpha(1);
 
// Анімація "затрусіння" якщо заблокований
var _shake_x = (lock_shake > 0) ? irandom_range(-3, 3) : 0;
 
// Іконка замка (якщо заблокований)
if (is_locked || required_item != "")
{
    var _lx = x + _shake_x;
    var _ly = y - exit_height / 2 - 20;
 
    draw_set_color(make_color_rgb(180, 140, 60));
    draw_set_alpha(0.9);
    // Тіло замка
    draw_rectangle(_lx - 8, _ly, _lx + 8, _ly + 12, false);
    // Дужка замка
    draw_set_color(make_color_rgb(140, 100, 40));
    draw_ellipse(_lx - 6, _ly - 8, _lx + 6, _ly + 2, true);
    draw_set_alpha(1);
}