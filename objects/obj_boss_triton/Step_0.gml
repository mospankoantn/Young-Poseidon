/// @description 
/// obj_boss_triton — Step Event

if (is_dead || !instance_exists(obj_player)) exit;
if (world_state_boss_defeated("triton"))
{
    world_state_spawn_boss_reward("triton", obj_pickup_trident_reward, x, y);
    instance_destroy();
    exit;
}
 
 if (!boss_intro_shown)
{
    boss_intro_shown = true;
    with (obj_ui_controller)
    {
        show_npc_dialog("Ти думаєш що зможеш пройти?! Я — Тритон!", 270);
    }
}
 
 
if (hp <= 0)
{
    if (!enemy_anim_death_tick(spr_boss_triton_death)) exit;
    is_dead = true;
    world_state_mark_boss_defeated("triton");
    world_state_spawn_boss_reward("triton", obj_pickup_trident_reward, x, y);
    instance_destroy();
    exit;
}

if (rock_recharge_timer > 0)
{
    rock_recharge_timer--;
    if (rock_recharge_timer <= 0)
        _triton_reset_rock_wave();
}
else
{
    _triton_mark_next_rock();
    if (instance_number(obj_falling_rocks) > 0
        && !instance_exists(_triton_next_rock())
        && !_triton_has_falling_rock())
    {
        _triton_begin_rock_recharge();
    }
}
 
if (contact_cd > 0) contact_cd--;
 
// ---- РУХ МІЖ ТОЧКАМИ ----
var _tx = point_x[current_point];
var _ty = point_y[current_point];
var _d  = point_distance(x, y, _tx, _ty);
 
if (_d > fly_speed)
{
    var _dir = point_direction(x, y, _tx, _ty);
    x += lengthdir_x(fly_speed, _dir);
    y += lengthdir_y(fly_speed, _dir);
    image_xscale = (lengthdir_x(1, _dir) > 0) ? 1 : -1;
}
else
{
    x = _tx; y = _ty;
    current_point = (current_point + 1) mod point_count;
}
 
// ---- КОНТАКТНА ШКОДА ----
if (contact_cd <= 0 && distance_to_object(obj_player) < 40
    && !obj_player.is_damage)
{
    obj_player.hp       -= atk;
    var _kd = point_direction(x, y, obj_player.x, obj_player.y);
    obj_player.hspd     = lengthdir_x(8, _kd);
    obj_player.vspd     = -5;
    obj_player.is_damage = true;
    obj_player.alarm[0]  = room_speed;
    contact_cd = contact_cd_max;
    enemy_anim_attack(spr_boss_triton_attack);
}
