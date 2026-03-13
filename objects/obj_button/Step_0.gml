/// @description Обновить кнопки
// obj_button Step Event

// Перевірка чи миша над кнопкою
var _mx = mouse_x;
var _my = mouse_y;

is_hovered = (_mx >= x && _mx <= x + width && _my >= y && _my <= y + height);

// Перевірка натиску
if (is_hovered && mouse_check_button_pressed(mb_left))
{
	on_click();
}
