yp_display_tick();
if (status_timer>0) {
    status_timer--;
    menu_notice=status_text;
    menu_notice_until=current_time+100;
}
yp_menu_step();
