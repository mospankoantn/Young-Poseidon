/// @description
/// obj_room_transition — Step Event

switch (state)
{
    // ------ 0: ЗАТЕМНЕННЯ ------
    case 0:
        fade_alpha += fade_speed;
        if (fade_alpha >= 1)
        {
            fade_alpha = 1;
            state      = 1;
        }
    break;
 
    // ------ 1: ЗМІНА КІМНАТИ ------
    case 1:
        // Переміщаємо гравця persistent=true або зберігаємо дані
        if (instance_exists(obj_player))
        {
            // Перевіряємо де з'явитися в новій кімнаті
            // Буде оброблено в Room Start Event (дивись нижче)
        }
        room_goto(target_room);
        // Після room_goto цей об'єкт якщо persistent — продовжить роботу
    break;
 
    // ------ 2: ОСВІТЛЕННЯ (після зміни кімнати) ------
    case 2:
        fade_alpha -= fade_speed * 0.7;   // Трохи повільніше освітлення
        if (fade_alpha <= 0)
        {
            fade_alpha = 0;
            instance_destroy();
        }
    break;
}