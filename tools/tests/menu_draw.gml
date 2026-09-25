if(screenshot!="") {
    if(screenshot=="09-pause.png" && instance_exists(obj_ui_controller)) {
        check(surface_exists(obj_ui_controller.pause_surface),"pause restores frozen scene");
        surface_save(obj_ui_controller.pause_surface,shots+"08c-pause-surface.png");
    }
    screen_save(shots+screenshot);
    screenshot="";
}
