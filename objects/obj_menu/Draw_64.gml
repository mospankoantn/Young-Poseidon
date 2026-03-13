/// @description Малювання меню
// obj_menu Draw GUI Event

var _gui_width = display_get_gui_width();
var _gui_height = display_get_gui_height();

// Оновлюємо позиції кнопок
if (instance_exists(btn_start))
{
	btn_start.x = _gui_width / 2 - btn_start.width / 2;
	btn_start.y = _gui_height / 2 - button_spacing / 2;
}

if (instance_exists(btn_exit))
{
	btn_exit.x = _gui_width / 2 - btn_exit.width / 2;
	btn_exit.y = _gui_height / 2 + button_spacing / 2;
}

// Малювання титулу гри
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(title_color);
draw_text_transformed(_gui_width / 2, 100, title_text, 2, 2, 0);

// Скидаємо налаштування
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
