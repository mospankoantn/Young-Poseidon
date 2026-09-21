if (instance_exists(obj_player) && point_distance(x, y, obj_player.x, obj_player.y) <= 120)
    yp_trigger_hint("minotaur_column", "hint_minotaur_column", 240);

/// @description
/// obj_minotaur_column — Step Event

if (hp <= 0)
{
    world_state_mark_instance(id, "destroyed");
    // Колона руйнується — гравець падає вниз
    instance_destroy();
    exit;
}
image_index = hp <= 3 ? 1 : 0;
