#macro YP_SAVE_FILE "young_poseidon_save_1.ini"
#macro YP_SAVE_LEGACY "young_poseidon_save.ini"
#macro YP_SAVE_VERSION 2
#macro YP_SAVE_SLOT_MIN 0
#macro YP_SAVE_SLOT_MAX 10

function world_state_ensure()
{
    if (!variable_global_exists("world_state") || !is_struct(global.world_state))
        global.world_state = {};
}

function world_state_reset()
{
    global.world_state = {};
}

function _world_state_key_valid(_key)
{
    return is_string(_key) && string_length(_key) > 0 && string_length(_key) <= 256;
}

function world_state_has(_key)
{
    world_state_ensure();
    return _world_state_key_valid(_key) && variable_struct_exists(global.world_state, _key);
}

function world_state_mark(_key)
{
    if (!_world_state_key_valid(_key)) return false;
    world_state_ensure();
    variable_struct_set(global.world_state, _key, true);
    return true;
}

function world_state_instance_key(_instance, _kind)
{
    if (!instance_exists(_instance)) return "";
    if (variable_instance_exists(_instance, "world_state_id"))
    {
        var _manual = variable_instance_get(_instance, "world_state_id");
        if (_world_state_key_valid(_manual)) return _manual;
    }

    return _kind + "|" + room_get_name(room) + "|"
        + object_get_name(_instance.object_index) + "|"
        + string(round(_instance.xstart)) + "|" + string(round(_instance.ystart));
}

function world_state_bind(_instance, _key, _kind)
{
    if (!instance_exists(_instance)) return false;
    if (_world_state_key_valid(_key)) variable_instance_set(_instance, "world_state_id", _key);
    var _resolved = world_state_instance_key(_instance, _kind);
    if (!world_state_has(_resolved)) return false;
    with (_instance) instance_destroy();
    return true;
}

function world_state_restore_instance(_instance, _kind)
{
    return world_state_bind(_instance, "", _kind);
}

function world_state_mark_instance(_instance, _kind)
{
    return world_state_mark(world_state_instance_key(_instance, _kind));
}

function world_state_boss_key(_boss_id)
{
    return "boss|" + _boss_id + "|defeated";
}

function world_state_reward_key(_boss_id)
{
    return "reward|" + _boss_id + "|collected";
}

function world_state_boss_defeated(_boss_id)
{
    return world_state_has(world_state_boss_key(_boss_id));
}

function world_state_mark_boss_defeated(_boss_id)
{
    return world_state_mark(world_state_boss_key(_boss_id));
}

function world_state_spawn_boss_reward(_boss_id, _reward_object, _x, _y)
{
    if (world_state_has(world_state_reward_key(_boss_id))) return noone;
    if (instance_exists(_reward_object)) return instance_find(_reward_object, 0);
    return instance_create_layer(_x, _y, "Instances", _reward_object);
}

function _world_state_migrate_v1(_weapons, _has_key)
{
    var _bosses = ["triton", "nymph", "uranus", "charon", "minotaur", "war_ghost"];
    for (var _i = 0; _i < min(array_length(_weapons), array_length(_bosses)); _i++)
    {
        if (!_weapons[_i]) continue;
        world_state_mark_boss_defeated(_bosses[_i]);
        world_state_mark(world_state_reward_key(_bosses[_i]));
    }
    if (_has_key)
    {
        world_state_mark_boss_defeated("moirai");
        world_state_mark(world_state_reward_key("moirai"));
    }
}

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
        var _ui = instance_find(obj_ui_controller, 0);
        if (instance_exists(_ui) && variable_instance_exists(_ui, "show_hint"))
        {
            _ui.show_hint(_text, _duration);
            return;
        }
    }

    if (instance_exists(obj_main_menu))
    {
        var _menu = instance_find(obj_main_menu, 0);
        if (instance_exists(_menu))
        {
            _menu.status_text = _text;
            _menu.status_timer = _duration;
            return;
        }
    }

    global.save_notice_key = _key;
    global.save_notice_timer = _duration;
    show_debug_message(_text);
}

