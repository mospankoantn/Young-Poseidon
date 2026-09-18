tick++;
if(second_run) {
    if(tick==20) {
        check(abs(global.yp_settings.master-0.35)<0.001,"volume survives a new process");
        check(global.yp_settings.keys[4]==ord("R"),"bindings survive a new process");
        check(global.lang=="EN","language survives a new process");
        check(!global.yp_settings.fullscreen,"unconfirmed fullscreen not persisted");
        ini_open(YP_SETTINGS_FILE);
        ini_write_real("options","master",9);
        ini_write_real("options","resolution",999);
        ini_write_string("options","language","invalid");
        ini_write_real("keys","0",69);
        ini_write_real("keys","4",69);
        ini_close();
        yp_settings_read();
        check(global.yp_settings.master==1,"invalid volume clamped");
        check(global.yp_settings.resolution==array_length(global.yp_modes)-1,"invalid resolution clamped");
        check(global.lang=="UA" && global.yp_settings.keys[0]==65,"invalid language/bindings repaired");
        check(true,"ALL MENU TESTS");
        game_end();
    }
    exit;
}
switch(tick) {
    case 20: screenshot="01-main-UA.png"; break;
    case 24:
        with(obj_main_menu) {
            yp_menu_action({key:"options",type:"button"},1);
            other.check(menu_page=="options","main menu opens options");
        }
        break;
    case 40: screenshot="02-display-UA.png"; break;
    case 44: obj_main_menu.menu_tab=1; break;
    case 60: screenshot="03-audio-UA.png"; break;
    case 64: obj_main_menu.menu_tab=2; break;
    case 80: screenshot="04-controls-UA.png"; break;
    case 84:
        with(obj_main_menu) {
            yp_menu_action({key:"4",type:"binding"},1);
            other.check(!yp_menu_capture_key(ord("A")),"duplicate binding rejected");
            yp_menu_capture_key(ord("R"));
            other.check(global.yp_settings.keys[4]==ord("R"),"rebind attack");
        }
        check(yp_key_name("E")=="R","gameplay key mapping updated");
        obj_main_menu.menu_tab=3;
        break;
    case 100: screenshot="05-game-UA.png"; break;
    case 104: obj_main_menu.menu_page="about"; break;
    case 120: screenshot="06-about-UA.png"; break;
    case 124: set_language("EN"); obj_main_menu.menu_page="options"; obj_main_menu.menu_tab=2; break;
    case 140: screenshot="07-controls-EN.png"; break;
    case 144:
        yp_display_begin(1,true,true);
        yp_settings_save();
        ini_open(YP_SETTINGS_FILE);
        check(ini_read_real("options","fullscreen",-1)==0,"pending fullscreen not written");
        ini_close();
        break;
    case 160: screenshot="08-display-confirm.png"; break;
    case 164: global.yp_display_deadline=current_time-1; break;
    case 182:
        check(!global.yp_display_pending && !global.yp_settings.fullscreen,"display timeout reverts");
        check(!window_get_fullscreen(),"runner leaves fullscreen");
        yp_display_begin(1,false,true);
        yp_display_finish(true);
        break;
    case 188: start_new_game(); break;
    case 212: screenshot="08b-gameplay.png"; break;
    case 216:
        check(instance_exists(obj_player) && instance_exists(obj_ui_controller),"new game starts");
        var _mode=global.yp_modes[1];
        var _scale=min(1,min((display_get_width()-48)/_mode[0],(display_get_height()-100)/_mode[1]));
        check(window_get_width()==round(_mode[0]*_scale),"confirmed window size survives room change");
        global.yp_settings.auto_pause=false;
        p=instance_find(obj_player,0);
        px=p.x; py=p.y; php=p.hp; pf=p.image_index;
        with(obj_ui_controller) yp_pause(true);
        instance_activate_object(id);
        if(surface_exists(obj_ui_controller.pause_surface))
            surface_save(obj_ui_controller.pause_surface,shots+"08c-pause-surface.png");
        break;
    case 232: screenshot="09-pause.png"; break;
    case 236:
        with(obj_ui_controller) {
            for(var _i=0;_i<array_length(pause_instances);_i++) instance_activate_object(pause_instances[_i]);
        }
        check(p.x==px && p.y==py && p.hp==php && p.image_index==pf,"pause freezes physics HP animation");
        with(obj_ui_controller) {
            for(var _i=0;_i<array_length(pause_instances);_i++) instance_deactivate_object(pause_instances[_i]);
            yp_menu_action({key:"save",type:"button"},1);
            yp_menu_action({key:"about",type:"button"},1);
        }
        instance_activate_object(id);
        check(save_exists(),"save works while actors are suspended");
        break;
    case 248: screenshot="10-pause-about.png"; break;
    case 252:
        with(obj_ui_controller) {
            yp_menu_action({key:"back",type:"button"},1);
            other.check(game_paused && menu_page=="root","back from about stays paused");
            yp_menu_action({key:"options",type:"button"},1);
            menu_tab=1;
        }
        break;
    case 264: screenshot="11-pause-audio.png"; break;
    case 268:
        with(obj_ui_controller) {
            yp_menu_action({key:"back",type:"button"},1);
            yp_menu_action({key:"load",type:"button"},1);
        }
        break;
    case 288:
        check(instance_exists(obj_player) && instance_exists(obj_master),"load restores active gameplay managers");
        check(!obj_ui_controller.game_paused,"load exits pause");
        check(global.yp_settings.keys[4]==ord("R"),"load preserves options");
        global.yp_settings.master=0.35; global.yp_settings.auto_pause=false;
        set_language("EN"); yp_settings_save();
        var _f=file_text_open_write(done); file_text_write_string(_f,"done"); file_text_close(_f);
        game_end();
        break;
}
