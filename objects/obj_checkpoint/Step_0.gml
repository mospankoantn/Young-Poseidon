if (instance_exists(obj_player) && point_distance(x, y, obj_player.x, obj_player.y) <= 96)
    yp_trigger_hint("checkpoint", "hint_checkpoint", 240);

/// @description
/// obj_checkpoint — Step Event

if (activation_fx_timer > 0) activation_fx_timer--;

if (is_activated || !instance_exists(obj_player)) exit;
if (obj_player.is_dead || obj_player.hp <= 0) exit;

if (place_meeting(x, y, obj_player))
{
    var _player = instance_find(obj_player, 0);
    var _safe = player_find_safe_position(_player, _player.x, _player.y);
    if (!_safe[0]) exit;

    is_activated = true;
    activation_fx_timer = activation_fx_length;

    // Store the player's real safe position, not the checkpoint origin.
    global.checkpoint_x = _safe[1];
    global.checkpoint_y = _safe[2];
    global.checkpoint_room = room;

    // Slot 0 is reserved for autosave.
    autosave_game();

    // audio_play_sound(snd_checkpoint, 1, false);
}
