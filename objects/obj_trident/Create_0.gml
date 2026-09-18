/// @description
/// obj_trident Create Event

// ---- ХАРАКТЕРИСТИКИ ----
damage           = 1;               // Базова шкода (без бонусів)
fly_speed        = 12;              // Швидкість польоту (НЕ "speed" — вбудована змінна!)
flight_duration  = room_speed * 2;  // Максимальний час польоту (2 секунди)
 
// ---- СТАН ----
thrown        = false;   // Зараз летить?
stuck         = false;   // Застряг у стіні?
invisible_time= false;   // Короткочасне ігнорування зіткнень після повернення
timer         = 0;       // Лічильник кадрів польоту
 
// Вимикаємо вбудовану фізику GameMaker щоб не заважала нашому ручному руху
friction    = 0;
gravity     = 0;
visual_weapon = 0;
