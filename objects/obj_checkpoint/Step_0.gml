/// @description
/// obj_checkpoint — Step Event

if (is_activated || !instance_exists(obj_player)) exit;
if(obj_player.is_dead || obj_player.hp<=0) exit;
 
if (place_meeting(x, y, obj_player))
{
    is_activated = true;
    image_index  = 1;
 
    // Зберігаємо позицію відродження у глобальних змінних
    global.checkpoint_x    = x;
    global.checkpoint_y    = y;
    global.checkpoint_room = room;
 
    // audio_play_sound(snd_checkpoint, 1, false);
}
