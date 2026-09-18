/// @description
/// obj_weapon_selector — Step Event

if (!instance_exists(obj_player)) { instance_destroy(); exit; }
if (obj_player.is_dead || obj_player.hp <= 0) { instance_destroy(); exit; }

// Анімація появи
appear_scale = lerp(appear_scale, 1, 0.2);
gui_cx = display_get_gui_width() / 2;
gui_cy = display_get_gui_height() / 2;
 
// ---- ЗАКРИТТЯ ----
if (keyboard_check_released(vk_tab) || keyboard_check_pressed(vk_escape))
{
    instance_destroy();
    exit;
}
 
var _count = array_length(unlocked_indices);
if (_count == 0) { instance_destroy(); exit; }
 
// ---- ВИБІР МИШЕЮ ----
var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);
hover_slot = -1;
 
for (var _i = 0; _i < _count; _i++)
{
    var _angle   = (_i / _count) * 360 - 90;
    var _ix      = gui_cx + lengthdir_x(radius, _angle) * appear_scale;
    var _iy      = gui_cy + lengthdir_y(radius, _angle) * appear_scale;
    var _dist_m  = point_distance(_mx, _my, _ix, _iy);
 
    if (_dist_m <= icon_size / 2 + 8)
    {
        hover_slot = _i;
 
        if (mouse_check_button_pressed(mb_left))
        {
            selected_slot = _i;
            obj_player.current_weapon = unlocked_indices[selected_slot];
            // audio_play_sound(snd_weapon_switch, 1, false);
            instance_destroy();
            exit;
        }
    }
}
 
// ---- ВИБІР КЛАВІАТУРОЮ ----
if (keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D")))
    selected_slot = (selected_slot + 1) mod _count;
 
if (keyboard_check_pressed(vk_left) || keyboard_check_pressed(ord("A")))
    selected_slot = (selected_slot - 1 + _count) mod _count;
 
if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space))
{
    obj_player.current_weapon = unlocked_indices[selected_slot];
    // audio_play_sound(snd_weapon_switch, 1, false);
    instance_destroy();
    exit;
}
