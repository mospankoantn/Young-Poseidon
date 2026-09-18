#macro YP_SAVE_FILE "young_poseidon_save.ini"
#macro YP_SAVE_VERSION 1

function _room_route_exit_color(_dir)
{
    switch (_dir)
    {
        case "right": return make_color_rgb(80, 180, 120);
        case "left":  return make_color_rgb(80, 130, 220);
        case "up":    return make_color_rgb(200, 160, 60);
        case "down":  return make_color_rgb(160, 80, 200);
    }

    return make_color_rgb(80, 140, 220);
}

// Manual obj_room_exit instances act as overrides for generated routes.
// Optional manual flags: blocks_auto_routes, blocks_auto_direction.
function _room_route_manual_exit_exists(_target_room, _tag, _dir)
{
    var _count = instance_number(obj_room_exit);

    for (var _i = 0; _i < _count; _i++)
    {
        var _exit = instance_find(obj_room_exit, _i);
        if (!instance_exists(_exit)) continue;

        var _generated = false;
        if (variable_instance_exists(_exit, "route_generated"))
            _generated = _exit.route_generated;

        if (_generated) continue;

        if (variable_instance_exists(_exit, "blocks_auto_routes") && _exit.blocks_auto_routes)
            return true;

        if (variable_instance_exists(_exit, "target_room") && _exit.target_room == _target_room)
            return true;

        if (_tag != "" && variable_instance_exists(_exit, "spawn_tag") && _exit.spawn_tag == _tag)
            return true;

        if (variable_instance_exists(_exit, "blocks_auto_direction") && _exit.blocks_auto_direction)
        {
            if (variable_instance_exists(_exit, "exit_direction") && _exit.exit_direction == _dir)
                return true;
        }
    }

    return false;
}

function _room_route_exit(_target_room, _tag, _dir, _required_item)
{
    if (_room_route_manual_exit_exists(_target_room, _tag, _dir))
        return noone;

    var _x = room_width - 40;
    var _y = room_height - 128;
    var _w = 48;
    var _h = 128;

    switch (_dir)
    {
        case "left":
            _x = 40;
            _y = room_height - 128;
            _w = 48;
            _h = 128;
            break;

        case "right":
            _x = room_width - 40;
            _y = room_height - 128;
            _w = 48;
            _h = 128;
            break;

        case "up":
            _x = room_width * 0.5;
            _y = 64;
            _w = 128;
            _h = 64;
            break;

        case "down":
            _x = room_width * 0.5;
            _y = room_height - 64;
            _w = 128;
            _h = 64;
            break;
    }

    var _exit = instance_create_layer(_x, _y, "Instances", obj_room_exit);
    _exit.target_room = _target_room;
    _exit.spawn_tag = _tag;
    _exit.exit_direction = _dir;
    _exit.required_item = _required_item;
    _exit.is_locked = false;
    _exit.lock_reason = "";
    _exit.exit_width = _w;
    _exit.exit_height = _h;
    _exit.show_prompt = true;
    _exit._dir_color = _room_route_exit_color(_dir);
    _exit.route_generated = true;

    return _exit;
}

function _room_route_exit_at(_target_room, _tag, _dir, _required_item, _x, _y, _w, _h)
{
    if (_room_route_manual_exit_exists(_target_room, _tag, _dir))
        return noone;

    var _exit = instance_create_layer(_x, _y, "Instances", obj_room_exit);
    _exit.target_room = _target_room;
    _exit.spawn_tag = _tag;
    _exit.exit_direction = _dir;
    _exit.required_item = _required_item;
    _exit.is_locked = false;
    _exit.lock_reason = "";
    _exit.exit_width = _w;
    _exit.exit_height = _h;
    _exit.show_prompt = true;
    _exit._dir_color = _room_route_exit_color(_dir);
    _exit.route_generated = true;

    return _exit;
}

