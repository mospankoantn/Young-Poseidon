/// @description 
/// obj_thicket_platform — Create Event

// ---- СТАН ----
is_cleared     = false;    // Хащі скошені?
interact_range = 60;
 
// ---- АНІМАЦІЯ СКОШУВАННЯ ----
cut_timer      = 0;        // Таймер анімації зникнення
is_cutting     = false;    // Зараз у процесі зникнення?
 
// ---- КОЛІЗІЯ ----
// Блокує гравця як тверда поверхня (solid=true за замовчуванням)