/// @description Скріпти менеджера мови 
/// scr_lang_manager 

/// Script: lc(key) ГЛОБАЛЬНИЙ ПЕРЕКЛАД
/// @param {string} key  Ключ зі словника
/// @returns {string}    Рядок поточної мови

function lc(_key)
{
    // Якщо словник не існує — повертаємо ключ як заглушку
    if (!variable_global_exists("lang_db")
        || !ds_exists(global.lang_db, ds_type_map))
        return _key;
 
    if (!ds_map_exists(global.lang_db, _key))
    {
        // Ключ не знайдено — попередження і повернення ключа
        show_debug_message("lc(): KEY NOT FOUND — " + _key);
        return "[" + _key + "]";
    }
 
    var _arr   = global.lang_db[? _key];
    var _index = (global.lang == "UA") ? 0 : 1;
 
    return _arr[_index];
}
 
 
// Додаткова версія з підстановкою змінних:
// lc_format("buff_atk") + string(value) + lc("buff_atk_label") + ...
// Використання: draw_text(x, y, lc("hud_atk") + ": " + string(_atk));

/// @description Script: set_language(lang)
/// @param {string} lang  "UA" або "EN"

function set_language(_lang)
{
    global.lang = _lang;
 
    // Зберігаємо вибір у файлі
    ini_open("young_poseidon_save.ini");
    ini_write_string("settings", "language", _lang);
    ini_close();
 
    // Оновлюємо масиви зброї у гравця якщо він існує
    if (instance_exists(obj_player))
        _update_player_weapon_names();
}

/// @description Script: _update_player_weapon_names()
// Оновлює масив weapon_names у гравця після зміни мови

function _update_player_weapon_names()
{
    if (!instance_exists(obj_player)) exit;
    with (obj_player)
    {
        weapon_names = [
            lc("weapon_trident"),
            lc("weapon_spear"),
            lc("weapon_pickaxe"),
            lc("weapon_scythe"),
            lc("weapon_oar"),
            lc("weapon_sword")
        ];
    }
}
