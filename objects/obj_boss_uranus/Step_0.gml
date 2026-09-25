if (enemy_combat_tick()) exit;
/// @description
/// obj_boss_uranus — Step Event

if (is_dead || !instance_exists(obj_player)) exit;
if (world_state_boss_defeated("uranus"))
{
    world_state_spawn_boss_reward("uranus", obj_pickup_pickaxe_reward, x, y);
    with (obj_uranus_barrier)
    {
        world_state_mark_instance(id, "destroyed");
        instance_destroy();
    }
    instance_destroy();
    exit;
}

if (hp <= 0)
{
    if (!enemy_anim_death_tick(spr_boss_uranus_death)) exit;
    is_dead = true;
    world_state_mark_boss_defeated("uranus");
    world_state_spawn_boss_reward("uranus", obj_pickup_pickaxe_reward, x, y);
    with (obj_uranus_barrier)
    {
        world_state_mark_instance(id, "destroyed");
        instance_destroy();
    }
    autosave_game();
    instance_destroy();
    exit;
}

// Гравітація
vspd += grv;
if (place_meeting(x, y + vspd, obj_platform))
{
    while (!place_meeting(x, y + sign(vspd), obj_platform)) y += sign(vspd);
    vspd = 0;
}
y += vspd;

if (action_cd > 0) action_cd--;
if (swing_cd   > 0) swing_cd--;

// ---- ПОШУК ЗАВАЛІВ ----
var _barriers = [];
var _bn       = instance_number(obj_uranus_barrier);
for (var _i = 0; _i < _bn; _i++)
    array_push(_barriers, instance_find(obj_uranus_barrier, _i));

switch (state)
{
    // ------ 0: СТОЇТЬ — вибирає дію ------
    case 0:
        if (action_cd > 0) break;
        image_xscale = (obj_player.x > x) ? 1 : -1;

        var _dist = distance_to_object(obj_player);

        // Якщо гравець на землі і немає завалів між ними — атакуємо
        if (_dist <= swing_range && array_length(_barriers) == 0)
        {
            state     = 3;
            action_cd = swing_cd_max;
        }
        // Інакше — б'ємо наступний завал
        else if (array_length(_barriers) > 0)
        {
            state     = 1;
            action_cd = room_speed * 0.5;
        }
    break;

    // ------ 1: Б'Є ЗАВАЛ ------
    case 1:
        // Знаходимо найближчий завал до гравця
        var _target_barrier = noone;
        var _min_dist_to_player = infinity;

        for (var _i = 0; _i < array_length(_barriers); _i++)
        {
            var _b = _barriers[_i];
            if (!instance_exists(_b)) continue;
            var _bd = abs(_b.x - obj_player.x);
            if (_bd < _min_dist_to_player)
            {
                _min_dist_to_player = _bd;
                _target_barrier     = _b;
            }
        }

        if (!instance_exists(_target_barrier)) { state = 0; break; }

        image_xscale = (_target_barrier.x > x) ? 1 : -1;

        if (action_cd <= 0 && swing_cd <= 0)
        {
            // Завдаємо удар по завалу
            _target_barrier.hp--;
            _target_barrier.hit_flash = 8;
            swing_cd = swing_cd_max;
            enemy_anim_attack(spr_boss_uranus_attack);
            // audio_play_sound(snd_uranus_swing, 1, false);

            // Guaranteed recovery window after two swings or a broken barrier.
            barrier_swings++;
            if (barrier_swings mod 2 == 0 || _target_barrier.hp <= 0)
            {
                is_stuck  = true;
                state     = 2;
                action_cd = room_speed * 2;  // Застряг на 2 секунди
                // audio_play_sound(snd_uranus_stuck, 1, false);
                break;
            }

            // Якщо завал зруйновано
            if (_target_barrier.hp <= 0)
            {
                world_state_mark_instance(_target_barrier, "destroyed");
                instance_destroy(_target_barrier);
                state = 0;
                action_cd = room_speed;
            }
        }
    break;

    // ------ 2: ЗАСТРЯГ — ВРАЗЛИВИЙ! ------
    case 2:
        is_stuck = true;
        // Бос нерухомий і не атакує
        // Підсвічування (обробляється в Draw)
        if (action_cd <= 0)
        {
            is_stuck = false;
            state    = 0;
            action_cd = room_speed * 0.5;
        }
    break;

    // ------ 3: АТАКУЄ ГРАВЦЯ КАЙЛОМ ------
    case 3:
        image_xscale = (obj_player.x > x) ? 1 : -1;

        if (action_cd <= 0 && !obj_player.is_damage && enemy_can_damage(id))
        {
            if (distance_to_object(obj_player) <= swing_range)
            {
                obj_player.hp       -= atk;
                enemy_anim_attack(spr_boss_uranus_attack);
                var _kd = point_direction(x, y, obj_player.x, obj_player.y);
                obj_player.hspd     = lengthdir_x(10, _kd);
                obj_player.vspd     = -6;
                obj_player.is_damage = true;
                obj_player.alarm[0]  = room_speed;
                // audio_play_sound(snd_uranus_attack, 1, false);
            }
            state = 0;
            action_cd = room_speed * 1.5;
        }
    break;
}
