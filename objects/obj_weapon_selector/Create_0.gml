/// @description 
/// obj_weapon_selector — Create Event

// ---- РОЗМІРИ ----
gui_cx     = display_get_gui_width()  / 2;
gui_cy     = display_get_gui_height() / 2;
radius     = 120;     // Радіус кола іконок
icon_size  = 48;      // Розмір іконки зброї
depth      = -1000;   // Малюємо поверх всього
 
// ---- ВИБІР ----
// Визначаємо список розблокованих зброй
unlocked_indices = [];
var _all = array_length(obj_player.weapon_unlocked);
for (var _i = 0; _i < _all; _i++)
{
    if (obj_player.weapon_unlocked[_i])
        array_push(unlocked_indices, _i);
}
 
selected_slot  = 0;   // Індекс у списку unlocked_indices
hover_slot     = -1;  // Слот під мишею
 
// Знаходимо поточну зброю у списку
for (var _i = 0; _i < array_length(unlocked_indices); _i++)
{
    if (unlocked_indices[_i] == obj_player.current_weapon)
    {
        selected_slot = _i;
        break;
    }
}
 
// ---- АНІМАЦІЯ ПОЯВИ ----
appear_scale = 0;     // Починаємо з 0, збільшуємо до 1