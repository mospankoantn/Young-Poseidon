/// @description Глобальний менеджер гри. Об'єкт persistent (не знищується між кімнатами).
// obj_master Create Event

skip_cleanup = false;

if (instance_number(obj_master) > 1)
{
    skip_cleanup = true;
    instance_destroy();
    exit;
}

// Ініціалізуємо глобальні змінні тільки один раз
if (!variable_global_exists("game_initialized"))
{
    global.game_initialized = true;
 
    // ---- ЗБРОЯ ГРАВЦЯ ----
    // Масив true/false: чи розблокована зброя
    // Індекси: 0=Тризубець, 1=Спис, 2=Кайло, 3=Коса, 4=Весло, 5=Меч
    global.weapon_unlocked = [true, false, false, false, false, false];
 
    // ---- СТАТИСТИКА (опціонально) ----
    global.enemies_killed = 0;
    global.deaths         = 0;
 
    show_debug_message("[Master] Global variables initialized.");
}

// Spawn-дані для переходів між кімнатами
global.spawn_from_tag  = "";
global.spawn_x_manual  = -1;
global.spawn_y_manual  = -1;
global.came_from_room  = -1;
 
// Назви кімнат для підказок переходу
if (variable_global_exists("room_names") && ds_exists(global.room_names, ds_type_map))
    ds_map_destroy(global.room_names);

global.room_names      = ds_map_create();
ds_map_add(global.room_names, rm_sea_1,        "Море — 1");
ds_map_add(global.room_names, rm_sea_2,        "Море — 2");
ds_map_add(global.room_names, rm_sea_3,        "Море — 3 (Бос)");
ds_map_add(global.room_names, rm_sea_4,        "Море — 4");
ds_map_add(global.room_names, rm_sea_5,        "Море — 5");
ds_map_add(global.room_names, rm_coast_1,      "Узбережжя — 1");
ds_map_add(global.room_names, rm_coast_2,      "Узбережжя — 2");
ds_map_add(global.room_names, rm_coast_3,      "Узбережжя — 3");
ds_map_add(global.room_names, rm_coast_4,      "Узбережжя — 4");
ds_map_add(global.room_names, rm_coast_5,      "Узбережжя — 5 (Бос)");
ds_map_add(global.room_names, rm_mines_1,      "Шахти — 1");
ds_map_add(global.room_names, rm_mines_2,      "Шахти — 2");
ds_map_add(global.room_names, rm_mines_3,      "Шахти — 3");
ds_map_add(global.room_names, rm_mines_4,      "Шахти — 4 (Бос)");
ds_map_add(global.room_names, rm_mines_5,      "Шахти — 5");
ds_map_add(global.room_names, rm_hades_1,      "Аїд — 1");
ds_map_add(global.room_names, rm_hades_2,      "Аїд — 2");
ds_map_add(global.room_names, rm_hades_3,      "Аїд — 3");
ds_map_add(global.room_names, rm_hades_4,      "Аїд — 4");
ds_map_add(global.room_names, rm_hades_5,      "Аїд — 5 (Бос)");
ds_map_add(global.room_names, rm_greece_1,     "Греція — 1");
ds_map_add(global.room_names, rm_greece_2,     "Греція — 2");
ds_map_add(global.room_names, rm_greece_3,     "Греція — 3");
ds_map_add(global.room_names, rm_greece_4,     "Греція — 4 (Бос)");
ds_map_add(global.room_names, rm_greece_5,     "Греція — 5");
ds_map_add(global.room_names, rm_battlefield_1,"Поле Битви — 1");
ds_map_add(global.room_names, rm_battlefield_2,"Поле Битви — 2");
ds_map_add(global.room_names, rm_battlefield_3,"Поле Битви — 3");
ds_map_add(global.room_names, rm_battlefield_4,"Поле Битви — 4");
ds_map_add(global.room_names, rm_battlefield_5,"Поле Битви — 5 (Бос)");
ds_map_add(global.room_names, rm_olympus_1,    "Олімп — 1");
ds_map_add(global.room_names, rm_olympus_2,    "Олімп — 2");
ds_map_add(global.room_names, rm_olympus_3,    "Олімп — 3");
ds_map_add(global.room_names, rm_olympus_4,    "Олімп — 4");
ds_map_add(global.room_names, rm_olympus_5,    "Олімп — 5 (Фінал)");
