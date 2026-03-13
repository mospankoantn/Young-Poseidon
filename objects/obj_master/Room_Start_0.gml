/// @description Ініціалізація на старті кімнати

// Переконуємось, що тризубець ініціалізується правильно
if (instance_exists(obj_player))
{
	// Знаходимо або створюємо тризубець
	var _trident = instance_find(obj_trident, 0);
	if (!instance_exists(_trident))
	{
		_trident = instance_create_layer(obj_player.x + 30, obj_player.y, "Instances", obj_trident);
	}
	obj_player.trident_instance = _trident;
}