function room_route_exits_rebuild()
{
    if (room == rm_menu || room == rm_test) return false;

    with (obj_room_exit)
    {
        if (variable_instance_exists(id, "route_generated") && route_generated)
            instance_destroy();
    }

    switch (room)
    {
        case rm_sea_1:
            _room_route_exit(rm_sea_2, "sea1_sea2", "right", "");
            break;

        case rm_sea_2:
            _room_route_exit(rm_sea_1, "sea1_sea2", "left", "");
            _room_route_exit(rm_sea_3, "sea2_sea3", "right", "");
            break;

        case rm_sea_3:
            _room_route_exit(rm_sea_2, "sea2_sea3", "left", "");
            _room_route_exit(rm_sea_4, "sea3_sea4", "right", "trident");
            break;

        case rm_sea_4:
            _room_route_exit(rm_sea_3, "sea3_sea4", "left", "");
            _room_route_exit(rm_sea_5, "sea4_sea5", "right", "");
            break;

        case rm_sea_5:
            _room_route_exit(rm_sea_4, "sea4_sea5", "left", "");
            _room_route_exit(rm_coast_1, "sea5_coast1", "right", "");
            break;

        case rm_coast_1:
            _room_route_exit(rm_sea_5, "sea5_coast1", "left", "");
            _room_route_exit(rm_coast_2, "coast1_coast2", "right", "");
            break;

        case rm_coast_2:
            _room_route_exit(rm_coast_1, "coast1_coast2", "left", "");
            _room_route_exit(rm_coast_3, "coast2_coast3", "right", "");
            break;

        case rm_coast_3:
            _room_route_exit(rm_coast_2, "coast2_coast3", "left", "");
            _room_route_exit(rm_coast_4, "coast3_coast4", "right", "");
            break;

        case rm_coast_4:
            _room_route_exit(rm_coast_3, "coast3_coast4", "left", "");
            _room_route_exit(rm_coast_5, "coast4_coast5", "right", "");
            break;

        case rm_coast_5:
            _room_route_exit(rm_coast_4, "coast4_coast5", "left", "");
            _room_route_exit(rm_mines_1, "coast5_mines1", "right", "spear");
            break;

        case rm_mines_1:
            _room_route_exit(rm_coast_5, "coast5_mines1", "left", "");
            _room_route_exit(rm_mines_2, "mines1_mines2", "right", "");
            break;

        case rm_mines_2:
            _room_route_exit(rm_mines_1, "mines1_mines2", "left", "");
            _room_route_exit(rm_mines_3, "mines2_mines3", "right", "");
            break;

        case rm_mines_3:
            _room_route_exit(rm_mines_2, "mines2_mines3", "left", "");
            _room_route_exit(rm_mines_4, "mines3_mines4", "right", "");
            break;

        case rm_mines_4:
            _room_route_exit(rm_mines_3, "mines3_mines4", "left", "");
            _room_route_exit(rm_mines_5, "mines4_mines5", "right", "pickaxe");
            break;

        case rm_mines_5:
            _room_route_exit(rm_mines_4, "mines4_mines5", "left", "");
            _room_route_exit(rm_greece_1, "mines5_greece1", "right", "");
            _room_route_exit_at(rm_hades_1, "mines5_hades1", "right", "", room_width * 0.5, room_height - 128, 96, 128);
            break;

        case rm_hades_1:
            _room_route_exit(rm_mines_5, "mines5_hades1", "left", "");
            _room_route_exit(rm_hades_2, "hades1_hades2", "right", "");
            break;

        case rm_hades_2:
            _room_route_exit(rm_hades_1, "hades1_hades2", "left", "");
            _room_route_exit(rm_hades_3, "hades2_hades3", "right", "");
            break;

        case rm_hades_3:
            _room_route_exit(rm_hades_2, "hades2_hades3", "left", "");
            _room_route_exit(rm_hades_4, "hades3_hades4", "right", "");
            break;

        case rm_hades_4:
            _room_route_exit(rm_hades_3, "hades3_hades4", "left", "");
            _room_route_exit(rm_hades_5, "hades4_hades5", "right", "");
            break;

        case rm_hades_5:
            _room_route_exit(rm_hades_4, "hades4_hades5", "left", "");
            break;

        case rm_greece_1:
            _room_route_exit(rm_mines_5, "mines5_greece1", "left", "");
            _room_route_exit(rm_greece_2, "greece1_greece2", "right", "");
            break;

        case rm_greece_2:
            _room_route_exit(rm_greece_1, "greece1_greece2", "left", "");
            _room_route_exit(rm_greece_3, "greece2_greece3", "right", "");
            break;

        case rm_greece_3:
            _room_route_exit(rm_greece_2, "greece2_greece3", "left", "");
            _room_route_exit(rm_greece_4, "greece3_greece4", "right", "");
            break;

        case rm_greece_4:
            _room_route_exit(rm_greece_3, "greece3_greece4", "left", "");
            _room_route_exit(rm_greece_5, "greece4_greece5", "right", "");
            break;

        case rm_greece_5:
            _room_route_exit(rm_greece_4, "greece4_greece5", "left", "");
            _room_route_exit(rm_battlefield_1, "greece5_battlefield1", "right", "oar");
            break;

        case rm_battlefield_1:
            _room_route_exit(rm_greece_5, "greece5_battlefield1", "left", "");
            _room_route_exit(rm_battlefield_2, "battlefield1_battlefield2", "right", "");
            break;

        case rm_battlefield_2:
            _room_route_exit(rm_battlefield_1, "battlefield1_battlefield2", "left", "");
            _room_route_exit(rm_battlefield_3, "battlefield2_battlefield3", "right", "");
            break;

        case rm_battlefield_3:
            _room_route_exit(rm_battlefield_2, "battlefield2_battlefield3", "left", "");
            _room_route_exit(rm_battlefield_4, "battlefield3_battlefield4", "right", "");
            break;

        case rm_battlefield_4:
            _room_route_exit(rm_battlefield_3, "battlefield3_battlefield4", "left", "");
            _room_route_exit(rm_battlefield_5, "battlefield4_battlefield5", "right", "");
            break;

        case rm_battlefield_5:
            _room_route_exit(rm_battlefield_4, "battlefield4_battlefield5", "left", "");
            _room_route_exit(rm_olympus_1, "battlefield5_olympus1", "right", "sword");
            break;

        case rm_olympus_1:
            _room_route_exit(rm_battlefield_5, "battlefield5_olympus1", "left", "");
            _room_route_exit(rm_olympus_2, "olympus1_olympus2", "right", "");
            break;

        case rm_olympus_2:
            _room_route_exit(rm_olympus_1, "olympus1_olympus2", "left", "");
            _room_route_exit(rm_olympus_3, "olympus2_olympus3", "right", "");
            break;

        case rm_olympus_3:
            _room_route_exit(rm_olympus_2, "olympus2_olympus3", "left", "");
            _room_route_exit(rm_olympus_4, "olympus3_olympus4", "right", "");
            break;

        case rm_olympus_4:
            _room_route_exit(rm_olympus_3, "olympus3_olympus4", "left", "");
            _room_route_exit(rm_olympus_5, "olympus4_olympus5", "right", "");
            break;

        case rm_olympus_5:
            _room_route_exit(rm_olympus_4, "olympus4_olympus5", "left", "");
            break;

        default:
            return false;
    }

    return true;
}

