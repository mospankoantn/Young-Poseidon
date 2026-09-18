/// @description Викликається при знищенні або виході з гри
// obj_lang_manager — Cleanup Event

// Очищаємо словник з пам'яті
if (skip_cleanup) exit;

if (variable_global_exists("lang_db") && ds_exists(global.lang_db, ds_type_map))
    ds_map_destroy(global.lang_db);
