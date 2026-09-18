/// @description Ініціалізація меню
/// obj_main_menu — Create Event

with (obj_player) instance_destroy();

// Пункти меню (з дизайн-документу)
// У obj_main_menu Step Event — оновлюємо масив кожен кадр
// (так меню миттєво змінюється при перемиканні мови)
menu_items = [
    lc("menu_start"),
    lc("menu_load"),
    lc("menu_settings"),
    lc("menu_about"),
    lc("menu_exit")
];
selected    = 0;
hover_item  = -1;
status_text = "";
status_timer = 0;
 
// Анімація появи
appear_t    = 0;

_execute_menu = function(_index)
{
    switch (_index)
    {
        case 0: start_new_game();            break;   // Почати гру
        case 1: load_game();                 break;   // Завантажити
        case 2: /* show_settings(); */       break;   // Налаштування
        case 3: /* show_about(); */          break;   // Про автора
        case 4: game_end();                  break;   // Вийти
    }
};
