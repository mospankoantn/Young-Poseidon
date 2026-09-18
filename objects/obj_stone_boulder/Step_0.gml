/// @description 
/// obj_stone_boulder — Step Event

if (!instance_exists(obj_player)) exit;
if(hit_cd>0) hit_cd--;
 
// ---- ХИТ-ЕФЕКТ (блимання) ----
if (hit_flash > 0)
{
    hit_flash--;
    image_blend = merge_color(c_white, c_ltgray, hit_flash / 8);
}
else
{
    image_blend = c_white;
}
 
// ---- ВЗАЄМОДІЯ З КАЙЛОМ ----
var _dist = distance_to_object(obj_player);
 
if (_dist <= interact_range && hit_cd<=0
    && !obj_player.is_dead && obj_player.hp > 0
    && obj_player.current_weapon == 2    // 2 = Кайло
    && yp_input("E",true))
{
    hp--;
    hit_cd=12;
    obj_player._play_weapon_action("special");
    hit_flash = 8;
 
    // Оновлюємо стан тріщин
    // image_index залежить від кількості HP що залишилось
    image_index = 0;
 
    // audio_play_sound(snd_boulder_hit, 1, false);
 
    if (hp <= 0)
    {
        // Брила зруйнована
        // audio_play_sound(snd_boulder_break, 1, false);
        // Можна створити частинки каміння:
        // repeat(6) {
        //     var _p = instance_create_layer(x, y, "Instances", obj_rock_particle);
        // }
        instance_destroy();
    }
}
