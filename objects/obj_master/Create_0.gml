/// @description Глобальний менеджер гри. Об'єкт persistent (не знищується між кімнатами).
// obj_master Create Event

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