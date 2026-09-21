/// Modal cutscenes own keyboard input while visible.
if (variable_global_exists("cutscene_active") && global.cutscene_active) exit;

yp_display_tick();
if (status_timer > 0)
{
    status_timer--;
    menu_notice = status_text;
    menu_notice_until = current_time + 100;
}

if (startup_transition_active)
{
    var _fade_speed = 0.10;
    if (startup_transition_phase == "out")
    {
        startup_transition_alpha = min(1, startup_transition_alpha + _fade_speed);
        if (startup_transition_alpha >= 1)
        {
            startup_apply_transition_target();
            startup_transition_phase = "in";
        }
    }
    else if (startup_transition_phase == "in")
    {
        startup_transition_alpha = max(0, startup_transition_alpha - _fade_speed);
        if (startup_transition_alpha <= 0)
        {
            startup_transition_alpha = 0;
            startup_transition_phase = "";
            startup_transition_target = "";
            startup_transition_active = false;
        }
    }
    exit;
}

if (startup_state != "done")
{
    var _mx = device_mouse_x_to_gui(0);
    var _my = device_mouse_y_to_gui(0);
    if (startup_skip_delay > 0) startup_skip_delay--;

    if (startup_state == "logo")
    {
        startup_logo_age += 1;
        startup_logo_prompt_alpha = clamp((startup_logo_age - 40) / 22, 0, 1);
        if (startup_timer > 0) startup_timer--;

        var _skip = keyboard_check_pressed(vk_space)
            || keyboard_check_pressed(vk_enter)
            || keyboard_check_pressed(vk_escape)
            || mouse_check_button_pressed(mb_left)
            || mouse_check_button_pressed(mb_right);

        if ((_skip && startup_skip_delay <= 0) || startup_timer <= 0)
            startup_advance();

        exit;
    }

    if (startup_state == "language")
    {
        var _gw = display_get_gui_width();
        var _gh = display_get_gui_height();
        var _flag_w = min(240, _gw * 0.22);
        var _flag_h = round(_flag_w * 0.62);
        var _gap = max(36, _gw * 0.06);
        var _total_w = _flag_w * 2 + _gap;
        var _x1 = (_gw - _total_w) * 0.5;
        var _y1 = clamp(_gh * 0.36, 235, 320);
        var _x2 = _x1 + _flag_w + _gap;
        var _y2 = _y1;

        var _ua_hover = point_in_rectangle(_mx, _my, _x1 - 16, _y1 - 18, _x1 + _flag_w + 16, _y1 + _flag_h + 70);
        var _en_hover = point_in_rectangle(_mx, _my, _x2 - 16, _y2 - 18, _x2 + _flag_w + 16, _y2 + _flag_h + 70);

        if (_ua_hover) startup_lang_selected = 0;
        if (_en_hover) startup_lang_selected = 1;

        if (keyboard_check_pressed(vk_left) || keyboard_check_pressed(ord("A")))
            startup_lang_selected = 0;
        if (keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D")))
            startup_lang_selected = 1;
        if (keyboard_check_pressed(vk_tab))
            startup_lang_selected = 1 - startup_lang_selected;

        if (mouse_check_button_pressed(mb_left))
        {
            if (_ua_hover)
            {
                startup_select_language("UA");
                exit;
            }
            if (_en_hover)
            {
                startup_select_language("EN");
                exit;
            }
        }

        if (startup_skip_delay <= 0 && (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)))
        {
            startup_select_language(startup_lang_selected == 0 ? "UA" : "EN");
            exit;
        }

        exit;
    }
}

yp_menu_step();
