/// @description
/// obj_boss_minotaur — Step Event

if (is_dead || !instance_exists(obj_player)) exit;
if (world_state_boss_defeated("minotaur"))
{
    world_state_spawn_boss_reward("minotaur", obj_pickup_oar_reward, x, y);
    instance_destroy();
    exit;
}

if (hp <= 0)
{
    if (!enemy_anim_death_tick(spr_boss_minotaur_death)) exit;
    is_dead = true;
    world_state_mark_boss_defeated("minotaur");
    world_state_spawn_boss_reward("minotaur", obj_pickup_oar_reward, x, y);
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

if (column_strike_cd > 0) column_strike_cd--;
if (melee_cd         > 0) melee_cd--;

// ---- РУХ ДО ГРАВЦЯ ----
var _dir_x = sign(obj_player.x - x);
var _move  = _dir_x * move_speed;

if (!place_meeting(x + _move, y, obj_platform))
    x += _move;
image_xscale = _dir_x;

var _dist = distance_to_object(obj_player);

// ---- ПОШУК КОЛОНИ НА ЯКІЙ ГРАВЕЦЬ ----
// Якщо гравець на колоні — б'ємо по колоні
var _player_on_column = noone;
var _cn = instance_number(obj_minotaur_column);
for (var _i = 0; _i < _cn; _i++)
{
    var _col = instance_find(obj_minotaur_column, _i);
    if (!instance_exists(_col)) continue;
    // Гравець стоїть на колоні якщо він прямо над нею
    if (obj_player.bbox_right > _col.bbox_left && obj_player.bbox_left < _col.bbox_right
        && abs(obj_player.bbox_bottom - (_col.bbox_top - 1)) < 6)
    {
        _player_on_column = _col;
        break;
    }
}

if (instance_exists(_player_on_column) && column_strike_cd <= 0)
{
    // Б'ємо по колоні
    _player_on_column.hp--;
    column_strike_cd = column_strike_cd_max;
    enemy_anim_attack(spr_boss_minotaur_attack);
    // audio_play_sound(snd_minotaur_strike, 1, false);

    // Шкода гравцю якщо він на колоні під час удару
    if (!obj_player.is_damage)
    {
        obj_player.hp       -= atk;
        obj_player.vspd     = -5;
        obj_player.is_damage = true;
        obj_player.alarm[0]  = room_speed;
    }
}
else if (!instance_exists(_player_on_column)
         && _dist <= melee_range && melee_cd <= 0
         && !obj_player.is_damage)
{
    // Гравець на землі — звичайна атака
    obj_player.hp       -= atk;
    var _kd = point_direction(x, y, obj_player.x, obj_player.y);
    obj_player.hspd     = lengthdir_x(9, _kd);
    obj_player.vspd     = -5;
    obj_player.is_damage = true;
    obj_player.alarm[0]  = room_speed;
    melee_cd = melee_cd_max;
    enemy_anim_attack(spr_boss_minotaur_attack);
}
