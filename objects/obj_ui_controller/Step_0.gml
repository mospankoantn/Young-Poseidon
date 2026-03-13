/// @description Обробка вводу та паузи

// Обробка натискання ESC для меню
if (keyboard_check_pressed(vk_escape))
{
	room_goto(rm_menu);
}

// Обробка натискання P для паузи (опціонально)
if (keyboard_check_pressed(ord("P")))
{
	if (game_is_paused())
	{
		instance_activate_all();
		game_is_paused_set(false);
	}
	else
	{
		instance_deactivate_all(true);
		game_is_paused_set(true);
	}
}
