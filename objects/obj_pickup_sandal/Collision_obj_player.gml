/// @description Підбір Сандаля
 // obj_pickup_sandal collision with obj_event Event

if (can_pickup)
{
	with (other) // other - це obj_player
	{
		perm_spd_bonus += 0.5; // Збільшення бонусу до швидкості (підберіть значення)
		// Можна додати ефект
	}
	//audio_play_sound(pickup_sound, 1, false);
	instance_destroy();
}