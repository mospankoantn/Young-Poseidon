/// Main menu shares settings and navigation with the pause screen.
with (obj_player) instance_destroy();
yp_menu_init(false);
status_text = "";
status_timer = 0;

if (!variable_global_exists("yp_startup_sequence_done"))
    global.yp_startup_sequence_done = false;

startup_state = "done"; // "logo", "language", "done"
startup_timer = 0;
startup_skip_delay = 0;
startup_lang_selected = (global.lang == "EN") ? 1 : 0;
startup_logo_age = 0;
startup_logo_prompt_alpha = 0;
startup_jingle_played = false;
startup_transition_active = false;
startup_transition_phase = ""; // "in" / "out"
startup_transition_alpha = 0;
startup_transition_target = ""; // "language" / "done"

startup_has_pending_first_run = function()
{
    if (!variable_global_exists("yp_settings")) return false;
    if (!variable_struct_exists(global.yp_settings, "first_run_completed"))
        global.yp_settings.first_run_completed = false;
    return !global.yp_settings.first_run_completed;
};

startup_stop_jingle = function()
{
    if (audio_exists(snd_startup_jingle))
        audio_stop_sound(snd_startup_jingle);
    startup_jingle_played = false;
};

startup_play_jingle = function()
{
    if (!startup_jingle_played && audio_exists(snd_startup_jingle))
    {
        audio_stop_sound(snd_startup_jingle);
        audio_play_sound(snd_startup_jingle, 1, false);
        startup_jingle_played = true;
    }
};

startup_finish = function()
{
    startup_stop_jingle();
    startup_state = "done";
    startup_timer = 0;
    startup_skip_delay = 0;
    global.yp_startup_sequence_done = true;
};

startup_apply_transition_target = function()
{
    switch (startup_transition_target)
    {
        case "language":
            startup_state = "language";
            startup_timer = 0;
            startup_skip_delay = 8;
            startup_lang_selected = (global.lang == "EN") ? 1 : 0;
            break;

        case "done":
            startup_finish();
            break;
    }
};

startup_begin_transition = function(_target)
{
    if (_target == "language" || _target == "done")
    {
        startup_transition_active = true;
        startup_transition_phase = "out";
        startup_transition_alpha = 0;
        startup_transition_target = _target;
        if (startup_state == "logo") startup_stop_jingle();
    }
};

startup_begin = function()
{
    startup_state = "logo";
    startup_timer = room_speed * 4;
    startup_skip_delay = 12;
    startup_lang_selected = (global.lang == "EN") ? 1 : 0;
    startup_logo_age = 0;
    startup_logo_prompt_alpha = 0;
    global.yp_startup_sequence_done = false;
    startup_jingle_played = false;
    startup_play_jingle();
    startup_transition_active = true;
    startup_transition_phase = "in";
    startup_transition_alpha = 1;
    startup_transition_target = "";
};

startup_advance = function()
{
    if (startup_state == "logo")
    {
        if (startup_has_pending_first_run())
            startup_begin_transition("language");
        else
            startup_begin_transition("done");
    }
};

startup_select_language = function(_lang)
{
    if (_lang != "UA" && _lang != "EN") return;
    set_language(_lang);
    global.yp_settings.first_run_completed = true;
    yp_settings_save();
    startup_begin_transition("done");
};

startup_reset_first_launch = function()
{
    global.yp_settings.first_run_completed = false;
    yp_settings_save();
    startup_begin();
};

if (!global.yp_startup_sequence_done)
    startup_begin();
