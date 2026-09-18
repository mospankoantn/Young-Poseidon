/// @description 
/// obj_boss_triton — Create Event

boss_intro_shown = false;

boss_name_key = "boss_triton";   // Ключ для lc()
max_hp    = 50;
hp        = max_hp;
atk       = 1;     // З дизайн-документу
phase     = 1;
 
// ---- 4 ТОЧКИ ПАТРУЛЯ ----
var _cx = x; var _cy = y;
point_count = 4;
point_x[0] = _cx - 280;  point_y[0] = _cy - 120;
point_x[1] = _cx + 280;  point_y[1] = _cy - 120;
point_x[2] = _cx + 280;  point_y[2] = _cy + 80;
point_x[3] = _cx - 280;  point_y[3] = _cy + 80;
current_point = 0;
fly_speed     = 3;
 
// ---- КОНТАКТНА АТАКА ----
// Тритон завдає мінімальну шкоду при дотику (atk=1)
contact_cd     = 0;
contact_cd_max = 90;
 
is_dead = false;
image_speed = 0.1;

rock_recharge_timer = 0;

_triton_rock_hint = function(_key)
{
    if (instance_exists(obj_ui_controller))
        obj_ui_controller.show_hint(lc(_key), 180);
};

_triton_has_falling_rock = function()
{
    var _count = instance_number(obj_falling_rocks);
    for (var _i = 0; _i < _count; _i++)
    {
        var _rock = instance_find(obj_falling_rocks, _i);
        if (instance_exists(_rock) && _rock.state == 1) return true;
    }

    return false;
};

_triton_next_rock = function()
{
    var _best = noone;
    var _best_sort = 1000000000;
    var _count = instance_number(obj_falling_rocks);

    for (var _i = 0; _i < _count; _i++)
    {
        var _rock = instance_find(obj_falling_rocks, _i);
        if (instance_exists(_rock) && _rock.state == 0)
        {
            var _sort = _rock.initial_y * room_width + _rock.initial_x;
            if (_sort < _best_sort)
            {
                _best = _rock;
                _best_sort = _sort;
            }
        }
    }

    return _best;
};

_triton_mark_next_rock = function()
{
    with (obj_falling_rocks) is_next = false;

    var _next = _triton_next_rock();
    if (instance_exists(_next))
        _next.is_next = true;
};

_triton_begin_rock_recharge = function()
{
    if (rock_recharge_timer > 0) return;

    rock_recharge_timer = room_speed * 3;
    _triton_rock_hint("triton_rocks_recharging");
    with (obj_falling_rocks) is_next = false;
};

_triton_reset_rock_wave = function()
{
    with (obj_falling_rocks)
    {
        x = initial_x;
        y = initial_y;
        fall_spd = 0;
        state = 0;
        solid = false;
        show_warning = false;
        is_next = false;
    }

    _triton_mark_next_rock();
    _triton_rock_hint("triton_rocks_ready");
};

_activate_next_rock = function()
{
    if (rock_recharge_timer > 0)
    {
        _triton_rock_hint("triton_rocks_recharging");
        return;
    }

    if (_triton_has_falling_rock())
    {
        _triton_rock_hint("triton_rock_busy");
        return;
    }

    var _next = _triton_next_rock();
    if (instance_exists(_next))
    {
        _next.is_next = true;
        with (_next) event_user(0);
        _triton_mark_next_rock();
        return;
    }

    _triton_begin_rock_recharge();
};
 
// ---- ПІДКАЗКА ДЛЯ ГРАВЦЯ ----
// obj_interactive_button вже розміщені в кімнаті.
// Коли гравець натискає кнопку — з'являється obj_falling_rocks
// який при попаданні в Тритона завдає 10 шкоди.
// Це реалізовано через User Event 0 на Тритоні нижче.
