/// @description Базова ініціалізація предмету для підбору
// obj_pickup Create Event

can_pickup   = false;           // Вимкнено на старті щоб уникнути миттєвого підбору
alarm[0]     = room_speed / 3;  // Через 0.33 секунди дозволяємо підбір
bob_offset   = random(pi * 2);  // Рандомний зсув для анімації "гойдання"
if (world_state_restore_instance(id, "pickup")) exit;
