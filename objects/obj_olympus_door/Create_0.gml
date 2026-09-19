/// @description Двері що відкриваються ключем
/// obj_olympus_door — Create Event

is_open       = false;
open_timer    = 0;       // Лічильник анімації відкриття
 
// Підказка гравцю
interact_range = 80;
 
// image_index: 0=зачинені, 1-4=анімація відкриття, 5=відкриті
image_index   = 0;
image_speed   = 0;
if (world_state_has(world_state_instance_key(id, "opened")))
{
    is_open = true;
    open_timer = 30;
    solid = false;
    sprite_index = -1;
    mask_index = -1;
}
