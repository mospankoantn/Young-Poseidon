if (enemy_combat_tick()) exit;
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

if (attack_windup > 0)
{
    attack_windup--;
    if (attack_windup == 0)
    {
        enemy_anim_attack(spr_boss_minotaur_attack);
        yp_sfx("stone", x);
        if (instance_exists(attack_target_column) && abs(attack_target_column.x-x) <= 110)
            attack_target_column.hp--;
        if (enemy_can_damage(id) && !obj_player.is_dead && !obj_player.is_damage
            && abs(obj_player.x-attack_target_x) < 58 && distance_to_object(obj_player) <= 100)
        {
            obj_player.hp -= atk;
            obj_player.hspd = (obj_player.x >= x ? 1 : -1) * 7;
            obj_player.vspd = -5;
            obj_player.is_damage = true;
            obj_player.alarm[0] = room_speed;
        }
        melee_cd = melee_cd_max;
        column_strike_cd = column_strike_cd_max;
    }
    exit;
}

// ---- РУХ ДО ГРАВЦЯ ----
var _dir_x = sign(obj_player.x - x);
var _move  = _dir_x * move_speed;

if (!place_meeting(x + _move, y, obj_platform))
    x += _move;
if (_dir_x != 0) image_xscale = _dir_x;

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

if (instance_exists(_player_on_column) && column_strike_cd <= 0
    && abs(_player_on_column.x-x) <= 95)
{
    attack_target_column = _player_on_column;
    attack_target_x = obj_player.x;
    attack_windup = round(room_speed * 0.65);
}
else if (!instance_exists(_player_on_column)
         && _dist <= melee_range && melee_cd <= 0
         && !obj_player.is_damage && enemy_can_damage(id))
{
    attack_target_column = noone;
    attack_target_x = obj_player.x;
    attack_windup = round(room_speed * 0.5);
}
