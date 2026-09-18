/// @description
/// obj_comment_zone — Step Event

if (!instance_exists(obj_player)) exit;
 
// ---- ПЕРЕВІРКА ВХОДУ В ЗОНУ ----
var _px = obj_player.x;
var _py = obj_player.y;
var _in_zone = (_px > x && _px < x + zone_width
             && _py > y && _py < y + zone_height);
 
// Запускаємо один раз коли гравець входить
if (_in_zone && !has_triggered)
{
	has_triggered = true;
	is_showing    = true;
	current_line  = 0;
	// Беремо текст з lc() і розбиваємо по "|"
	comment_lines = string_split(lc(comment_key), "|");
	box_alpha_target = 1;
    // audio_play_sound(snd_comment, 1, false);
}
 
// ---- Q: НАСТУПНИЙ РЯДОК / ЗАКРИТИ ----
if (is_showing && keyboard_check_pressed(ord("Q")))
{
    current_line++;
    if (current_line >= array_length(comment_lines))
    {
        // Всі рядки показано — закриваємо
        is_showing       = false;
        box_alpha_target = 0;
    }
}
 
// Плавна зміна прозорості
box_alpha = lerp(box_alpha, box_alpha_target, 0.15);