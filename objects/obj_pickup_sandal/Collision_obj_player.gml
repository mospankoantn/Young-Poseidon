 /// @description Сандаль Гермеса: перманентно збільшує швидкість гравця
 // obj_pickup_sandal — Collision with obj_player

if (can_pickup)
{
    world_state_mark_instance(id, "pickup");
yp_sfx("pickup", x);
    with (other)
    {
        perm_spd_bonus += 0.3;   
    }
    yp_trigger_hint("sandal", "hint_sandal", 260);
    instance_destroy();
}
