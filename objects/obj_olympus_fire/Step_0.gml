/// @description Логіка поведінки Вогню Олімпу

/// obj_olympus_fire — Step Event
// ---- СМЕРТЬ ----
if (hp <= 0 || has_attacked)
{
    if (!enemy_anim_death_tick(spr_olympus_fire_death)) exit;
    // audio_play_sound(snd_fire_die, 1, false);
    instance_destroy();
    exit;
}
 
if (!instance_exists(obj_player)) exit;
 
// ---- РУХ (хвилеподібний у бік гравця) ----
var _dir_to_player = point_direction(x, y, obj_player.x, obj_player.y);
 
// Основний напрямок — до гравця
var _main_x = lengthdir_x(spd, _dir_to_player);
var _main_y = lengthdir_y(spd, _dir_to_player);
 
// Перпендикулярне коливання (синусоїда)
fly_angle += wave_spd;
var _wave_x = lengthdir_x(wave_amp * sin(fly_angle), _dir_to_player + 90);
var _wave_y = lengthdir_y(wave_amp * sin(fly_angle), _dir_to_player + 90);
 
// Підсумковий рух — напрямок до гравця + хвиля
x += _main_x * 0.15 + _wave_x * 0.03;
y += _main_y * 0.15 + _wave_y * 0.03;
 
// Обертання спрайту для красивого ефекту
image_angle += 5;
 
// ---- АТАКА ДОТИКОМ ----
if (distance_to_object(obj_player) <= attack_range && !obj_player.is_damage)
{
    obj_player.hp       -= atk;
    var _dir             = point_direction(x, y, obj_player.x, obj_player.y);
    obj_player.hspd     = lengthdir_x(7, _dir);
    obj_player.vspd     = -5;
    obj_player.is_damage = true;
    obj_player.alarm[0]  = room_speed;
    has_attacked = true;   // Позначаємо — знищимось наступного кадру
    enemy_anim_attack(spr_olympus_fire_attack);
    // audio_play_sound(snd_fire_attack, 1, false);
}
