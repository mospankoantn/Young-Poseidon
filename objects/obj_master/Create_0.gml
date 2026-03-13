/// @description 
// obj_master Create Event

/// @description Ініціалізація глобальних даних (зброя, чекпоінт і т.д.)

// --- Ініціалізація Чекпоінта --- 
// Це краще робити при активації чекпоінта, а не тут.
// Але якщо obj_master створюється разом з гравцем на старті, можна зробити так:
// if (instance_exists(obj_player)) {
//     global.checkpoint_x = obj_player.xstart; // Використовуємо стартову позицію
//     global.checkpoint_y = obj_player.ystart;
// } else {
//     // Запасний варіант, якщо гравець створюється пізніше
//     global.checkpoint_x = xstart; 
//     global.checkpoint_y = ystart;
// }


// --- Ініціалізація Даних Зброї --- 
// Перевіряємо, чи дані вже ініціалізовані (оскільки об'єкт persistent)
var _weapon_data_initialized = false;
if (variable_global_exists("weapon_data")) 
{
    // Якщо змінна існує, перевіримо, чи це карта і чи вона містить дані тризубця
    if (ds_exists(global.weapon_data, ds_type_map) && ds_map_exists(global.weapon_data, "Trident")) 
	{
         _weapon_data_initialized = true;
    } 
	else if (ds_exists(global.weapon_data, ds_type_map)) 
	{
         // Якщо це карта, але без даних тризубця, знищимо її, щоб створити заново
         ds_map_destroy(global.weapon_data);
    } 
	// Якщо існує, але не карта, нічого не робимо, вона буде перезаписана нижче
}


if (!_weapon_data_initialized) 
{
    show_debug_message("Initializing global.weapon_data..."); // Для відладки
    global.weapon_data = ds_map_create(); // Створюємо головну карту

    // Додаємо дані для Тризубця
    var _trident_data = ds_map_create();
    _trident_data[? "name"] = "Trident";
    _trident_data[? "damage"] = 1; // Базова шкода тризубця
    // _trident_data[? "throw_speed"] = 10; // Можна додати специфічні параметри
    // _trident_data[? "throw_duration"] = room_speed * 1.5;
    ds_map_add_map(global.weapon_data, "Trident", _trident_data); // Додаємо під-карту

    // Додати інші види зброї аналогічно...
	
} 
else 
{
     show_debug_message("global.weapon_data already initialized."); // Для відладки
}


// --- Знищення ds_map при завершенні гри --- 
// Важливо додати подію Game End або Clean Up для obj_master, щоб звільнити пам'ять
/*
// В події Clean Up або Game End:
if (variable_global_exists("weapon_data") && ds_exists(global.weapon_data, ds_type_map))
{
    // Потрібно пройтись по всіх вкладених картах і знищити їх
    var _key = ds_map_find_first(global.weapon_data);
    while (!is_undefined(_key))
    {
        var _weapon_map = global.weapon_data[? _key];
        if (ds_exists(_weapon_map, ds_type_map)) { 
             ds_map_destroy(_weapon_map);
        }
        _key = ds_map_find_next(global.weapon_data, _key);
    }
    // Знищити головну карту
    ds_map_destroy(global.weapon_data);
    show_debug_message("Cleaned up global.weapon_data.");
}
*/