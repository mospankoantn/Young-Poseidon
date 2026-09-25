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
press_pulse = 0;
press_button = function() {
    if(is_pressed) return false;
    var _ok=false;
    if(target_object==obj_falling_rocks) {
        if(instance_exists(obj_boss_triton)) _ok=obj_boss_triton._activate_next_rock();
    } else if(instance_exists(target_object)) {
        with(target_object) event_user(0);
        _ok=true;
    }
    if(!_ok) return false;
    press_pulse = 18;
    yp_sfx("button", x);
    if (instance_exists(obj_player)) obj_player._interact_pose(x);
    is_pressed=true;image_index=1;
    if(one_time_use) world_state_mark_instance(id,"activated");
    if(!one_time_use) alarm[0]=max(1,round(room_speed*0.25));
    return true;
};