function _save_room_from_name(_name)
{
    if (!is_string(_name) || string_length(_name) <= 0 || string_length(_name) > 64) return -1;
    var _room = asset_get_index(_name);
    if (_room == -1 || !room_exists(_room) || _room == rm_menu) return -1;
    return _room;
}

function _save_real(_section, _key, _default, _minimum, _maximum)
{
    var _value = ini_read_real(_section, _key, _default);
    if (!is_real(_value) || is_nan(_value) || is_infinity(_value)) return _default;
    return clamp(_value, _minimum, _maximum);
}

function _save_file_status(_filename)
{
    if (!file_exists(_filename)) return 0;

    ini_open(_filename);
    var _exists = floor(ini_read_real("save", "exists", 0));
    var _version = floor(ini_read_real("save", "version", -1));
    var _room = _save_room_from_name(ini_read_string("save", "room", ""));
    ini_close();

    if (_exists != 1 || _version < 1 || _room == -1) return -1;
    if (_version > YP_SAVE_VERSION) return -2;
    return _version;
}

function _save_slot_valid(_slot)
{
    return is_real(_slot)
        && floor(_slot) == _slot
        && _slot >= YP_SAVE_SLOT_MIN
        && _slot <= YP_SAVE_SLOT_MAX;
}

function _save_slot_file(_slot)
{
    if (!_save_slot_valid(_slot)) return "";
    if (_slot == 0) return "young_poseidon_autosave.ini";
    if (_slot == 1) return YP_SAVE_FILE;
    return "young_poseidon_save_" + string(_slot) + ".ini";
}

function _save_slot_temp(_slot)
{
    if (!_save_slot_valid(_slot)) return "";
    if (_slot == 0) return "young_poseidon_autosave.tmp.ini";
    return "young_poseidon_save_" + string(_slot) + ".tmp.ini";
}

function _save_slot_backup(_slot)
{
    if (!_save_slot_valid(_slot)) return "";
    if (_slot == 0) return "young_poseidon_autosave.backup.ini";
    return "young_poseidon_save_" + string(_slot) + ".backup.ini";
}

function save_slot_status(_slot)
{
    if (!_save_slot_valid(_slot)) return -1;
    return _save_file_status(_save_slot_file(_slot));
}

// Returns the room stored in a valid save slot without applying the save.
// Used by the save/load menus to show where the player was when the slot was written.
function save_slot_room(_slot)
{
    if (!_save_slot_valid(_slot)) return -1;
    var _file = _save_slot_file(_slot);
    if (_save_file_status(_file) < 1) return -1;

    ini_open(_file);
    var _room_name = ini_read_string("save", "room", "");
    ini_close();
    return _save_room_from_name(_room_name);
}

function save_slots_migrate_legacy()
{
    if (!file_exists(YP_SAVE_LEGACY)) return false;
    if (_save_file_status(YP_SAVE_LEGACY) < 1) return false;

    var _slot_one = _save_slot_file(1);
    if (file_exists(_slot_one)) return false;

    file_copy(YP_SAVE_LEGACY, _slot_one);
    if (_save_file_status(_slot_one) >= 1) return true;

    if (file_exists(_slot_one)) file_delete(_slot_one);
    return false;
}

function save_exists(_slot = -1)
{
    save_slots_migrate_legacy();

    if (_slot != -1)
        return _save_slot_valid(_slot) && save_slot_status(_slot) >= 1;

    for (var _i = YP_SAVE_SLOT_MIN; _i <= YP_SAVE_SLOT_MAX; _i++)
        if (save_slot_status(_i) >= 1) return true;

    return false;
}

function _save_clear_runtime_load()
{
    global.load_pending = false;
    global.checkpoint_respawn_pending = false;
    global.save_notice_key = "";
    global.save_notice_timer = 0;

    global.spawn_from_tag = "";
    global.spawn_x_manual = -1;
    global.spawn_y_manual = -1;
    global.came_from_room = -1;
}

