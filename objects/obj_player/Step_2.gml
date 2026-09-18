/// @description Choose the visual state after movement and collision damage.
var _ground_now = vspd == 0 && drop_timer <= 0
    && place_meeting(x, y + 1, obj_platform);
var _hurt_now = hp < anim_last_hp || (is_damage && !anim_was_damage);

if (_hurt_now && hp > 0)
    _play_player_action(spr_player_hurt);
else if (_ground_now && !anim_was_on_ground && anim_action_timer <= 0)
    _play_player_action(spr_player_land);

// A new jump interrupts landing recovery, without delaying movement or attacks.
if (anim_action_sprite == spr_player_land && !_ground_now)
    anim_action_timer = 0;

image_xscale = l_right ? 1 : -1;
if (anim_action_timer > 0)
{
    _set_player_animation(anim_action_sprite, 1);
    var _frame_step = sprite_get_speed(sprite_index) / room_speed;
    if (image_index + _frame_step >= image_number)
    {
        image_index = image_number - 1;
        image_speed = 0;
    }
}
else if (!_ground_now)
{
    _set_player_animation(spr_player_jump, 0);
    // Rising -> apex -> falling; a long fall must not loop back to takeoff.
    image_index = clamp(floor(((vspd + 12) / 24) * image_number), 0, image_number - 1);
}
else if (abs(x - anim_last_x) > 0.1)
    _set_player_animation(spr_player_run, clamp(abs(x - anim_last_x) / 10, 0.6, 1.5));
else
    _set_player_animation(spr_player_idle, 1);

anim_was_on_ground = _ground_now;
anim_was_damage = is_damage;
anim_last_hp = hp;
anim_last_x = x;
