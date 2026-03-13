/// @description Малювання тризубця
// obj_trident Draw Event

if (!instance_exists(obj_player)) { draw_self(); exit; }
 
// Не малюємо тризубець коли він "в руках" (дуже близько і не летить)
var _dist = point_distance(x, y, obj_player.x, obj_player.y);
if (_dist < 20 && !thrown && !stuck)
    exit;
 
draw_self();
 
// Лінія від тризубця до гравця (тільки коли летить або застряг)
if (thrown || stuck)
{
    draw_set_color(make_color_rgb(200, 220, 255));
    draw_set_alpha(0.5);
    draw_line(x, y, obj_player.x, obj_player.y);
    draw_set_alpha(1);
    draw_set_color(c_white);
}
 
// Мерехтливе коло коли застряг (підказка гравцю що можна натиснути 1)
if (stuck)
{
    var _pulse = 0.5 + 0.5 * sin(current_time / 150000);
    draw_set_alpha(_pulse);
    draw_set_color(c_yellow);
    draw_circle(x, y, 18, true);
    draw_set_alpha(1);
    draw_set_color(c_white);
}


