/// @description Ця платформа існує поки тризубець застряг у стіні. 
// obj_trident_platform Step Event

// Ця платформа існує поки тризубець застряг у стіні.
// Логіку повернення (клавіша 1) обробляє obj_player.
// Тут тільки перевірка: якщо тризубець вже не stuck — знищуємо себе.

var _trident = instance_find(obj_trident, 0);
 
// Якщо тризубець вже повернувся — платформу теж знищуємо
if (!instance_exists(_trident) || !_trident.stuck)
{
    instance_destroy();
}