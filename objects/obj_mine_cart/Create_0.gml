/// @description 
/// obj_mine_cart — Create Event

// ---- РУХ ----
cart_spd       = 0;       // Поточна горизонтальна швидкість
cart_spd_max   = 8;       // Максимальна швидкість
cart_accel     = 0.2;     // Прискорення при натисканні
cart_friction  = 0.05;    // Природне уповільнення (тертя)
 
// ---- СТАН ----
has_player     = false;   // Гравець всередині вагонетки?
interact_range = 50;
 
// ---- ФІЗИКА ----
vspd           = 0;
grv            = 0.5;
 
// ---- РЕЙКИ ----
// Вагонетка рухається лише поки стоїть на obj_rail
on_rail        = false;

_exit_cart = function()
{
    has_player            = false;
    obj_player.is_frozen  = false;
    // Виштовхуємо гравця трохи вище вагонетки щоб не застряг
    obj_player.y         -= sprite_height / 2 + 4;
    obj_player.hspd       = cart_spd;   // Гравець вилітає зі швидкістю вагонетки
    // audio_play_sound(snd_cart_exit, 1, false);
};