/// @description Малювання інтерфейсу користувача

// Перевірка, чи існує гравець
if (!instance_exists(obj_player)) exit; // Не малювати UI, якщо гравця немає

// Отримуємо актуальні розміри GUI на випадок зміни розміру вікна
display_width = display_get_gui_width();
display_height = display_get_gui_height();

// Налаштування малювання тексту
draw_set_halign(fa_left); // Вирівнювання по горизонталі (ліворуч)
draw_set_valign(fa_top);  // Вирівнювання по вертикалі (зверху)
draw_set_color(ui_text_color);
draw_set_font(fnt_main);

// --- Малювання HP ---
var _hp_text = "HP: " + string(obj_player.hp) + " / " + string(obj_player.max_hp);
draw_text(ui_margin, ui_margin, _hp_text);

// --- Малювання Кількісті Зілля ---
var _potion_y_pos = ui_margin + 25; // Позиція Y для зілля (нижче HP)

// Зілля Здоров'я
var _heal_text = "Здоров'я [2]: " + string(obj_player.potion_heal_count);
draw_text(ui_margin, _potion_y_pos, _heal_text);

// Зілля Сили
var _str_text = "Сила [3]: " + string(obj_player.potion_strength_count);
draw_text(ui_margin, _potion_y_pos + 20, _str_text);

// Зілля Швидкості
var _spd_text = "Швидкість [4]: " + string(obj_player.potion_speed_count);
draw_text(ui_margin, _potion_y_pos + 40, _spd_text);

// --- Малювання Тривалості Бафу (якщо активний) ---
if (obj_player.buff_duration > 0)
{
    var _buff_seconds = ceil(obj_player.buff_duration / room_speed); // Переводимо кадри в секунди
    var _buff_text = "";
    if (obj_player.temp_atk_buff > 0) {
        _buff_text = "Сила: ";
    } else if (obj_player.temp_spd_buff > 0) {
        _buff_text = "Швидкість: ";
    }
    _buff_text += string(_buff_seconds) + "с";

    // Малюємо текст бафу, наприклад, справа вгорі
    draw_set_halign(fa_right);
    draw_text(display_width - ui_margin, ui_margin, _buff_text);
    draw_set_halign(fa_left); // Повертаємо вирівнювання
}

// --- Підказка керування ---
draw_set_color(c_gray);
draw_set_halign(fa_right);
var _help_text = "ESC - Меню | ARROW/WASD - Рух | SPACE - Стрибок | F - Кидок";
draw_text(display_width - ui_margin, display_height - ui_margin - 20, _help_text);
draw_set_color(ui_text_color);
draw_set_halign(fa_left);



// Скидання налаштувань малювання (гарна практика)
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
// draw_set_font(-1); // Скидання шрифту на стандартний