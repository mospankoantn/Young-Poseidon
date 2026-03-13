/// @description Малювання меню
// obj_menu Draw GUI Event

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
 
// Оновлюємо позиції кнопок при зміні розміру вікна
if (instance_exists(btn_start))
{
    btn_start.x = _gw / 2 - btn_start.width / 2;
    btn_start.y = _gh / 2 - 40;
}
if (instance_exists(btn_exit))
{
    btn_exit.x = _gw / 2 - btn_exit.width / 2;
    btn_exit.y = _gh / 2 + 40;
}
 
// ---- Заголовок ----
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
 
// Тінь заголовку
draw_set_color(make_color_rgb(0, 80, 120));
if (font_exists(fnt_main)) draw_set_font(fnt_main);
draw_text_transformed(_gw / 2 + 3, 103, "МОЛОДИЙ ПОСЕЙДОН", 2.5, 2.5, 0);
 
// Заголовок
draw_set_color(c_aqua);
draw_text_transformed(_gw / 2, 100, "МОЛОДИЙ ПОСЕЙДОН", 2.5, 2.5, 0);
 
// Скидання
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_font(-1);