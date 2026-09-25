/// @description
/// obj_proj_lightning — Step Event

timer++;
 
if (!struck)
{
    // Фаза попередження: миготливе червоне коло на землі
    if (timer >= warn_time)
    {
        struck = true;
        timer  = 0;
 
        // Удар блискавки
        if (instance_exists(obj_player)
            && point_distance(target_x, target_y, obj_player.x, obj_player.y) < 50
            && !obj_player.is_damage && !obj_player.is_dead)
        {
            obj_player.hp       -= damage;
            obj_player.vspd     = -8;
            obj_player.is_damage = true;
            obj_player.alarm[0]  = room_speed;
        }
        // audio_play_sound(snd_lightning_strike, 1, false);
    }
}
else
{
    // Після удару — зникаємо через 0.5 секунди (показуємо спалах)
    if (timer >= room_speed * 0.5)
        instance_destroy();
}