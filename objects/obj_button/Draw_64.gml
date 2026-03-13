/// @description Малювання кнопки
// obj_button Draw GUI Event

// Вибір кольору залежно від стану
var _color = is_hovered ? button_color_hover : button_color;

// Малюємо фон кнопки
draw_set_color(_color);
draw_rectangle(x, y, x + width, y + height, false);

// Малюємо контур
draw_set_color(c_white);
draw_rectangle(x, y, x + width, y + height, true);

// Малюємо текст - намалюємо його дважди для видимості
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(text_color);
draw_set_font(fnt_main); // Використовуємо шрифт гри
draw_text(x + width / 2, y + height / 2, text);

// Скидаємо налаштування
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_font(-1); // Скидаємо шрифт
