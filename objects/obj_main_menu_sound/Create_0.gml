/// @description Ініціалізація музики меню
/// obj_main_menu_sound — Create Event

// 1. Починаємо відтворення звуку
// 'm_main_menu' — назва вашого аудіо-асету
// '10' — пріоритет, 'true' — циклічне відтворення
var _music = audio_play_sound(snd_olympus_overture, 10, true);

// 2. Миттєво встановлюємо гучність на 0 (час = 0 мс)
audio_sound_gain(_music, 0, 0);

// 3. Плавно збільшуємо гучність до максимуму (1.0) за 3000 мс (3 секунди)
audio_sound_gain(_music, 0.7, 10000);
