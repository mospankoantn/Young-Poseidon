/// @description Малювання гравця з анімацією
// obj_player Draw Event

// Ефект блимання під час невразливості
if (is_damage && !is_dead)
{
    // Блимаємо: кожні 4 кадри змінюємо прозорість
    image_alpha = (floor(current_time / 70) mod 2 == 0) ? 0.4 : 1.0;
}
else
{
    image_alpha = 1;
}
 
// Малюємо гравця (спрайт, xscale та angle встановлені автоматично)
draw_self();
