/// @description Базова ініціалізація предмету для підбору
// obj_pickup Create Event

//pickup_sound = snd_pickup; // Звук підбору (переконайтесь, що він існує)
can_pickup = true; // Чи можна підібрати зараз
pickup_delay = room_speed * 0.2; // Невелика затримка перед можливістю підбору
alarm[0] = pickup_delay; // Встановити таймер затримки
