/// @description 
/// obj_raft — Step Event

// ---- ПЕРЕВІРКА ЧИ ГРАВЕЦЬ СТОЇТЬ НА ПЛОТУ ----
// Гравець стоїть на плоту якщо він зверху і падає на нього
has_player = false;
 
if (instance_exists(obj_player) && !obj_player.is_dead && obj_player.hp > 0)
{
    var _px = obj_player.x;
    var _py = obj_player.y;
 
    // Перевіряємо чи гравець знаходиться прямо над плотом
    var _on_raft = (_px > x - sprite_width / 2
                 && _px < x + sprite_width / 2
                 && _py >= y - sprite_height / 2 - 4
                 && _py <= y - sprite_height / 2 + 8
                 && obj_player.vspd >= 0);
 
    if (_on_raft)
    {
        has_player = true;
 
        // "Прилипаємо" гравця до верху плоту
        obj_player.y    = y - sprite_height / 2;
        obj_player.vspd = 0;
 
        // ---- КЕРУВАННЯ ПЛОТОМ (тільки з веслом) ----
        if (obj_player.current_weapon == 4)   // 4 = Весло
        {
            var _left  = keyboard_check(ord("A")) || keyboard_check(vk_left);
            var _right = keyboard_check(ord("D")) || keyboard_check(vk_right);
 
            if (_right) raft_spd = min(raft_spd + 0.3, raft_spd_max);
            if (_left)  raft_spd = max(raft_spd - 0.3, -raft_spd_max);
            if ((_left || _right) && obj_player.anim_action_timer <= 0)
                obj_player._play_weapon_action("special");
 
            // Пліт рухає гравця разом із собою
            obj_player.x += raft_spd;
        }
    }
}
 
// ---- ТЕРТЯ (уповільнення) ----
raft_spd *= (1 - raft_friction);
if (abs(raft_spd) < 0.1) raft_spd = 0;
 
// ---- РУХ ПЛОТУ ----
// Перевіряємо межі (не виходимо за стіни)
if (!place_meeting(x + raft_spd, y, obj_platform))
    x += raft_spd;
else
    raft_spd = 0;
 
// ---- ГОЙДАННЯ НА ВОДІ ----
bob_timer += 0.04;
y          = base_y + sin(bob_timer) * 3;
