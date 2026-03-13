/// @description 
// obj_player Create Event

// Базові характеристики
hp = 5; // Початкове здоров'я
max_hp = 5; // Максимальне здоров'я (для амброзії)

// Інвентар зілля
potion_heal_count = 0;
potion_strength_count = 0;
potion_speed_count = 0;

// Бонуси та бафи
perm_spd_bonus = 0; // Перманентний бонус до швидкості (сандалі)
temp_spd_buff = 0;  // Тимчасовий бонус до швидкості (зілля Гермеса)
temp_atk_buff = 0;  // Тимчасовий бонус до атаки (зілля Геракла)
buff_duration = 0;  // Таймер для тимчасових бафів

// Рух та фізика
spd = 1; // Базова швидкість руху
grv = 0.3;
vspd = 0;
l_right = true;
l_left = false;

// Зброя та стан
current_weapon = 0; // Поточна зброя (0 = Тризубець)
trident_instance = noone; // Зберігатиме ID активного тризубця

// Стан гравця
is_damage = false; // Флаг отримання шкоди (для невразливості)
// Анімація
image_speed = 0.15; // Швидкість анімації
animation_index = 0; // Поточний кадр
is_jumping = false; // Чи в польоті