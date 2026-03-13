/// @description Малювання кнопки
// obj_button Draw GUI Event

// Колір фону залежно від стану
var _col = is_hovered ? col_hover : col_normal;
 
// Тінь (для глибини)
draw_set_color(make_color_rgb(20, 20, 20));
draw_rectangle(x + 3, y + 3, x + width + 3, y + height + 3, false);
 
// Фон кнопки
draw_set_color(_col);
draw_rectangle(x, y, x + width, y + height, false);
 
// Контур
draw_set_color(col_border);
draw_rectangle(x, y, x + width, y + height, true);
 
// Текст
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(text_color);
if (font_exists(fnt_main)) draw_set_font(fnt_main);
draw_text(x + width / 2, y + height / 2, text);
 
// Скидання
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_font(-1);