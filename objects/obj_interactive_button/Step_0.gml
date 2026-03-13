/// @description 
/// obj_interactive_button — Step Event

if (!instance_exists(obj_player)) exit;
 
var _dist = distance_to_object(obj_player);
 
// ---- ВЗАЄМОДІЯ ----
// Гравець натискає E коли близько
if (_dist <= interact_range
    && keyboard_check_pressed(ord("E"))
    && !is_pressed)
{
    is_pressed   = true;
    image_index  = 1;   // Перемикаємо спрайт на "натиснуту" кнопку
 
    // Активуємо всі цільові об'єкти цього типу в кімнаті
    with (target_object)
    {
        event_user(0);   // Викликаємо User Event 0 на цілі
                         // (кожен цільовий об'єкт реагує сам)
    }
 
    // audio_play_sound(snd_button_press, 1, false);
 
    // Якщо кнопку можна натискати лише раз — блокуємо
    if (one_time_use)
    {
        // Залишаємо is_pressed = true назавжди
    }
    else
    {
        // Якщо кнопка перемикається — скидаємо через 1 секунду
        alarm[0] = room_speed;
    }
}
 