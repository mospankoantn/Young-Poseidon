#macro YP_SETTINGS_FILE "young_poseidon_settings.ini"

function yp_defaults() {
    return {master:1, music:0.7, sfx:1, resolution:0, fullscreen:false,
        vsync:true, smoothing:false, auto_pause:true, hints:true, language:"UA",
        keys:[65,68,87,83,69,70,81,90,88,67], first_run_completed:false};
}

function yp_settings_init() {
    if (variable_global_exists("yp_settings")) return;
    global.yp_modes = [[960,640],[1280,720],[1366,768],[1600,900],[1920,1080],[2560,1440]];
    global.yp_display_wait = -1;
    global.yp_display_pending = false;
    global.yp_display_previous = undefined;
    global.yp_display_deadline = 0;
    global.yp_startup_sequence_done = false;
    global.yp_settings = yp_defaults();
    yp_settings_read();
    display_set_gui_size(960,640);
    window_set_caption("Young Poseidon");
    yp_apply_audio();
    yp_apply_display();
}

function yp_settings_read() {
    var _s = yp_defaults();
    // Migrate only the language from the existing game save.
    ini_open("young_poseidon_save.ini");
    _s.language = ini_read_string("settings","language","UA");
    ini_close();
    ini_open(YP_SETTINGS_FILE);
    var _numeric = ["master","music","sfx","resolution","fullscreen","vsync","smoothing","auto_pause","hints"];
    for (var _i=0; _i<array_length(_numeric); _i++) {
        var _key = _numeric[_i];
        var _v = ini_read_real("options",_key,variable_struct_get(_s,_key));
        if (is_nan(_v) || is_infinity(_v)) _v = variable_struct_get(_s,_key);
        if (_i<3) _v = clamp(_v,0,1);
        else if (_key == "resolution") _v = clamp(round(_v),0,array_length(global.yp_modes)-1);
        else _v = (_v == 1);
        variable_struct_set(_s,_key,_v);
    }
    _s.language = ini_read_string("options","language",_s.language);
    if (_s.language != "UA" && _s.language != "EN") _s.language = "UA";
    _s.first_run_completed = (ini_read_real("meta","first_run_completed",0) == 1);
    var _valid = true;
    for (var _i=0; _i<10; _i++) {
        var _key = ini_read_real("keys",string(_i),_s.keys[_i]);
        if (is_nan(_key) || is_infinity(_key) || _key<65 || _key>90 || _key != floor(_key)) _valid=false;
        for (var _j=0; _j<_i; _j++) if (_s.keys[_j] == _key) _valid=false;
        _s.keys[_i] = _key;
    }
    if (!_valid) {
        var _defaults=yp_defaults();
        _s.keys=_defaults.keys;
    }
    ini_close();
    global.yp_settings = _s;
    global.lang = _s.language;
}

function yp_settings_save() {
    var _s = global.yp_settings;
    var _fields = ["master","music","sfx","resolution","fullscreen","vsync","smoothing","auto_pause","hints"];
    ini_open(YP_SETTINGS_FILE);
    for (var _i=0; _i<array_length(_fields); _i++) {
        var _key = _fields[_i];
        var _source = _s;
        // Do not persist an unconfirmed display mode, even when changing language/audio.
        if (global.yp_display_pending && (_key=="resolution" || _key=="fullscreen" || _key=="vsync"))
            _source = global.yp_display_previous;
        ini_write_real("options",_key,variable_struct_get(_source,_key));
    }
    ini_write_string("options","language",_s.language);
    ini_write_real("meta","first_run_completed", _s.first_run_completed ? 1 : 0);
    for (var _i=0; _i<10; _i++) ini_write_real("keys",string(_i),_s.keys[_i]);
    ini_close();
}

function yp_apply_audio() {
    var _s = global.yp_settings;
    audio_master_gain(_s.master);
    audio_sound_gain(snd_olympus_overture,_s.music,0);
    audio_sound_gain(snd_jump,_s.sfx,0);
    audio_sound_gain(snd_swing,_s.sfx,0);
    audio_sound_gain(snd_startup_jingle,max(_s.music,_s.sfx) * 0.55,0);
    if (variable_global_exists("zone_music_voice") && audio_is_playing(global.zone_music_voice))
        audio_sound_gain(global.zone_music_voice, _s.music * 0.55, 150);
    var _effects = ["enemy_hit","boss_hit","enemy_death","boss_death","attack","pickup","reward",
        "potion","button","stone","checkpoint","door","player_hurt","wind","water","fire","drip","wisp"];
    for (var _i = 0; _i < array_length(_effects); _i++)
    {
        var _asset = asset_get_index("snd_fx_" + _effects[_i]);
        if (_asset != -1) audio_sound_gain(_asset, _s.sfx * 0.5, 0);
    }
}

