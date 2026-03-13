/// @description Малювання тризубця

// Не малюємо тризубець, коли він дуже близько до гравця (у руках)
if (point_distance(x, y, obj_player.x, obj_player.y) < 25 && !thrown && !stuck)
{
	// Тризубець у гравця - не малюємо
	exit;
}

// Малюємо тризубець нормально
draw_self();

// Малюємо лінію коли летить або застрягнув
if (thrown || stuck)
{
    draw_set_color(c_white);
    draw_line(x, y, obj_player.x, obj_player.y);
    draw_set_color(c_white);
}

// Якщо застрягнув, показуємо червоне світло (знак, що можна кидати знову)
if (stuck)
{
	draw_set_alpha(0.5 + 0.5 * sin(current_time / 100));
	draw_set_color(c_red);
	draw_circle(x, y, 15, false);
	draw_set_alpha(1);
	draw_set_color(c_white);
}


