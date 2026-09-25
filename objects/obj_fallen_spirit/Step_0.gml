if (enemy_combat_tick()) exit;
/// @description Логіка поведінки Духа Полеглого

/// obj_fallen_spirit — Step Event

// ---- СМЕРТЬ ----
if (hp <= 0)
{
    if (!enemy_anim_death_tick(spr_fallen_spirit_death)) exit;
    // audio_play_sound(snd_fallen_die, 1, false);
    instance_destroy();
    exit;
}
 
if (!instance_exists(obj_player)) exit;
 
// ---- ГРАВІТАЦІЯ ----
vspd += grv;
if (place_meeting(x, y + vspd, obj_platform))
{
    while (!place_meeting(x, y + sign(vspd), obj_platform))
        y += sign(vspd);
    vspd = 0;
}
y += vspd;
 
if (melee_cd > 0) melee_cd--;
if (bow_cd   > 0) bow_cd--;
 
var _dist = distance_to_object(obj_player);
 
switch (state)
{
    // ------ 0: ПАТРУЛЬ ------
    case 0:
        x += patrol_spd * move_dir;
        image_xscale = move_dir;
 
        if (x <= left_bound || x >= right_bound
            || place_meeting(x + patrol_spd * move_dir, y, obj_platform))
            move_dir *= -1;
 
        if (_dist <= sight_range)
        {
            state = 1;
            // audio_play_sound(snd_fallen_alert, 1, false);
        }
    break;
 
    // ------ 1: ПЕРЕСЛІДУЄ / вибір атаки ------
    case 1:
        image_xscale = (obj_player.x > x) ? 1 : -1;
 
        if (_dist <= melee_range)
        {
            // Гравець близько — переходимо до удару мечем
            state = 3;
            break;
        }
 
        if (_dist <= bow_range && bow_cd <= 0)
        {
            // Гравець в зоні лука — стріляємо
            state = 2;
            break;
        }
 
        // Наближаємось до гравця
        var _move_x = sign(obj_player.x - x) * spd;
        if (!place_meeting(x + _move_x, y, obj_platform))
            x += _move_x;
 
        if (_dist > sight_range * 1.5) state = 0;
    break;
 
    // ------ 2: АТАКА ЛУКОМ ------
    case 2:
        // Зупиняємося і стріляємо
        image_xscale = (obj_player.x > x) ? 1 : -1;
 
        if (bow_cd <= 0)
        {
            // Створюємо стрілу в напрямку гравця
            var _arrow = instance_create_layer(x + image_xscale * 16, y - 8,
                                               "Instances", obj_arrow);
            _arrow.direction_x  = sign(obj_player.x - x);
            _arrow.source_enemy = id;
            _arrow.fly_speed    = 8;
            _arrow.damage       = atk;
            bow_cd = bow_cd_max;
            enemy_anim_attack(spr_fallen_spirit_attack);
            // audio_play_sound(snd_fallen_bow, 1, false);
        }
 
        // Повертаємось до переслідування
        state = 1;
    break;
 
    // ------ 3: АТАКА МЕЧЕМ ------
    case 3:
        image_xscale = (obj_player.x > x) ? 1 : -1;
 
        if (melee_cd <= 0 && !obj_player.is_damage && enemy_can_damage(id))
        {
            obj_player.hp       -= atk;
            var _dir             = point_direction(x, y, obj_player.x, obj_player.y);
            obj_player.hspd     = lengthdir_x(9, _dir);
            obj_player.vspd     = -5;
            obj_player.is_damage = true;
            obj_player.alarm[0]  = room_speed;
            melee_cd = melee_cd_max;
            enemy_anim_attack(spr_fallen_spirit_attack);
            // audio_play_sound(snd_fallen_melee, 1, false);
        }
 
        if (_dist > melee_range * 1.5) state = 1;
    break;
}
