/// @description Обробка вводу меню
/// obj_main_menu — Step Event

appear_t = min(appear_t + 1, 60);
if (status_timer > 0) status_timer--;

// ── ОНОВЛЕННЯ ПУНКТІВ МЕНЮ (міняється при зміні мови) ──
menu_items[0] = lc("menu_start");
menu_items[1] = lc("menu_load");
menu_items[2] = lc("menu_settings");
menu_items[3] = lc("menu_about");
menu_items[4] = lc("menu_exit");
 
// Клавіатура
if (keyboard_check_pressed(vk_down))
    selected = (selected + 1) mod array_length(menu_items);
if (keyboard_check_pressed(vk_up))
    selected = (selected - 1 + array_length(menu_items)) mod array_length(menu_items);
 
if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space))
    _execute_menu(selected);
