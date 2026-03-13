/// @description Малювання гравця з анімацією
// obj_player Draw Event

// Ефект блимання під час невразливості
if (is_damage)
{
    // Блимаємо: кожні 4 кадри змінюємо прозорість
    image_alpha = (current_time / 60000) mod 2 < 1 ? 0.4 : 1.0;
}
else
{
    image_alpha = 1;
}
 
// Малюємо гравця (спрайт, xscale та angle встановлені автоматично)
draw_self();