// Uses the player's current collision box offsets, but tests them at a candidate point.
// obj_platform is the parent for normal and thin platforms, so children are covered too.
function player_position_is_safe(_player, _x, _y)
{
    if (!instance_exists(_player)) return false;
    if (!is_real(_x) || !is_real(_y) || is_nan(_x) || is_nan(_y)) return false;

    var _left   = _x + (_player.bbox_left   - _player.x);
    var _right  = _x + (_player.bbox_right  - _player.x);
    var _top    = _y + (_player.bbox_top    - _player.y);
    var _bottom = _y + (_player.bbox_bottom - _player.y);

    if (_left < 0 || _right >= room_width || _top < 0 || _bottom >= room_height) return false;
    return collision_rectangle(_left, _top, _right, _bottom, obj_platform, false, false) == noone;
}

function player_find_safe_position(_player, _x, _y)
{
    if (!instance_exists(_player)) return [false, _x, _y];

    _x = clamp(_x, 0, room_width);
    _y = clamp(_y, 0, room_height);
    if (player_position_is_safe(_player, _x, _y)) return [true, _x, _y];

    // Prefer moving sideways/upward so recovery does not bury the player in the floor.
    for (var _radius = 8; _radius <= 192; _radius += 8)
    {
        var _candidates = [
            [_x + _radius, _y],
            [_x - _radius, _y],
            [_x, _y - _radius],
            [_x + _radius, _y - _radius],
            [_x - _radius, _y - _radius]
        ];

        for (var _i = 0; _i < array_length(_candidates); _i++)
        {
            var _cx = _candidates[_i][0];
            var _cy = _candidates[_i][1];
            if (player_position_is_safe(_player, _cx, _cy)) return [true, _cx, _cy];
        }
    }

    return [false, _x, _y];
}

function player_place_safely(_player, _x, _y)
{
    var _safe = player_find_safe_position(_player, _x, _y);
    if (!_safe[0]) return false;

    _player.x = _safe[1];
    _player.y = _safe[2];
    _player.hspd = 0;
    _player.vspd = 0;
    if (variable_instance_exists(_player, "drop_timer")) _player.drop_timer = 0;
    return true;
}

function start_new_game()
{
    _save_clear_runtime_load();
    world_state_reset();

    global.checkpoint_room = rm_sea_1;
    global.checkpoint_x = 96;
    global.checkpoint_y = 544;
    global.weapon_unlocked = [false, false, false, false, false, false];

    if (instance_exists(obj_ui_controller))
        obj_ui_controller.game_paused = false;

    with (obj_player) instance_destroy();
    room_goto(rm_sea_1);
}


function _save_capture_player(_player)
{
    if (!instance_exists(_player)) return undefined;

    var _weapon_count = array_length(_player.weapon_unlocked);
    var _weapons = array_create(_weapon_count, false);
    for (var _i = 0; _i < _weapon_count; _i++)
        _weapons[_i] = _player.weapon_unlocked[_i];

    return {
        x: _player.x,
        y: _player.y,
        hp: _player.hp,
        max_hp: _player.max_hp,
        current_weapon: _player.current_weapon,
        perm_spd_bonus: _player.perm_spd_bonus,
        potion_heal_count: _player.potion_heal_count,
        potion_strength_count: _player.potion_strength_count,
        potion_speed_count: _player.potion_speed_count,
        has_olympus_key: _player.has_olympus_key,
        l_right: _player.l_right,
        weapon_unlocked: _weapons,
        is_dead: variable_instance_exists(_player, "is_dead") && _player.is_dead,
        save_position_safe: player_position_is_safe(_player, _player.x, _player.y)
    };
}

