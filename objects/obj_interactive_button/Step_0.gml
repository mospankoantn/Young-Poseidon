/// @description 
/// obj_interactive_button — Step Event

if (!instance_exists(obj_player)) exit;
 
var _dist = distance_to_object(obj_player);
 
// ---- ВЗАЄМОДІЯ ----
// Гравець натискає E коли близько
if (_dist <= interact_range
    && !obj_player.is_dead && obj_player.hp > 0
    && yp_input("E",true)
    && !is_pressed)
{
    is_pressed   = true;
    image_index  = 1;   // Перемикаємо спрайт на "натиснуту" кнопку
 
    if (target_object == obj_falling_rocks && instance_exists(obj_boss_triton))
    {
        with (obj_boss_triton) _activate_next_rock();
    }
    else
    {
        // Активуємо всі цільові об'єкти цього типу в кімнаті
        with (target_object)
        {
            event_user(0);
        }
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
