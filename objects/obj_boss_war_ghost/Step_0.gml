/// @description 
/// obj_boss_war_ghost — Step Event

if (is_dead || !instance_exists(obj_player)) exit;
if (obj_player.weapon_unlocked[5]) { instance_destroy(); exit; }
 
if (hp <= 0)
{
    if (!enemy_anim_death_tick(spr_boss_war_ghost_death)) exit;
    is_dead = true;
    instance_create_layer(x, y, "Instances", obj_pickup_sword_reward);
    instance_destroy();
    exit;
}
 
if (action_cd > 0) action_cd--;
if (melee_cd  > 0) melee_cd--;
if (summon_cd > 0) summon_cd--;
 
// Підраховуємо живих духів
spirits_alive = instance_number(obj_fallen_spirit);
 
// Пульсація прозорості
image_alpha = is_vulnerable
    ? (0.7 + 0.3 * sin(current_time / 150000))   // Швидша коли вразливий
    : (0.5 + 0.2 * sin(current_time / 300000));
 
switch (state)
{
    // ------ 0: ЛІТАЄ ЗИГЗАГОМ (невразливий) ------
    case 0:
        var _tx = point_x[current_point];
        var _ty = point_y[current_point];
        var _d  = point_distance(x, y, _tx, _ty);
 
        if (_d > fly_speed)
        {
            var _dir = point_direction(x, y, _tx, _ty);
            x += lengthdir_x(fly_speed, _dir);
            y += lengthdir_y(fly_speed, _dir);
        }
        else
        {
            x = _tx; y = _ty;
            current_point = (current_point + 1) mod point_count;
        }
 
        image_xscale = (obj_player.x > x) ? 1 : -1;
 
        // Якщо всі духи вбиті — спускаємось
        if (spirits_alive == 0 && action_cd <= 0)
        {
            state        = 2;
            is_vulnerable = true;
            action_cd    = room_speed * 3;   // 3 секунди вразливості
        }
    break;
 
    // ------ 1: ПІДІЙМАЄ ДУХІВ ------
    case 1:
        if (summon_cd <= 0 && action_cd <= 0)
        {
            // Підіймаємо 5 духів з купи кісток
            var _bp_x = variable_global_exists("bone_pile_x")
                        ? global.bone_pile_x : x;
 
            for (var _si = 0; _si < 5; _si++)
            {
                var _sp = instance_create_layer(
                    _bp_x + irandom_range(-60, 60),
                    room_height - 100,
                    "Instances", obj_fallen_spirit);
                // Духи в бою зі слабшими характеристиками
                _sp.hp  = 8;
                _sp.atk = 3;
            }
            summon_wave++;
            state = 0;   // Летимо поки духи живуть
            // audio_play_sound(snd_warghost_summon, 1, false);
        }
    break;
 
    // ------ 2: СПУСТИВСЯ — ВРАЗЛИВИЙ ------
    case 2:
        is_vulnerable = true;
        // Летимо вниз до рівня гравця
        var _target_y = obj_player.y - 50;
        y = lerp(y, _target_y, 0.05);
        image_xscale = (obj_player.x > x) ? 1 : -1;
 
        // Атака в ближньому бою
        if (distance_to_object(obj_player) <= melee_range
            && melee_cd <= 0 && !obj_player.is_damage)
        {
            obj_player.hp       -= atk;
            var _kd = point_direction(x, y, obj_player.x, obj_player.y);
            obj_player.hspd     = lengthdir_x(9, _kd);
            obj_player.vspd     = -5;
            obj_player.is_damage = true;
            obj_player.alarm[0]  = room_speed;
            melee_cd = melee_cd_max;
            enemy_anim_attack(spr_boss_war_ghost_attack);
        }
 
        // Через 3 секунди піднімаємо нову хвилю
        if (action_cd <= 0)
        {
            is_vulnerable = false;
            state         = 1;
            action_cd     = room_speed * 1.5;
            summon_cd     = room_speed;
        }
    break;
}
 
 
// ---- ЗВ'ЯЗОК: вбитий дух завдає шкоди босу ----
// Це реалізується в obj_fallen_spirit — Destroy Event:
// (Додай Destroy Event в obj_fallen_spirit)
/*
if (instance_exists(obj_boss_war_ghost))
{
    obj_boss_war_ghost.hp -= 5;  // Кожен вбитий дух = 5 шкоди босу
}
*/
