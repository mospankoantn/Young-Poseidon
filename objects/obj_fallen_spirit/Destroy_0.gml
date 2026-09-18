/// @description 
///  obj_fallen_spirit — Destroy Event

if (instance_exists(obj_boss_war_ghost))
{
    obj_boss_war_ghost.hp -= 5;  // Кожен вбитий дух = 5 шкоди босу
}