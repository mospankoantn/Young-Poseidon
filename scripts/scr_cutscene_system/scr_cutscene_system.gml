/// @description Central cutscene and contextual tutorial system.

function _cutscene_page(_sprite, _category_key, _title_key, _body_key)
{
    return {
        sprite: _sprite,
        category_key: _category_key,
        title_key: _title_key,
        body_key: _body_key
    };
}

function show_cutscene(_pages, _close_action, _state_key)
{
    if (!is_array(_pages) || array_length(_pages) <= 0) return noone;
    if (is_undefined(_state_key)) _state_key = "";

    if (_state_key != "" && world_state_has(_state_key)) return noone;

    // Never stack modal cutscenes on top of each other.
    if (instance_exists(obj_cutscene_screen)) return instance_find(obj_cutscene_screen, 0);

    global.cutscene_active = true;

    var _screen = instance_create_depth(0, 0, -10000, obj_cutscene_screen);
    _screen.pages = _pages;
    _screen.page_index = 0;
    _screen.close_action = _close_action;
    _screen.state_key = _state_key;
    _screen.accept_delay = 12;
    return _screen;
}

function show_intro_cutscene()
{
    var _pages = [
        _cutscene_page(spr_cutscene_intro, "cutscene_intro_category", "cutscene_intro_title", "cutscene_intro_body_1"),
        _cutscene_page(spr_cutscene_intro, "cutscene_intro_category", "cutscene_intro_zeus_title", "cutscene_intro_body_2")
    ];
    return show_cutscene(_pages, "start_game", "cutscene_v2_intro");
}

function show_outro_cutscene()
{
    if (world_state_has("cutscene_v2_outro")) return noone;
    if (instance_exists(obj_cutscene_screen)) return noone;

    var _pages = [
        _cutscene_page(spr_cutscene_outro, "cutscene_outro_category", "cutscene_outro_title", "cutscene_outro_body"),
        _cutscene_page(spr_cutscene_outro, "cutscene_credits_category", "cutscene_journey_title", "cutscene_journey_body"),
        _cutscene_page(spr_cutscene_outro, "cutscene_credits_category", "cutscene_credits_title", "cutscene_credits_body")
    ];
    return show_cutscene(_pages, "main_menu", "cutscene_v2_outro");
}

function _cutscene_biome_sprite(_zone_name)
{
    switch (_zone_name)
    {
        case "sea": return spr_cutscene_sea;
        case "coast": return spr_cutscene_coast;
        case "mines": return spr_cutscene_mines;
        case "hades": return spr_cutscene_hades;
        case "greece": return spr_cutscene_greece;
        case "battlefield": return spr_cutscene_battlefield;
        case "olympus": return spr_cutscene_olympus;
    }
    return -1;
}

function show_biome_cutscene(_zone_name)
{
    var _state_key = "cutscene_v2_biome_" + _zone_name;
    if (world_state_has(_state_key)) return noone;
    if (instance_exists(obj_cutscene_screen)) return noone;

    var _spr = _cutscene_biome_sprite(_zone_name);
    if (_spr < 0) return noone;

    var _pages = [
        _cutscene_page(_spr, "cutscene_biome_category", "cutscene_biome_" + _zone_name + "_title", "cutscene_biome_" + _zone_name + "_body")
    ];
    return show_cutscene(_pages, "resume", _state_key);
}

function _cutscene_weapon_sprite(_weapon_name)
{
    switch (_weapon_name)
    {
        case "trident": return spr_cutscene_trident;
        case "spear": return spr_cutscene_spear;
        case "pickaxe": return spr_cutscene_pickaxe;
        case "scythe": return spr_cutscene_scythe;
        case "oar": return spr_cutscene_oar;
        case "sword": return spr_cutscene_sword;
        case "key": return spr_cutscene_key;
    }
    return -1;
}

function show_weapon_cutscene(_weapon_name)
{
    var _state_key = "cutscene_v2_weapon_" + _weapon_name;
    if (world_state_has(_state_key)) return noone;
    if (instance_exists(obj_cutscene_screen)) return noone;

    var _spr = _cutscene_weapon_sprite(_weapon_name);
    if (_spr < 0) return noone;

    var _pages = [
        _cutscene_page(_spr, "cutscene_reward_category", "cutscene_weapon_" + _weapon_name + "_title", "cutscene_weapon_" + _weapon_name + "_body")
    ];
    return show_cutscene(_pages, "resume", _state_key);
}

/// @description Show a contextual hint once per save/world state.
/// @param {string} _hint_id Persistent id without the `hint_` prefix.
/// @param {string} _lang_key Localization key.
/// @param {real} _duration Duration in frames.
function yp_trigger_hint(_hint_id, _lang_key, _duration)
{
    var _state_key = "hint_" + _hint_id;
    if (world_state_has(_state_key)) return false;

    if (variable_global_exists("cutscene_active") && global.cutscene_active)
        return false;

    // If gameplay hints are disabled in Settings, do not consume the one-time
    // world-state flag. Re-enabling hints later should still allow them to appear.
    if (variable_global_exists("yp_settings")
        && variable_struct_exists(global.yp_settings, "hints")
        && !global.yp_settings.hints)
        return false;

    if (!instance_exists(obj_ui_controller)) return false;
    var _ui = instance_find(obj_ui_controller, 0);
    if (!instance_exists(_ui) || !variable_instance_exists(_ui, "show_hint")) return false;
    if (variable_instance_exists(_ui, "game_paused") && _ui.game_paused) return false;

    world_state_mark(_state_key);
    _ui.show_hint(lc(_lang_key), _duration);
    return true;
}
