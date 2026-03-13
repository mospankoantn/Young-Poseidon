/// @description
/// obj_olympus_door — Step Event

if (!instance_exists(obj_player)) exit;
 
// Перевіряємо чи гравець підходить до дверей з ключем
if (!is_open
    && distance_to_object(obj_player) <= interact_range
    && obj_player.has_olympus_key
    && keyboard_check_pressed(ord("E")))
{
    event_user(0);   // Відкрити
}
 
// Анімація відкриття
if (is_open && image_index < 5)
{
    open_timer++;
    if (open_timer mod 6 == 0)
        image_index++;
}
 
// Коли двері повністю відкриті — прибираємо solid
if (image_index >= 5)
{
    solid = false;   // Тепер можна пройти крізь
}