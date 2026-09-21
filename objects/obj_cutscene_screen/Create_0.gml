/// @description Modal cutscene screen.
pages = [];
page_index = 0;
close_action = "resume";
state_key = "";
accept_delay = 12;
fade_alpha = 0;
started_at = current_time;
global.cutscene_active = true;

// Cutscenes use their own suspension state instead of the pause-menu system.
// This prevents obj_ui_controller from drawing the pause menu over the cutscene.
suspended_instances = [];
suspend_done = false;

resume_suspended_instances = function()
{
    if (!suspend_done) return;

    for (var _i = 0; _i < array_length(suspended_instances); _i++)
        instance_activate_object(suspended_instances[_i]);

    suspended_instances = [];
    suspend_done = false;
};
