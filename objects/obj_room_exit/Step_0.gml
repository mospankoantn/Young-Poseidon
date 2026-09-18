/// @description
/// obj_room_exit — Step Event

if (!instance_exists(obj_player)) exit;
 
// ---- ПЕРЕВІРКА ЧИ ГРАВЕЦЬ У ЗОНІ ПЕРЕХОДУ ----
var _px = obj_player.x;
var _py = obj_player.y;
 
player_in_range = (_px > x - exit_width  / 2
               && _px < x + exit_width  / 2
               && _py > y - exit_height / 2
               && _py < y + exit_height / 2);
 
// Плавна поява підказки
var _target_alpha = (player_in_range && show_prompt) ? 1 : 0;
prompt_alpha      = lerp(prompt_alpha, _target_alpha, 0.14);
 
// ---- ЗАТРЯСІННЯ (якщо заблокований і намагаються пройти) ----
if (lock_shake > 0)
    lock_shake = max(0, lock_shake - 1);
 
// ---- F — АКТИВУВАТИ ПЕРЕХІД ----
if (player_in_range && yp_input("F",true))
{
    _try_enter();
}
 
// ---- АВТО-ПЕРЕХІД (якщо гравець заходить в зону без F) ----
// Розкоментуй якщо хочеш автоматичний перехід без кнопки:
/*
if (player_in_range && !is_locked && required_item == "")
{
    _try_enter();
}
*/