/// @description Сандаль Гермеса: перманентно збільшує швидкість гравця
 // obj_pickup_sandal — Collision with obj_player

if (can_pickup)
{
    with (other)
    {
        perm_spd_bonus += 1;   // +1 з документу (було 0.3)
    }
    instance_destroy();
}