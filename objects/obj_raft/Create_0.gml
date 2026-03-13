/// @description 
/// obj_raft — Create Event

// ---- РУХ ----
raft_spd       = 0;       // Поточна швидкість плоту
raft_spd_max   = 3;       // Максимальна швидкість
raft_friction  = 0.15;    // Уповільнення
 
// ---- СТАН ----
has_player     = false;   // Чи стоїть гравець на плоту зараз
player_was_on  = false;   // Для плавного відстеження
 
// ---- ГОЙДАННЯ (анімація) ----
bob_timer      = 0;
base_y         = y;