function _save_write_current(_filename, _player)
{
    world_state_ensure();
    var _weapon_count = array_length(_player.weapon_unlocked);
    var _has_checkpoint = variable_global_exists("checkpoint_room");
    var _world_keys = variable_struct_get_names(global.world_state);

    ini_open(_filename);
    ini_write_real("save", "exists", 1);
    ini_write_real("save", "version", YP_SAVE_VERSION);
    ini_write_string("save", "room", room_get_name(room));

    ini_write_real("player", "x", _player.x);
    ini_write_real("player", "y", _player.y);
    ini_write_real("player", "hp", _player.hp);
    ini_write_real("player", "max_hp", _player.max_hp);
    ini_write_real("player", "current_weapon", _player.current_weapon);
    ini_write_real("player", "perm_spd_bonus", _player.perm_spd_bonus);
    ini_write_real("player", "potion_heal_count", _player.potion_heal_count);
    ini_write_real("player", "potion_strength_count", _player.potion_strength_count);
    ini_write_real("player", "potion_speed_count", _player.potion_speed_count);
    ini_write_real("player", "has_olympus_key", _player.has_olympus_key ? 1 : 0);
    ini_write_real("player", "l_right", _player.l_right ? 1 : 0);

    ini_write_real("weapons", "count", _weapon_count);
    for (var _i = 0; _i < _weapon_count; _i++)
        ini_write_real("weapons", "weapon_" + string(_i), _player.weapon_unlocked[_i] ? 1 : 0);

    ini_write_real("checkpoint", "exists", _has_checkpoint ? 1 : 0);
    if (_has_checkpoint)
    {
        ini_write_string("checkpoint", "room", room_get_name(global.checkpoint_room));
        ini_write_real("checkpoint", "x", global.checkpoint_x);
        ini_write_real("checkpoint", "y", global.checkpoint_y);
    }

    ini_write_real("world_state", "count", array_length(_world_keys));
    for (var _i = 0; _i < array_length(_world_keys); _i++)
        ini_write_string("world_state", "entry_" + string(_i), _world_keys[_i]);
    ini_close();
}

function save_game(_slot = 1, _notify = true, _snapshot = undefined)
{
    if (!_save_slot_valid(_slot))
    {
        if (_notify) _save_notify("save_failed", 180);
        return false;
    }

    // During pause gameplay instances are deactivated. GameMaker does not make a
    // reactivated instance active until the current event ends, so pause saves use
    // a snapshot captured immediately before deactivation instead of toggling actors.
    var _player = _snapshot;
    if (!is_struct(_player))
    {
        if (!instance_exists(obj_player))
        {
            if (_notify) _save_notify("save_failed", 180);
            return false;
        }
        _player = _save_capture_player(instance_find(obj_player, 0));
    }

    if (!is_struct(_player))
    {
        if (_notify) _save_notify("save_failed", 180);
        return false;
    }

    if (_player.is_dead || !_player.save_position_safe)
    {
        if (_notify) _save_notify("save_unsafe_position", 240);
        return false;
    }

    var _file = _save_slot_file(_slot);
    var _temp = _save_slot_temp(_slot);
    var _backup = _save_slot_backup(_slot);

    if (file_exists(_temp)) file_delete(_temp);
    _save_write_current(_temp, _player);
    if (_save_file_status(_temp) != YP_SAVE_VERSION)
    {
        if (file_exists(_temp)) file_delete(_temp);
        if (_notify) _save_notify("save_failed", 180);
        return false;
    }

    if (file_exists(_backup)) file_delete(_backup);
    if (file_exists(_file)) file_copy(_file, _backup);
    if (file_exists(_file)) file_delete(_file);
    file_copy(_temp, _file);
    file_delete(_temp);

    if (_save_file_status(_file) != YP_SAVE_VERSION)
    {
        if (file_exists(_file)) file_delete(_file);
        if (file_exists(_backup)) file_copy(_backup, _file);
        if (_notify) _save_notify("save_failed", 180);
        return false;
    }

    if (_notify) _save_notify(_slot == 0 ? "autosave_done" : "save_done", 180);
    return true;
}

function autosave_game()
{
    return save_game(0, false);
}

