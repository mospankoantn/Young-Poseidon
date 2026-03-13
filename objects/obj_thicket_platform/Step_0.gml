/// @description 
/// obj_thicket_platform — Step Event

if (is_cleared) exit;
if (!instance_exists(obj_player)) exit;
 
// ---- АНІМАЦІЯ ЗНИКНЕННЯ ----
if (is_cutting)
{
    cut_timer++;
    image_alpha = 1 - (cut_timer / 20);   // Поступово зникаємо
 
    if (cut_timer >= 20)
    {
        instance_destroy();
    }
    exit;
}
 
// ---- ВЗАЄМОДІЯ З КОСОЮ ----
var _dist = distance_to_object(obj_player);
 
// Спосіб 1: Натискання E з косою
if (_dist <= interact_range
    && obj_player.current_weapon == 3    // 3 = Коса
    && keyboard_check_pressed(ord("E")))
{
    _start_cut();
}
 
// Спосіб 2: Гравець з косою просто заходить в хащі
if (place_meeting(obj_player.x, obj_player.y, id)
    && obj_player.current_weapon == 3)
{
    _start_cut();
}

_start_cut = function()
{
    if (!is_cutting)
    {
        is_cutting  = true;
        is_cleared  = true;
        // audio_play_sound(snd_thicket_cut, 1, false);
    }
};