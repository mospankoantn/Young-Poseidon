
/// @description Ініціалізація UI
display_width = display_get_gui_width();
display_height = display_get_gui_height();

// Налаштування відображення (необов'язково)
ui_margin = 10; // Відступ від краю екрану
ui_text_color = c_white;
//ui_font = font_add_sprite(spr_font_default, ord(" "), true, 1); // Замініть spr_font_default на ваш шрифт, якщо є
draw_set_font(fnt_main);
// Якщо немає спрайтового шрифту, можна використовувати draw_set_font() зі стандартним шрифтом
