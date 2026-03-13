/// @description
/// obj_pickup_weapon_base — Step Event

// Левітація
bob_offset += 0.05;
y           = base_y + sin(bob_offset) * 8;
 
// Обертання
image_angle += 1.5;
 
// Перевірка підбору
if (can_pickup
    && instance_exists(obj_player)
    && place_meeting(x, y, obj_player))
{
    // Викликаємо User Event 0 — перевизначений у кожному нащадку
    event_user(0);
}