/// @description 
/// obj_minotaur_column — Step Event

if (hp <= 0)
{
    // Колона руйнується — гравець падає вниз
    instance_destroy();
    exit;
}
image_index = clamp(5 - hp, 0, 4);