/// @description
/// obj_checkpoint — Create Event

is_activated = false;
activation_fx_timer = 0;
activation_fx_length = max(1, round(room_speed * 0.75));

// If this room already owns the active checkpoint, restore the visual state.
// checkpoint_x/y store the player's safe standing point, so use a generous
// radius around the checkpoint object rather than exact equality.
if (variable_global_exists("checkpoint_room")
    && variable_global_exists("checkpoint_x")
    && variable_global_exists("checkpoint_y")
    && global.checkpoint_room == room
    && point_distance(x, y, global.checkpoint_x, global.checkpoint_y) <= 96)
{
    is_activated = true;
}

image_index = 0;
image_speed = 0;
