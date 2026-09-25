/// @description 
///  obj_fallen_spirit — Destroy Event

if (hp <= 0 && variable_instance_exists(id, "summon_owner") && instance_exists(summon_owner))
{
    enemy_take_hit(summon_owner, 5, x);
}
