/// @description
/// obj_pickup_weapon_base — Create Event

// Ця змінна ПЕРЕВИЗНАЧАЄТЬСЯ у кожному нащадку
weapon_index  = -1;         // Яку зброю розблоковує (-1 = ключ)
weapon_label  = "???";      // Назва для підказки
 
can_pickup    = false;
alarm[0]      = room_speed * 0.5;  // Невелика затримка перед підбором
 
// Левітація
bob_offset    = 0;
base_y        = y;
 
// Сяяння
glow_radius   = 40;
 
// Чи це ключ (не зброя)?
is_key        = false;