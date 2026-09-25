if (enemy_combat_tick()) exit;
 /// @description Логіка поведінки Тіні Аїда

/// obj_hades_shadow — Step Event

// ---- СМЕРТЬ ----
if (hp <= 0)
{
    if (!enemy_anim_death_tick(spr_hades_shadow_death)) exit;
    // audio_play_sound(snd_shadow_die, 1, false);
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
 
if (attack_cd  > 0) attack_cd--;
if (scream_cd  > 0) scream_cd--;
 
var _dist = distance_to_object(obj_player);
 
// ---- ПУЛЬСАЦІЯ ПРОЗОРОСТІ (моторошний ефект) ----
image_alpha = 0.5 + sin(current_time / 300000) * 0.3;
 
switch (state)
{
    // ------ 0: СТОЇТЬ ------
    case 0:
        image_xscale = (obj_player.x > x) ? 1 : -1;
 
        if (_dist <= sight_range)
        {
            state = 1;
			with (obj_ui_controller)
		    {
		        show_npc_dialog("Ти не пройдеш через царство Аїда!", 210);
		    }
            // audio_play_sound(snd_shadow_appear, 1, false);
        }
    break;
 
    // ------ 1: ПЕРЕСЛІДУЄ ------
    case 1:
        // --- КРИК-ЗАМОРОЗКА ---
        // Якщо гравець в радіусі крику і кулдаун завершився
        if (_dist <= scream_range && scream_cd <= 0)
        {
            // Заморожуємо гравця на 1 секунду
            obj_player.is_frozen    = true;
            obj_player.freeze_timer = room_speed;  // 1 секунда
            scream_cd = scream_cd_max;
            enemy_anim_attack(spr_hades_shadow_attack);
            // audio_play_sound(snd_shadow_scream, 1, false);
 
            // Візуальний спалах (можна додати частинки або ефект)
        }
 
        // --- РУХ ---
        var _move_x = sign(obj_player.x - x) * spd;
        if (!place_meeting(x + _move_x, y, obj_platform))
            x += _move_x;
 
        image_xscale = (_move_x >= 0) ? 1 : -1;
 
        // --- БЛИЖНЯ АТАКА ---
        if (_dist <= attack_range && attack_cd <= 0 && !obj_player.is_damage && enemy_can_damage(id))
        {
            obj_player.hp       -= atk;
            var _dir             = point_direction(x, y, obj_player.x, obj_player.y);
            obj_player.hspd     = lengthdir_x(8, _dir);
            obj_player.vspd     = -5;
            obj_player.is_damage = true;
            obj_player.alarm[0]  = room_speed;
            attack_cd = attack_cd_max;
            enemy_anim_attack(spr_hades_shadow_attack);
            // audio_play_sound(snd_shadow_attack, 1, false);
        }
 
        if (_dist > sight_range * 1.5)
            state = 0;
    break;
}
