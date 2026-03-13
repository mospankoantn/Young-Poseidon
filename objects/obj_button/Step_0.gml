/// @description Перевіряємо чи миша над кнопкою (координати GUI)
// obj_button Step Event

// Перевіряємо чи миша над кнопкою (координати GUI)
var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);
 
is_hovered = (_mx >= x && _mx <= x + width && _my >= y && _my <= y + height);
 
if (is_hovered && mouse_check_button_pressed(mb_left))
{
    on_click();
}