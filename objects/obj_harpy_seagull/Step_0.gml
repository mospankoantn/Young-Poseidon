/// @description Логіка поведінки гарпії

///  obj_harpy_seagull — Step Event

// ---- СМЕРТЬ ----
if (hp <= 0)
{
    if (!enemy_anim_death_tick(spr_harpy_seagull_death)) exit;
    // audio_play_sound(snd_harpy_die, 1, false);
    instance_destroy();
    exit;
}
 
if (!instance_exists(obj_player)) exit;
 
if (attack_cd > 0) attack_cd--;
 
var _dist_to_player = distance_to_object(obj_player);
var _player_visible = (_dist_to_player <= sight_range);
 
// ============================================================
// СТАНИ ПІКІРУВАННЯ
// ============================================================
switch (dive_state)
{
    // ------ 0: ГОРИЗОНТАЛЬНИЙ ПАТРУЛЬ ------
    case 0:
        // Плавний рух по горизонталі
        x += fly_spd * fly_dir;
 
        // Синусоїда по вертикалі (красивий плавний рух)
        y = base_y + sin(current_time / 600000) * 20;
 
        // Розворот на межах
        if (x <= left_bound)  { fly_dir =  1; x = left_bound;  }
        if (x >= right_bound) { fly_dir = -1; x = right_bound; }
 
        image_xscale = fly_dir;
 
        // Якщо бачить гравця і можна атакувати — переходимо у "зависання"
        if (_player_visible && attack_cd <= 0)
        {
            dive_state = 1;
            hover_x    = obj_player.x;    // Ціль: над гравцем
            hover_timer = 45;             // Зависаємо 0.75 сек
        }
    break;
 
    // ------ 1: ЗАВИСАННЯ НАД ГРАВЦЕМ ------
    case 1:
        // Летимо до точки над гравцем
        var _target_x = obj_player.x;
        var _target_y = obj_player.y - 100;
 
        var _dx = _target_x - x;
        var _dy = _target_y - y;
        var _d  = sqrt(_dx * _dx + _dy * _dy);
 
        if (_d > 3)
        {
            x += (_dx / _d) * spd * 1.5;
            y += (_dy / _d) * spd * 1.5;
        }
 
        image_xscale = (obj_player.x > x) ? 1 : -1;
 
        hover_timer--;
        if (hover_timer <= 0)
        {
            // Запам'ятовуємо позицію гравця і починаємо пікірувати
            dive_target_x = obj_player.x;
            dive_target_y = obj_player.y;
            dive_state    = 2;
            enemy_anim_attack(spr_harpy_seagull_attack);
        }
    break;
 
    // ------ 2: ПІКІРУВАННЯ ------
    case 2:
        var _dx = dive_target_x - x;
        var _dy = dive_target_y - y;
        var _d  = sqrt(_dx * _dx + _dy * _dy);
 
        // Летимо в бік цілі з більшою швидкістю
        if (_d > spd * 2)
        {
            x += (_dx / _d) * spd * 3;
            y += (_dy / _d) * spd * 3;
        }
        else
        {
            // Досягли цілі — перевіряємо чи вдарили гравця
            dive_state = 3;
        }
 
        image_xscale = (_dx > 0) ? 1 : -1;
 
        // Перевірка удару
        if (distance_to_object(obj_player) <= attack_range && !obj_player.is_damage)
        {
            obj_player.hp       -= atk;
            var _dir             = point_direction(x, y, obj_player.x, obj_player.y);
            obj_player.hspd     = lengthdir_x(5, _dir);
            obj_player.vspd     = -3;
            obj_player.is_damage = true;
            obj_player.alarm[0]  = room_speed;
            // audio_play_sound(snd_harpy_attack, 1, false);
        }
 
        attack_cd  = attack_cd_max;
        dive_state = 3;
    break;
 
    // ------ 3: ПОВЕРНЕННЯ НА ПАТРУЛЬ ------
    case 3:
        var _target_y = base_y;
        y += (_target_y - y) * 0.05;   // Плавне повернення
 
        if (abs(y - base_y) < 3)
        {
            y          = base_y;
            dive_state = 0;
        }
    break;
}
