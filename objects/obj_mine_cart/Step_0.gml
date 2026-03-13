/// @description 
/// obj_mine_cart — Step Event

if (!instance_exists(obj_player)) exit;
 
// ---- ВХІД/ВИХІД ----
var _dist = distance_to_object(obj_player);
 
if (keyboard_check_pressed(ord("E")))
{
    if (!has_player && _dist <= interact_range)
    {
        // Гравець сідає у вагонетку
        has_player          = true;
        obj_player.is_frozen = true;   // Блокуємо самостійний рух гравця
        // audio_play_sound(snd_cart_enter, 1, false);
    }
    else if (has_player)
    {
        // Гравець виходить
        _exit_cart();
    }
}
 
// Вихід стрибком (SPACE)
if (has_player && keyboard_check_pressed(vk_space))
{
    _exit_cart();
    obj_player.vspd = -10;   // Стрибок при виході
}
 
// ---- ГРАВІТАЦІЯ ВАГОНЕТКИ ----
on_rail = place_meeting(x, y + 1, obj_rail)
          || place_meeting(x, y + 1, obj_platform);
 
vspd += grv;
if (place_meeting(x, y + vspd, obj_platform)
    || place_meeting(x, y + vspd, obj_rail))
{
    while (!place_meeting(x, y + sign(vspd), obj_platform)
           && !place_meeting(x, y + sign(vspd), obj_rail))
        y += sign(vspd);
    vspd = 0;
}
y += vspd;
 
// ---- РУХ ПО РЕЙКАХ ----
if (on_rail)
{
    if (has_player)
    {
        // Гравець керує вагонеткою
        var _left  = keyboard_check(ord("A")) || keyboard_check(vk_left);
        var _right = keyboard_check(ord("D")) || keyboard_check(vk_right);
 
        if (_right) cart_spd = min(cart_spd + cart_accel, cart_spd_max);
        if (_left)  cart_spd = max(cart_spd - cart_accel, -cart_spd_max);
    }
 
    // Тертя
    cart_spd *= (1 - cart_friction);
    if (abs(cart_spd) < 0.1) cart_spd = 0;
 
    // Горизонтальне зіткнення
    if (!place_meeting(x + cart_spd, y, obj_platform))
        x += cart_spd;
    else
    {
        cart_spd = 0;
        // audio_play_sound(snd_cart_bump, 1, false);
    }
}
 
// ---- ПОЗИЦІЯ ГРАВЦЯ У ВАГОНЕТЦІ ----
if (has_player)
{
    // Гравець сидить всередині — переміщуємо разом із вагонеткою
    obj_player.x    = x;
    obj_player.y    = y - sprite_height / 2 + 4;
    obj_player.vspd = 0;
    obj_player.hspd = 0;
}
 