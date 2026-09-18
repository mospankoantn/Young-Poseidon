/// @description Shared visual timing for enemy and boss sprite states.

function enemy_anim_select(_sprite)
{
    if (sprite_index != _sprite)
    {
        sprite_index = _sprite;
        image_index = 0;
    }
    image_speed = 1;
}

function enemy_anim_attack(_sprite)
{
    if (anim_death_started) return;
    anim_attack_sprite = _sprite;
    anim_attack_elapsed = 0;
    anim_attack_length = ceil(sprite_get_number(_sprite) * room_speed / sprite_get_speed(_sprite));
    sprite_index = _sprite;
    image_index = 0;
    image_speed = 0;
}

function enemy_anim_death_tick(_sprite)
{
    if (!anim_death_started)
    {
        anim_death_started = true;
        anim_death_elapsed = 0;
        anim_attack_elapsed = -1;
        sprite_index = _sprite;
        image_index = 0;
        image_speed = 0;
    }

    anim_death_elapsed++;
    image_index = min(sprite_get_number(_sprite) - 1,
        floor(anim_death_elapsed * sprite_get_speed(_sprite) / room_speed));
    return anim_death_elapsed >= ceil(sprite_get_number(_sprite) * room_speed
        / sprite_get_speed(_sprite));
}

function enemy_anim_update(_idle, _move, _moving)
{
    if (anim_death_started) return;
    if (anim_attack_elapsed >= 0)
    {
        anim_attack_elapsed++;
        image_index = min(sprite_get_number(anim_attack_sprite) - 1,
            floor(anim_attack_elapsed * sprite_get_speed(anim_attack_sprite) / room_speed));
        image_speed = 0;
        if (anim_attack_elapsed >= anim_attack_length) anim_attack_elapsed = -1;
    }
    else
    {
        enemy_anim_select(_moving ? _move : _idle);
    }
    anim_prev_x = x;
    anim_prev_y = y;
}

