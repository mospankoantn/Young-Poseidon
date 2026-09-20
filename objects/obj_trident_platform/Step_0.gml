/// @description Keep this invisible platform tied to ONE throwable weapon.

// Older room data may not contain the owner variable. Recover by nearest
// stuck projectile instead of binding every platform to instance_find(..., 0).
if (!variable_instance_exists(id, "source_throwable"))
{
    source_throwable = instance_nearest(x, y, obj_trident);
}

if (!instance_exists(source_throwable) || !source_throwable.stuck)
{
    instance_destroy();
    exit;
}

// Stay exactly with the projectile that created this platform.
x = source_throwable.x;
y = source_throwable.y;
image_xscale = source_throwable.image_xscale;
