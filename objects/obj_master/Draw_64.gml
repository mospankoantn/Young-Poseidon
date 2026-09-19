/// @description Fallback custom cursor when no menu/HUD controller is present.
// Main menu and gameplay HUD draw the cursor themselves at the end of Draw GUI,
// because that guarantees it is not covered by later GUI drawing.
if (!instance_exists(obj_main_menu) && !instance_exists(obj_ui_controller))
    yp_draw_cursor();
