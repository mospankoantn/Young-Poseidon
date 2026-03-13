/// @description Ініціалізація меню
// obj_menu Create Event


var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
 
var _bw  = 250;
var _bh  = 60;
var _cx  = _gw / 2 - _bw / 2;
var _cy  = _gh / 2;
 
// ---- Кнопка "ПОЧАТИ ГРУ" ----
btn_start          = instance_create_layer(_cx, _cy - 40, "Instances", obj_button);
btn_start.text     = "ПОЧАТИ ГРУ";
btn_start.width    = _bw;
btn_start.height   = _bh;
btn_start.on_click = function() { room_goto(rm_test); };
 
// ---- Кнопка "ВИХІД" ----
btn_exit          = instance_create_layer(_cx, _cy + 40, "Instances", obj_button);
btn_exit.text     = "ВИХІД";
btn_exit.width    = _bw;
btn_exit.height   = _bh;
btn_exit.on_click = function() { game_end(); };