function _room_hud_zone(_zone_key, _zone_room)
{
    if (!instance_exists(obj_ui_controller)) return false;

    var _ui = instance_find(obj_ui_controller, 0);
    _ui.zone_key = _zone_key;
    _ui.zone_room = _zone_room;

    return true;
}

function room_hud_update_zone()
{
    var _room_name = room_get_name(room);
    var _zone_key = "";
    var _prefix = "";

    if (string_pos("rm_sea_", _room_name) == 1)
    {
        _zone_key = "zone_sea";
        _prefix = "rm_sea_";
    }
    else if (string_pos("rm_coast_", _room_name) == 1)
    {
        _zone_key = "zone_coast";
        _prefix = "rm_coast_";
    }
    else if (string_pos("rm_mines_", _room_name) == 1)
    {
        _zone_key = "zone_mines";
        _prefix = "rm_mines_";
    }
    else if (string_pos("rm_hades_", _room_name) == 1)
    {
        _zone_key = "zone_hades";
        _prefix = "rm_hades_";
    }
    else if (string_pos("rm_greece_", _room_name) == 1)
    {
        _zone_key = "zone_greece";
        _prefix = "rm_greece_";
    }
    else if (string_pos("rm_battlefield_", _room_name) == 1)
    {
        _zone_key = "zone_battlefield";
        _prefix = "rm_battlefield_";
    }
    else if (string_pos("rm_olympus_", _room_name) == 1)
    {
        _zone_key = "zone_olympus";
        _prefix = "rm_olympus_";
    }

    if (_zone_key == "") return false;

    var _number_start = string_length(_prefix) + 1;
    var _number_text = string_copy(_room_name, _number_start, string_length(_room_name) - string_length(_prefix));
    var _zone_room = real(_number_text);

    if (_zone_room <= 0) return false;

    return _room_hud_zone(_zone_key, _zone_room);
}

function _save_notify(_key, _duration)
{
    var _text = lc(_key);

    if (instance_exists(obj_ui_controller))
    {
        obj_ui_controller.show_hint(_text, _duration);
        exit;
    }

    if (instance_exists(obj_main_menu))
    {
        obj_main_menu.status_text = _text;
        obj_main_menu.status_timer = _duration;
        exit;
    }

    global.save_notice_key = _key;
    global.save_notice_timer = _duration;
    show_debug_message(_text);
}

