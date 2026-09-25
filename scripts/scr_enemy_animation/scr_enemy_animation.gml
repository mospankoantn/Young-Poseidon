/// @description Shared visual timing for enemy and boss sprite states.

function enemy_combat_init()
{
    hurt_timer = 0;
    hit_flash = 0;
    combat_last_hp = hp;
    hit_from_x = x;
    if (variable_instance_exists(id,"point_count")) {
        for(var _i=0;_i<point_count;_i++) {
            point_x[_i]=clamp(point_x[_i],80,max(80,room_width-80));
            point_y[_i]=clamp(point_y[_i],120,max(120,room_height-100));
        }
    }
}

function enemy_can_damage(_enemy)
{
    if (!instance_exists(_enemy)) return false;
    if (!variable_instance_exists(_enemy, "hp") || _enemy.hp <= 0) return false;
    if (variable_instance_exists(_enemy, "summon_owner") && _enemy.summon_owner != noone)
    {
        if (!instance_exists(_enemy.summon_owner)) return false;
        if (_enemy.summon_owner.hp <= 0) return false;
    }
    if (variable_instance_exists(_enemy, "is_dead") && _enemy.is_dead) return false;
    if (variable_instance_exists(_enemy, "anim_death_started") && _enemy.anim_death_started) return false;
    if (variable_instance_exists(_enemy, "hurt_timer") && _enemy.hurt_timer > 0) return false;
    if (variable_instance_exists(_enemy, "combat_last_hp") && _enemy.hp < _enemy.combat_last_hp) return false;
    return true;
}

function enemy_take_hit(_enemy, _damage, _source_x)
{
    if (!instance_exists(_enemy) || !variable_instance_exists(_enemy, "hp")) return false;
    if (_enemy.hp <= 0 || _damage <= 0) return false;
    with (_enemy)
    {
        hp = max(0, hp - _damage);
        hurt_timer = max(1, round(room_speed * 0.4));
        hit_flash = hurt_timer;
        combat_last_hp = hp;
        hit_from_x = _source_x;
        anim_attack_elapsed = -1;
        yp_sfx(variable_instance_exists(id, "boss_name_key") ? "boss_hit" : "enemy_hit", x);
    }
    return true;
}

// Also catches damage from authored events that directly modify HP.
function enemy_combat_tick()
{
    if (variable_instance_exists(id, "summon_owner") && summon_owner != noone)
    {
        if (!instance_exists(summon_owner)) { instance_destroy(); return true; }
        if (summon_owner.hp <= 0) { instance_destroy(); return true; }
    }
    if (!variable_instance_exists(id, "hurt_timer")) enemy_combat_init();
    if (hp < combat_last_hp && hp > 0)
    {
        hurt_timer = round(room_speed * 0.4);
        hit_flash = hurt_timer;
        anim_attack_elapsed = -1;
    }
    combat_last_hp = hp;
    if (hit_flash > 0) hit_flash--;
    if (hp <= 0) return false;
    if (hurt_timer > 0)
    {
        hurt_timer--;
        image_speed = 0;
        return true;
    }
    return false;
}

function enemy_draw_body()
{
    if (variable_instance_exists(id,"attack_windup") && attack_windup > 0 && hp > 0)
    {
        draw_set_color(make_color_rgb(255,190,75));
        draw_set_alpha(0.25 + 0.2 * sin(current_time / 75));
        draw_rectangle(attack_target_x-48,bbox_bottom-6,attack_target_x+48,bbox_bottom,false);
        draw_set_alpha(1);draw_set_color(c_white);
    }
    if (object_index == obj_boss_nymph && state == 1 && hp > 0)
    {
        draw_set_alpha(0.22);draw_set_color(make_color_rgb(90,230,195));
        for(var _gap=0;_gap<array_length(barrage_gap_positions);_gap++)
            draw_rectangle(barrage_gap_positions[_gap]-barrage_gap_width/2,32,
                barrage_gap_positions[_gap]+barrage_gap_width/2,room_height,false);
        draw_set_alpha(1);draw_set_color(c_white);
    }
    var _flash = variable_instance_exists(id, "hit_flash") ? hit_flash : 0;
    var _dead = hp <= 0 || anim_death_started;
    var _shake = (_flash > 0 && !_dead) ? sin(_flash * 2.4) * min(3, _flash * 0.2) : 0;
    draw_sprite_ext(sprite_index, image_index, x + _shake, y, image_xscale, image_yscale,
        image_angle, _flash > 0 ? merge_color(image_blend, c_red, 0.65) : image_blend, image_alpha);
    if (_flash > 0 && !_dead)
    {
        draw_set_color(make_color_rgb(255, 236, 162));
        draw_set_alpha(_flash / max(1, room_speed * 0.4));
        var _cx = (bbox_left + bbox_right) * 0.5;
        var _cy = (bbox_top + bbox_bottom) * 0.5;
        var _r = 8 + (room_speed * 0.4 - _flash) * 1.4;
        for (var _i = 0; _i < 5; _i++)
        {
            var _a = _i * 72 + 18;
            draw_line_width(_cx + lengthdir_x(_r, _a), _cy + lengthdir_y(_r, _a),
                _cx + lengthdir_x(_r + 5, _a), _cy + lengthdir_y(_r + 5, _a), 2);
        }
        draw_set_alpha(1);
        draw_set_color(c_white);
    }
}

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
    yp_sfx("attack", x);
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
        yp_sfx(variable_instance_exists(id, "boss_name_key") ? "boss_death" : "enemy_death", x);
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
    if (variable_instance_exists(id, "hurt_timer") && hurt_timer > 0) { image_speed = 0; return; }
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
