/// @description Підбір Зілля Здоров\'я
// obj_pickup_potion_heal collision with obj_event Event

if (can_pickup)
{
	with (other) // other - це obj_player
	{
		potion_heal_count++; // Збільшуємо лічильник зілля
	}
	
	instance_destroy();
}
