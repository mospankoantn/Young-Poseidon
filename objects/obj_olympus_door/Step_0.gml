/// @description Final Olympus gate interaction and ending trigger.
var _near = prop_player_near(interact_range);

if (!is_open && _near)
{
    yp_trigger_hint("olympus_door", "hint_olympus_door", 240);

    // F is the project's remappable interaction action. E remains accepted as
    // a compatibility fallback for older control muscle-memory/saves.
    if (instance_exists(obj_player)
        && obj_player.has_olympus_key
        && (yp_input("F", true) || yp_input("E", true)))
    {
        event_user(0);
    }
}

if (is_open)
{
    open_timer = min(open_timer + 1, 30);
    if (open_timer >= 30)
    {
        solid = false;
        sprite_index = -1;
        mask_index = -1;

        // The finale starts only after the player has actually opened the gate.
        if (room == rm_olympus_5) show_outro_cutscene();
    }
}
