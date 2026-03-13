/// @description Підбір Зілля Сили
 // obj_pickup_potion_strength collision with obj_event Event

if (can_pickup)
{
	with (other) // other - це obj_player
	{
		potion_strength_count++; // Збільшуємо лічильник зілля
	}
	//audio_play_sound(pickup_sound, 1, false);
	instance_destroy();
}