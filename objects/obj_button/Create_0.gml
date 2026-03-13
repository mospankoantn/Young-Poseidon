/// @description Кнопка
// obj_button  Create Event

// ---- РОЗМІР ----
width  = 200;
height = 50;
 
// ---- ТЕКСТ ----
text       = "";
text_color = c_white;
 
// ---- КОЛЬОРИ ----
col_normal = make_color_rgb(80, 80, 80);
col_hover  = make_color_rgb(60, 100, 180);
col_border = make_color_rgb(180, 180, 180);
 
// ---- СТАН ----
is_hovered = false;
 
// ---- ФУНКЦІЯ НАТИСКУ (перевизначається ззовні) ----
on_click = function() {};