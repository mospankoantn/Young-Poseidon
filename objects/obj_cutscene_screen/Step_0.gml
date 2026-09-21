/// @description Cutscene input and page flow.

// Suspend all live room instances exactly once, but keep this modal active.
// We deliberately do NOT call the regular pause-menu function, because that would display the
// pause menu and hide/compete with this cutscene.
if (!suspend_done)
{
    var _owner = id;
    suspended_instances = [];

    with (all)
    {
        if (id != _owner && object_index != obj_cutscene_screen)
            array_push(other.suspended_instances, id);
    }

    for (var _i = 0; _i < array_length(suspended_instances); _i++)
        instance_deactivate_object(suspended_instances[_i]);

    suspend_done = true;
}

fade_alpha = lerp(fade_alpha, 1, 0.18);
if (accept_delay > 0) accept_delay--;

var _advance = yp_input("Q", true)
    || keyboard_check_pressed(vk_space)
    || keyboard_check_pressed(vk_enter);

if (!_advance || accept_delay > 0) exit;

if (page_index + 1 < array_length(pages))
{
    page_index++;
    accept_delay = 10;
    exit;
}

var _action = close_action;
var _state = state_key;

// Resume first so save callbacks can see obj_player again.
resume_suspended_instances();
global.cutscene_active = false;

if (_state != "") world_state_mark(_state);

// Save the completed ending flag while the player and final room still exist.
if (_action == "main_menu") autosave_game();

instance_destroy();

switch (_action)
{
    case "start_game":
        room_goto(rm_sea_1);
        break;

    case "main_menu":
        room_goto(rm_menu);
        break;
}
