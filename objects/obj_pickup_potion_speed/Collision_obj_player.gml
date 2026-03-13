 /// @description Підбір Зілля Швидкості
 // obj_pickup_potion_speed collision with obj_event Event
 
if (can_pickup)
{
	with (other) // other - це obj_player
	{
		potion_speed_count++; // Збільшуємо лічильник зілля
	}
	//audio_play_sound(pickup_sound, 1, false);
	instance_destroy();
}