function load_game(_slot = 1)
{
    if (!_save_slot_valid(_slot))
    {
        _save_notify("load_missing", 180);
        return false;
    }

    save_slots_migrate_legacy();
    var _file = _save_slot_file(_slot);
    var _status = _save_file_status(_file);
    if (_status == 0)
    {
        _save_notify("load_missing", 180);
        return false;
    }
    if (_status == -2)
    {
        _save_notify("load_incompatible", 240);
        return false;
    }
    if (_status < 1)
    {
        _save_notify("load_corrupt", 240);
        return false;
    }

    ini_open(_file);
    var _room_name = ini_read_string("save", "room", "");
    var _target_room = _save_room_from_name(_room_name);
    var _load_x = _save_real("player", "x", 96, 0, 100000);
    var _load_y = _save_real("player", "y", 544, 0, 100000);
    var _max_hp = floor(_save_real("player", "max_hp", 5, 1, 999));
    var _hp = floor(_save_real("player", "hp", _max_hp, 1, _max_hp));
    var _current_weapon = floor(_save_real("player", "current_weapon", -1, -1, 5));
    var _perm_spd = _save_real("player", "perm_spd_bonus", 0, 0, 100);
    var _heal = floor(_save_real("player", "potion_heal_count", 0, 0, 999));
    var _strength = floor(_save_real("player", "potion_strength_count", 0, 0, 999));
    var _speed = floor(_save_real("player", "potion_speed_count", 0, 0, 999));
    var _has_key = (ini_read_real("player", "has_olympus_key", 0) == 1);
    var _right = (ini_read_real("player", "l_right", 1) == 1);

    var _weapon_count = floor(ini_read_real("weapons", "count", -1));
    var _corrupt = (_weapon_count < 0 || _weapon_count > 6);
    _weapon_count = clamp(_weapon_count, 0, 6);
    var _weapons = array_create(6, false);
    for (var _i = 0; _i < _weapon_count; _i++)
        _weapons[_i] = (ini_read_real("weapons", "weapon_" + string(_i), 0) == 1);

    var _checkpoint_exists = (ini_read_real("checkpoint", "exists", 0) == 1);
    var _checkpoint_room = _target_room;
    var _checkpoint_x = _load_x;
    var _checkpoint_y = _load_y;
    if (_checkpoint_exists)
    {
        _checkpoint_room = _save_room_from_name(ini_read_string("checkpoint", "room", ""));
        if (_checkpoint_room == -1) _corrupt = true;
        else
        {
            _checkpoint_x = _save_real("checkpoint", "x", _load_x, 0, 100000);
            _checkpoint_y = _save_real("checkpoint", "y", _load_y, 0, 100000);
        }
    }

    var _loaded_world = {};
    if (_status >= 2)
    {
        var _world_count = floor(ini_read_real("world_state", "count", -1));
        if (_world_count < 0 || _world_count > 10000) _corrupt = true;
        else
        {
            for (var _i = 0; _i < _world_count; _i++)
            {
                var _key = ini_read_string("world_state", "entry_" + string(_i), "");
                if (!_world_state_key_valid(_key)) { _corrupt = true; break; }
                variable_struct_set(_loaded_world, _key, true);
            }
        }
    }
    ini_close();

    if (_corrupt)
    {
        _save_notify("load_corrupt", 240);
        return false;
    }

    global.world_state = _loaded_world;
    if (_status == 1) _world_state_migrate_v1(_weapons, _has_key);

    global.load_pending = true;
    global.load_source_slot = _slot;
    global.load_room = _target_room;
    global.load_x = _load_x;
    global.load_y = _load_y;
    global.load_hp = _hp;
    global.load_max_hp = _max_hp;
    global.load_current_weapon = _current_weapon;
    global.load_perm_spd_bonus = _perm_spd;
    global.load_potion_heal_count = _heal;
    global.load_potion_strength_count = _strength;
    global.load_potion_speed_count = _speed;
    global.load_has_olympus_key = _has_key;
    global.load_l_right = _right;
    global.load_weapon_unlocked = _weapons;
    global.load_checkpoint_exists = _checkpoint_exists;
    global.load_checkpoint_room = _checkpoint_room;
    global.load_checkpoint_x = _checkpoint_x;
    global.load_checkpoint_y = _checkpoint_y;

    global.checkpoint_respawn_pending = false;
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
    var _fallback_x = _p.xstart;
    var _fallback_y = _p.ystart;

    var _placed = player_place_safely(_p,
        clamp(global.load_x, 0, room_width),
        clamp(global.load_y, 0, room_height));

    // A save made by an older build can contain a checkpoint/player position in a wall.
    // Recover around that point first, then around the checkpoint, then the room spawn.
    if (!_placed && global.load_checkpoint_exists && global.load_checkpoint_room == room)
        _placed = player_place_safely(_p, global.load_checkpoint_x, global.load_checkpoint_y);
    if (!_placed)
        _placed = player_place_safely(_p, _fallback_x, _fallback_y);
    if (!_placed)
    {
        _p.x = _fallback_x;
        _p.y = _fallback_y;
        _p.hspd = 0;
        _p.vspd = 0;
        show_debug_message("[Save] No collision-free load point was found; using room spawn.");
    }

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

        // Repair bad checkpoint coordinates immediately when their room is loaded.
        if (global.checkpoint_room == room)
        {
            var _safe_checkpoint = player_find_safe_position(_p, global.checkpoint_x, global.checkpoint_y);
            if (_safe_checkpoint[0])
            {
                global.checkpoint_x = _safe_checkpoint[1];
                global.checkpoint_y = _safe_checkpoint[2];
            }
            else
            {
                global.checkpoint_x = _p.x;
                global.checkpoint_y = _p.y;
            }
        }
    }
    else
    {
        global.checkpoint_room = global.load_room;
        global.checkpoint_x = _p.x;
        global.checkpoint_y = _p.y;
    }

    // Rebuild the two throwable weapons independently after load.
    // A save never resumes a mid-flight/stuck projectile; both unlocked items
    // safely return to the player's hand.
    if (variable_instance_exists(_p, "throwable_instances"))
    {
        _p.throwable_instances[0] = noone;
        _p.throwable_instances[1] = noone;

        var _throw_count = instance_number(obj_trident);
        for (var _ti = _throw_count - 1; _ti >= 0; _ti--)
        {
            var _old_throwable = instance_find(obj_trident, _ti);
            if (instance_exists(_old_throwable)) instance_destroy(_old_throwable);
        }

        var _platform_count = instance_number(obj_trident_platform);
        for (var _pi = _platform_count - 1; _pi >= 0; _pi--)
        {
            var _old_platform = instance_find(obj_trident_platform, _pi);
            if (instance_exists(_old_platform)) instance_destroy(_old_platform);
        }

        for (var _wi = 0; _wi < 2; _wi++)
        {
            if (_p.weapon_unlocked[_wi])
            {
                var _throwable = _p._find_throwable(_wi, true);
                if (instance_exists(_throwable))
                {
                    _throwable.x = _p.x;
                    _throwable.y = _p.y;
                    _throwable.thrown = false;
                    _throwable.stuck = false;
                    _throwable.timer = 0;
                    _throwable.image_angle = 0;
                    _throwable.platform_instance = noone;
                    _throwable.damage = _p.weapon_atk[_wi];
                    _throwable.visual_weapon = _wi;
                }
            }
        }

        if (_p.current_weapon >= 0 && _p.current_weapon <= 1)
            _p.trident_instance = _p._find_throwable(_p.current_weapon, false);
        else
            _p.trident_instance = noone;
    }

    global.load_pending = false;
    _p._reset_player_animation();
    _save_notify("load_done", 180);
    return true;
}

function apply_pending_checkpoint_respawn_to_player()
{
    if (!variable_global_exists("checkpoint_respawn_pending") || !global.checkpoint_respawn_pending) return false;
    if (!instance_exists(obj_player) || !variable_global_exists("checkpoint_room")) return false;
    if (global.checkpoint_room != room) return false;

    var _p = instance_find(obj_player, 0);
    var _placed = player_place_safely(_p, global.checkpoint_x, global.checkpoint_y);
    if (!_placed) _placed = player_place_safely(_p, _p.xstart, _p.ystart);
    if (!_placed)
    {
        _p.x = _p.xstart;
        _p.y = _p.ystart;
        _p.hspd = 0;
        _p.vspd = 0;
    }

    global.checkpoint_x = _p.x;
    global.checkpoint_y = _p.y;
    global.checkpoint_respawn_pending = false;
    _p._reset_player_animation();
    return true;
}
