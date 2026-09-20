/// @description Ініціалізація метальної зброї при переході до нової кімнати
// obj_player Room Start Event

// Старі екземпляри з попередньої кімнати не persistent. Відновлюємо окремо
// тризубець і спис, якщо вони вже розблоковані.
throwable_instances[0] = noone;
throwable_instances[1] = noone;

for (var _wi = 0; _wi < 2; _wi++)
{
    if (weapon_unlocked[_wi])
        _find_throwable(_wi, true);
}

if (current_weapon >= 0 && current_weapon <= 1)
    trident_instance = _find_throwable(current_weapon, false);
else
    trident_instance = noone;

if (!apply_pending_load_to_player())
    apply_pending_checkpoint_respawn_to_player();

_reset_player_animation();
