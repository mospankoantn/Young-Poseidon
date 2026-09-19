/// @description
/// obj_checkpoint — Step Event

if (is_activated || !instance_exists(obj_player)) exit;
if(obj_player.is_dead || obj_player.hp<=0) exit;
 
if (place_meeting(x, y, obj_player))
{
    var _player = instance_find(obj_player, 0);
    var _safe = player_find_safe_position(_player, _player.x, _player.y);
    if (!_safe[0]) exit;

    is_activated = true;
    image_index  = 1;

    // Зберігаємо реальну безпечну позицію гравця, а не origin самого чекпоінта.
    global.checkpoint_x    = _safe[1];
    global.checkpoint_y    = _safe[2];
    global.checkpoint_room = room;

    // Слот 0 зарезервований для автозбереження.
    autosave_game();

    // audio_play_sound(snd_checkpoint, 1, false);
}