function _save_room_from_name(_name)
{
    var _room = asset_get_index(_name);
    if (_room == -1) return rm_sea_1;
    return _room;
}

function _save_clear_runtime_load()
{
    global.load_pending = false;
    global.save_notice_key = "";
    global.save_notice_timer = 0;

    global.spawn_from_tag = "";
    global.spawn_x_manual = -1;
    global.spawn_y_manual = -1;
    global.came_from_room = -1;
}

function save_exists()
{
    if (!file_exists(YP_SAVE_FILE)) return false;

    ini_open(YP_SAVE_FILE);
    var _exists = (ini_read_real("save", "exists", 0) == 1);
    ini_close();

    return _exists;
}

function start_new_game()
{
    _save_clear_runtime_load();

    global.checkpoint_room = rm_sea_1;
    global.checkpoint_x = 96;
    global.checkpoint_y = 544;
    global.weapon_unlocked = [false, false, false, false, false, false];

    if (instance_exists(obj_ui_controller))
        obj_ui_controller.game_paused = false;

    with (obj_player) instance_destroy();
    room_goto(rm_sea_1);
}

function save_game()
{
    if (!instance_exists(obj_player))
    {
        _save_notify("save_failed", 180);
        return false;
    }

    var _p = instance_find(obj_player, 0);
    var _weapon_count = array_length(_p.weapon_unlocked);
    var _has_checkpoint = variable_global_exists("checkpoint_room");

    ini_open(YP_SAVE_FILE);

    ini_write_real("save", "exists", 1);
    ini_write_real("save", "version", YP_SAVE_VERSION);
    ini_write_string("save", "room", room_get_name(room));

    ini_write_real("player", "x", _p.x);
    ini_write_real("player", "y", _p.y);
    ini_write_real("player", "hp", _p.hp);
    ini_write_real("player", "max_hp", _p.max_hp);
    ini_write_real("player", "current_weapon", _p.current_weapon);
    ini_write_real("player", "perm_spd_bonus", _p.perm_spd_bonus);
    ini_write_real("player", "potion_heal_count", _p.potion_heal_count);
    ini_write_real("player", "potion_strength_count", _p.potion_strength_count);
    ini_write_real("player", "potion_speed_count", _p.potion_speed_count);
    ini_write_real("player", "has_olympus_key", _p.has_olympus_key ? 1 : 0);
    ini_write_real("player", "l_right", _p.l_right ? 1 : 0);

    ini_write_real("weapons", "count", _weapon_count);
    for (var _i = 0; _i < _weapon_count; _i++)
    {
        ini_write_real("weapons", "weapon_" + string(_i), _p.weapon_unlocked[_i] ? 1 : 0);
    }

    ini_write_real("checkpoint", "exists", _has_checkpoint ? 1 : 0);
    if (_has_checkpoint)
    {
        ini_write_string("checkpoint", "room", room_get_name(global.checkpoint_room));
        ini_write_real("checkpoint", "x", global.checkpoint_x);
        ini_write_real("checkpoint", "y", global.checkpoint_y);
    }

    ini_close();

    _save_notify("save_done", 180);
    return true;
}

function load_game()
{
    if (!save_exists())
    {
        _save_notify("load_missing", 180);
        return false;
    }

    ini_open(YP_SAVE_FILE);

    var _room_name = ini_read_string("save", "room", "rm_sea_1");
    var _target_room = _save_room_from_name(_room_name);

    global.load_pending = true;
    global.load_room = _target_room;
    global.load_x = ini_read_real("player", "x", 96);
    global.load_y = ini_read_real("player", "y", 544);
    global.load_hp = ini_read_real("player", "hp", 5);
    global.load_max_hp = ini_read_real("player", "max_hp", 5);
    global.load_current_weapon = floor(ini_read_real("player", "current_weapon", -1));
    global.load_perm_spd_bonus = ini_read_real("player", "perm_spd_bonus", 0);
    global.load_potion_heal_count = ini_read_real("player", "potion_heal_count", 0);
    global.load_potion_strength_count = ini_read_real("player", "potion_strength_count", 0);
    global.load_potion_speed_count = ini_read_real("player", "potion_speed_count", 0);
    global.load_has_olympus_key = (ini_read_real("player", "has_olympus_key", 0) == 1);
    global.load_l_right = (ini_read_real("player", "l_right", 1) == 1);

    var _weapon_count = max(0, floor(ini_read_real("weapons", "count", 6)));
    global.load_weapon_unlocked = array_create(_weapon_count, false);
    for (var _i = 0; _i < _weapon_count; _i++)
    {
        global.load_weapon_unlocked[_i] = (ini_read_real("weapons", "weapon_" + string(_i), 0) == 1);
    }

    global.load_checkpoint_exists = (ini_read_real("checkpoint", "exists", 0) == 1);
    global.load_checkpoint_room = _save_room_from_name(ini_read_string("checkpoint", "room", _room_name));
    global.load_checkpoint_x = ini_read_real("checkpoint", "x", global.load_x);
    global.load_checkpoint_y = ini_read_real("checkpoint", "y", global.load_y);

    ini_close();

    global.spawn_from_tag = "";
    global.spawn_x_manual = -1;
    global.spawn_y_manual = -1;
    global.came_from_room = -1;

    if (instance_exists(obj_ui_controller))
        obj_ui_controller.game_paused = false;

    room_goto(_target_room);
    return true;
}

