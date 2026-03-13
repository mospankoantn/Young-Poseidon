/// @description Малювання гравця з анімацією

// Обновляємо анімацію залежно від стану
if (place_meeting(x, y + 1, obj_platform))
{
	// На землі
	is_jumping = false;
	if (vspd == 0 && (l_right || l_left))
	{
		image_index += image_speed; // Анімація ходи
	}
	else if (vspd == 0)
	{
		image_index = 0; // Стояння
	}
}
else
{
	// У повітрі
	is_jumping = true;
	image_index = 1; // Один кадр для стрибка
}

// Запобігаємо перевищенню индексу
if (image_index >= image_number)
{
	image_index = 0;
}

// Рисуємо гравця з применённої анімацією
draw_self();
