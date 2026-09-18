/// @description Ініціалізація UI
/// obj_ui_controller — Create Event

// ════ НАЗВА ЗОНИ (рядок вгорі по центру) ════
// Встановлюється при зміні кімнати
zone_key  = "zone_sea";      // Назва зони
zone_room   = 1;           // Номер кімнати в зоні
 
// ════ ПІДКАЗКА / ЗАВДАННЯ (центр вгорі) ════
hint_text   = "";          // Поточна підказка
hint_timer  = 0;           // Скільки кадрів ще показувати
hint_alpha  = 0;           // Прозорість (плавна поява/зникнення)
 
// ════ ДІАЛОГ ГРАВЦЯ (ліво вгорі, E) ════
player_dialog_text  = "";
player_dialog_timer = 0;
player_dialog_alpha = 0;
 
// ════ ДІАЛОГ NPC/ВОРОГА (право вгорі, F) ════
npc_dialog_text     = "";
npc_dialog_timer    = 0;
npc_dialog_alpha    = 0;
 
// ════ ФУНКЦІЇ ВИКЛИКУ ДІАЛОГІВ ════
// Виклик з будь-якого об'єкта:
//   obj_ui_controller.show_player_dialog("Тут темно...", 180);
//   obj_ui_controller.show_npc_dialog("Зупинись, смертний!", 240);
//   obj_ui_controller.show_hint("Натисни E щоб кинути зброю", 300);
 
show_player_dialog = function(_text, _duration)
{
    player_dialog_text  = _text;
    player_dialog_timer = _duration;
    player_dialog_alpha = 0;
    // audio_play_sound(snd_dialog_open, 1, false);
};
 
show_npc_dialog = function(_text, _duration)
{
    npc_dialog_text     = _text;
    npc_dialog_timer    = _duration;
    npc_dialog_alpha    = 0;
    // audio_play_sound(snd_dialog_npc, 1, false);
};
 
show_hint = function(_text, _duration)
{
    hint_text   = _text;
    hint_timer  = _duration;
    hint_alpha  = 0;
};
 
// ════ ПАУЗА ════
game_paused = false;
 
// ════ РОЗМІРИ GUI ════
gw = display_get_gui_width();
gh = display_get_gui_height();

room_hud_update_zone();

if (variable_global_exists("save_notice_key") && global.save_notice_key != "")
{
    show_hint(lc(global.save_notice_key), global.save_notice_timer);
    global.save_notice_key = "";
    global.save_notice_timer = 0;
}