function apply_pending_load_to_player()
{
    if (!variable_global_exists("load_pending") || !global.load_pending) return false;
    if (!instance_exists(obj_player)) return false;

    var _p = instance_find(obj_player, 0);

    _p.x = global.load_x;
    _p.y = global.load_y;
    _p.hspd = 0;
    _p.vspd = 0;
    _p.drop_timer = 0;

    _p.max_hp = max(1, global.load_max_hp);
    _p.hp = clamp(global.load_hp, 1, _p.max_hp);
    _p.current_weapon = global.load_current_weapon;
    _p.perm_spd_bonus = global.load_perm_spd_bonus;
    _p.temp_spd_buff = 0;
    _p.temp_atk_buff = 0;
    _p.buff_duration = 0;
    _p.potion_heal_count = max(0, global.load_potion_heal_count);
    _p.potion_strength_count = max(0, global.load_potion_strength_count);
    _p.potion_speed_count = max(0, global.load_potion_speed_count);
    _p.has_olympus_key = global.load_has_olympus_key;
    _p.l_right = global.load_l_right;
    _p.is_damage = false;
    _p.is_frozen = false;
    _p.freeze_timer = 0;

    var _player_weapon_count = array_length(_p.weapon_unlocked);
    var _saved_weapon_count = array_length(global.load_weapon_unlocked);
    var _copy_count = min(_player_weapon_count, _saved_weapon_count);

    for (var _i = 0; _i < _player_weapon_count; _i++)
        _p.weapon_unlocked[_i] = false;

    for (var _i = 0; _i < _copy_count; _i++)
        _p.weapon_unlocked[_i] = global.load_weapon_unlocked[_i];

    global.weapon_unlocked = array_create(_player_weapon_count, false);
    for (var _i = 0; _i < _player_weapon_count; _i++)
        global.weapon_unlocked[_i] = _p.weapon_unlocked[_i];

    var _valid_weapon = false;
    if (_p.current_weapon >= 0 && _p.current_weapon < _player_weapon_count)
        _valid_weapon = _p.weapon_unlocked[_p.current_weapon];

    if (!_valid_weapon)
    {
        _p.current_weapon = -1;
        for (var _i = 0; _i < _player_weapon_count; _i++)
        {
            if (_p.weapon_unlocked[_i])
            {
                _p.current_weapon = _i;
                break;
            }
        }
    }

    if (global.load_checkpoint_exists)
    {
        global.checkpoint_room = global.load_checkpoint_room;
        global.checkpoint_x = global.load_checkpoint_x;
        global.checkpoint_y = global.load_checkpoint_y;
    }
    else
    {
        global.checkpoint_room = global.load_room;
        global.checkpoint_x = global.load_x;
        global.checkpoint_y = global.load_y;
    }

    _p.trident_instance = instance_find(obj_trident, 0);
    if (!instance_exists(_p.trident_instance))
        _p.trident_instance = instance_create_layer(_p.x + 32, _p.y, "Instances", obj_trident);

    if (instance_exists(_p.trident_instance))
    {
        _p.trident_instance.x = _p.x + 32;
        _p.trident_instance.y = _p.y;
        _p.trident_instance.hspd = 0;
        _p.trident_instance.vspd = 0;
        _p.trident_instance.thrown = false;
        _p.trident_instance.stuck = false;
        _p.trident_instance.timer = 0;
        _p.trident_instance.image_angle = 0;
    }

    global.load_pending = false;
    _p._reset_player_animation();
    _save_notify("load_done", 180);

    return true;
}
