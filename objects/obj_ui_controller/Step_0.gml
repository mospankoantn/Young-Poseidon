/// @description Обробка вводу
// obj_ui_controller Step Event

// ---- ESC: повернення в меню ----
if (keyboard_check_pressed(vk_escape))
{
    room_goto(rm_menu);
}