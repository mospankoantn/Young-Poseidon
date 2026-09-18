/// @description 
/// obj_interactive_button — Create Event

// ---- НАЛАШТУВАННЯ ----
// Ці змінні встановлюються вручну в кожній кімнаті через
// Instance Creation Code або через редактор змінних.
 
// ID цільового об'єкта або групи (що активувати)
// Наприклад: target_id = obj_falling_rocks_group_1
target_object = obj_falling_rocks;   // Що активується при натисканні
 
// Кожне натискання в арені Тритона кидає один камінь, тому кнопку можна повторювати.
one_time_use  = false;
is_pressed    = false;   // Вже натиснута?
 
// Відстань від гравця для підказки "Натисни E"
interact_range = 60;
 
// ---- ВІЗУАЛ ----
// Кнопка має два стани спрайту:
// image_index = 0 → не натиснута (вгорі)
// image_index = 1 → натиснута (внизу)
image_index  = 0;
image_speed  = 0;   // Керуємо кадрами вручну
