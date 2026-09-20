/// @description Legacy helper retained for compatibility.
/// Projectile ownership is initialized by obj_player Room Start.

if (instance_exists(obj_player))
{
    var _p = instance_find(obj_player, 0);
    if (variable_instance_exists(_p, "throwable_instances"))
    {
        for (var _wi = 0; _wi < 2; _wi++)
            if (_p.weapon_unlocked[_wi]) _p._find_throwable(_wi, true);
    }
}
