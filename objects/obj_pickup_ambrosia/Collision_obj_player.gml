/// @description Підбір Амброзії
// obj_pickup_ambrosia collision with obj_event Event

if (can_pickup)
{
	with (other) // other - це obj_player
	{
		max_hp += 1; // Збільшення максимального HP
		hp = max_hp; // Повне відновлення здоров'я
		// Можна додати ефект
	}
	//audio_play_sound(snd_pickup_sound, 1, false);
	instance_destroy();
}