function yp_zone_id()
{
    var _parts = string_split(room_get_name(room), "_");
    return array_length(_parts) >= 3 ? _parts[1] : "";
}

function yp_sfx(_name, _x = -1)
{
    var _sound = asset_get_index("snd_fx_" + _name);
    if (_sound == -1) return -1;
    if (!variable_global_exists("sfx_last")) global.sfx_last = {};
    if (variable_struct_exists(global.sfx_last, _name)
        && current_time - variable_struct_get(global.sfx_last, _name) < 65) return -1;
    variable_struct_set(global.sfx_last, _name, current_time);
    var _voice = audio_play_sound(_sound, 2, false);
    var _volume = variable_global_exists("yp_settings") ? global.yp_settings.sfx : 1;
    if (_x >= 0 && instance_exists(obj_player))
        _volume *= clamp(1 - abs(_x - obj_player.x) / 1400, 0.15, 1);
    audio_sound_gain(_voice, _volume * 0.5, 0);
    return _voice;
}

function yp_zone_audio_start()
{
    yp_settings_init();
    var _asset = asset_get_index("snd_zone_" + yp_zone_id());
    if (!variable_global_exists("zone_music_asset")) global.zone_music_asset = -1;
    if (!variable_global_exists("zone_music_voice")) global.zone_music_voice = -1;
    if (_asset == global.zone_music_asset && audio_is_playing(global.zone_music_voice)) return;
    if (audio_is_playing(global.zone_music_voice)) audio_stop_sound(global.zone_music_voice);
    global.zone_music_asset = _asset;
    global.zone_music_voice = -1;
    if (_asset == -1) return;
    audio_stop_sound(snd_olympus_overture);
    global.zone_music_voice = audio_play_sound(_asset, 5, true);
    audio_sound_gain(global.zone_music_voice, 0, 0);
    audio_sound_gain(global.zone_music_voice, global.yp_settings.music * 0.55, 800);
}

function yp_apply_display() {
    var _s = global.yp_settings;
    global.yp_display_recovery_frames = 120;
    gpu_set_texfilter(_s.smoothing);
    display_reset(0,_s.vsync);
    window_set_fullscreen(_s.fullscreen);
    // The runner needs ten steps after leaving fullscreen before window resizing.
    global.yp_display_wait = 12;
}

function yp_display_tick() {
    if (global.yp_display_wait > 0) global.yp_display_wait--;
    if (global.yp_display_wait == 0) {
        global.yp_display_wait = -1;
        if (!global.yp_settings.fullscreen) {
            var _mode = global.yp_modes[global.yp_settings.resolution];
            var _scale = min(1,min((display_get_width()-48)/_mode[0],(display_get_height()-100)/_mode[1]));
            window_set_size(round(_mode[0]*_scale),round(_mode[1]*_scale));
            window_center();
        }
    }
    if (global.yp_display_pending && current_time >= global.yp_display_deadline) yp_display_finish(false);
}

function yp_display_begin(_resolution,_fullscreen,_vsync) {
    if (global.yp_display_pending) return;
    var _s = global.yp_settings;
    global.yp_display_previous = {resolution:_s.resolution,fullscreen:_s.fullscreen,vsync:_s.vsync};
    _s.resolution=_resolution; _s.fullscreen=_fullscreen; _s.vsync=_vsync;
    global.yp_display_pending=true;
    global.yp_display_deadline=current_time+15000;
    yp_apply_display();
}

function yp_display_finish(_keep) {
    if (!global.yp_display_pending) return;
    global.yp_display_pending=false;
    if (!_keep) {
        var _old=global.yp_display_previous;
        global.yp_settings.resolution=_old.resolution;
        global.yp_settings.fullscreen=_old.fullscreen;
        global.yp_settings.vsync=_old.vsync;
        yp_apply_display();
    }
    yp_settings_save();
}

function yp_key_index(_letter) { return string_pos(_letter,"ADWSEFQZXC")-1; }
function yp_key_name(_letter) {
    if (!variable_global_exists("yp_settings")) return _letter;
    var _i=yp_key_index(_letter);
    return _i<0 ? _letter : chr(global.yp_settings.keys[_i]);
}
function yp_input(_letter,_pressed) {
    var _i=yp_key_index(_letter);
    var _key=ord(_letter);
    if (_i>=0 && variable_global_exists("yp_settings")) _key=global.yp_settings.keys[_i];
    return _pressed ? keyboard_check_pressed(_key) : keyboard_check(_key);
}
function yp_text(_ua,_en) { return global.lang == "UA" ? _ua : _en; }
