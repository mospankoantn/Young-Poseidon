/// @description Never leave gameplay instances suspended if the screen is removed externally.
resume_suspended_instances();

if (instance_number(obj_cutscene_screen) <= 1)
    global.cutscene_active = false;
