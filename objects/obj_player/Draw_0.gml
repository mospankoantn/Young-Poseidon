/// @description Draw player, armed jump overlay and invulnerability blink.

// Invulnerability blink.
if (is_damage && !is_dead)
    image_alpha = (floor(current_time / 70) mod 2 == 0) ? 0.4 : 1.0;
else
    image_alpha = 1;

// The grounded armed sheets have their own full-body frames. Airborne motion
// uses the six-frame generic jump body plus the selected weapon as a moving
// overlay. This gives every weapon a proper jump presentation without falling
// back to an apparently unarmed pose.
var _draw_jump_weapon = (!is_dead
    && sprite_index == spr_player_jump
    && current_weapon >= 0
    && current_weapon < array_length(weapon_sprites)
    && _weapon_in_hand());

if (_draw_jump_weapon)
{
    var _frame = clamp(floor(image_index), 0, max(0, image_number - 1));
    var _bob = 0;
    switch (_frame)
    {
        case 0: _bob = 3; break;
        case 1: _bob = 1; break;
        case 2: _bob = -1; break;
        case 3: _bob = -2; break;
        case 4: _bob = 0; break;
        default: _bob = 2; break;
    }

    var _dir = image_xscale >= 0 ? 1 : -1;
    var _wx = x + _dir * 5;
    var _wy = y - 31 + _bob;
    var _scale = 0.62;
    var _angle = 0;

    // Weapon-specific alignment. The weapon is drawn behind the body so the
    // hand/torso naturally occlude the handle during the jump.
    switch (current_weapon)
    {
        case 0: // trident
            _wx = x + _dir * 8;
            _wy = y - 31 + _bob;
            _scale = 0.64;
            _angle = _dir > 0 ? -12 : 12;
        break;
        case 1: // spear
            _wx = x + _dir * 4;
            _wy = y - 28 + _bob;
            _scale = 0.62;
            _angle = _dir > 0 ? -8 : 8;
        break;
        case 2: // pickaxe
            _wx = x + _dir * 2;
            _wy = y - 27 + _bob;
            _scale = 0.58;
            _angle = _dir > 0 ? -8 : 8;
        break;
        case 3: // scythe
            _wx = x + _dir * 4;
            _wy = y - 29 + _bob;
            _scale = 0.60;
            _angle = _dir > 0 ? -10 : 10;
        break;
        case 4: // oar
            _wx = x + _dir * 3;
            _wy = y - 27 + _bob;
            _scale = 0.62;
            _angle = _dir > 0 ? -7 : 7;
        break;
        case 5: // sword
            _wx = x + _dir * 6;
            _wy = y - 27 + _bob;
            _scale = 0.58;
            _angle = _dir > 0 ? -10 : 10;
        break;
    }

    draw_sprite_ext(
        weapon_sprites[current_weapon], 0,
        _wx, _wy,
        _scale * _dir, _scale,
        _angle,
        c_white, image_alpha
    );
}

// Main body / normal armed animation.
draw_self();
