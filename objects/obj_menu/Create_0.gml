/// @description Ініціалізація меню
// obj_menu Create Event

// Налаштування меню
gui_width = display_get_gui_width();
gui_height = display_get_gui_height();

title_text = "МОЛОДИЙ ПОСЕЙДОН";
title_color = c_aqua;

// Кнопки
button_width = 250;
button_height = 60;
button_spacing = 80;
button_start_y = gui_height / 2;

// Створюємо кнопку "Почати"
btn_start = instance_create_layer(gui_width / 2 - button_width / 2, button_start_y - button_spacing / 2, "Instances", obj_button);
btn_start.text = "ПОЧАТИ ГРУ";
btn_start.width = button_width;
btn_start.height = button_height;
btn_start.text_color = c_white;
btn_start.button_color = c_gray;
btn_start.button_color_hover = c_blue;
btn_start.on_click = function() {
	room_goto(rm_sea_1);
};

// Створюємо кнопку "Вихід"
btn_exit = instance_create_layer(gui_width / 2 - button_width / 2, button_start_y + button_spacing / 2, "Instances", obj_button);
btn_exit.text = "ВИХІД";
btn_exit.width = button_width;
btn_exit.height = button_height;
btn_exit.text_color = c_white;
btn_exit.button_color = c_gray;
btn_exit.button_color_hover = c_blue;
btn_exit.on_click = function() {
	game_end();
};

