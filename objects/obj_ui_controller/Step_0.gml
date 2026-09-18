/// @description Обробка вводу
/// obj_ui_controller — Step Event

// ---- ДІАЛОГ ГРАВЦЯ ----
if (player_dialog_timer > 0)
{
    player_dialog_timer--;
    player_dialog_alpha = lerp(player_dialog_alpha, 1, 0.15);
    // Q — закрити діалог гравця (з дизайн-документу)
    if (keyboard_check_pressed(ord("Q")))
        player_dialog_timer = 0;
}
else
    player_dialog_alpha = lerp(player_dialog_alpha, 0, 0.12);
 
// ---- ДІАЛОГ NPC ----
if (npc_dialog_timer > 0)
{
    npc_dialog_timer--;
    npc_dialog_alpha = lerp(npc_dialog_alpha, 1, 0.15);
    if (keyboard_check_pressed(ord("Q")))
        npc_dialog_timer = 0;
}
else
    npc_dialog_alpha = lerp(npc_dialog_alpha, 0, 0.12);
 
// ---- ПІДКАЗКА/ЗАВДАННЯ ----
if (hint_timer > 0)
{
    hint_timer--;
    hint_alpha = lerp(hint_alpha, 1, 0.15);
}
else
    hint_alpha = lerp(hint_alpha, 0, 0.1);
 
// ---- ESC = ПАУЗА ----
if (keyboard_check_pressed(vk_escape))
{
    game_paused = !game_paused;
    // audio_play_sound(snd_pause, 1, false);
}

// ---- Mouse/touch pause button in the top-right HUD ----
if (mouse_check_button_pressed(mb_left))
{
    var _mx_pause = device_mouse_x_to_gui(0);
    var _my_pause = device_mouse_y_to_gui(0);
    var _pause_x = gw - 42;
    var _pause_y = 8;

    if (_mx_pause >= _pause_x && _mx_pause <= _pause_x + 30
     && _my_pause >= _pause_y && _my_pause <= _pause_y + 28)
    {
        game_paused = !game_paused;
    }
}
 
// ---- ОНОВЛЕННЯ РОЗМІРІВ (якщо вікно змінилося) ----
gw = display_get_gui_width();
gh = display_get_gui_height();
