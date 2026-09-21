/// Draw the custom mouse cursor in GUI space. Call this after the current GUI/menu.
function yp_draw_cursor() {
    if (!sprite_exists(spr_cursor_poseidon)) return;

    var _mx = device_mouse_x_to_gui(0);
    var _my = device_mouse_y_to_gui(0);
    if (_mx < 0 || _my < 0) return;

    // A small shadow keeps the cursor visible over bright sand, water and white UI.
    var _scale = 1.5;
    draw_set_alpha(0.55);
    draw_set_color(c_black);
    draw_sprite_ext(spr_cursor_poseidon, 0, _mx + 2, _my + 2, _scale, _scale, 0, c_black, 0.55);

    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_sprite_ext(spr_cursor_poseidon, 0, _mx, _my, _scale, _scale, 0, c_white, 1);

    draw_set_alpha(1);
    draw_set_color(c_white);
}

/// Shared menu state is owned by obj_main_menu or obj_ui_controller.
function yp_menu_refresh_slots() {
    save_slots_migrate_legacy();
    menu_slot_status=array_create(11,0);
    menu_slot_room=array_create(11,-1);
    menu_has_save=false;
    for(var _i=0;_i<=10;_i++) {
        menu_slot_status[_i]=save_slot_status(_i);
        if(menu_slot_status[_i]>=1) menu_slot_room[_i]=save_slot_room(_i);
        if(menu_slot_status[_i]!=0) menu_has_save=true;
    }
}

function yp_menu_room_label(_room) {
    if(_room==-1 || !room_exists(_room)) return "";
    var _name=room_get_name(_room);
    var _prefix="";
    var _zone="";

    if(string_pos("rm_sea_",_name)==1) { _prefix="rm_sea_"; _zone=yp_text("Море","Sea"); }
    else if(string_pos("rm_coast_",_name)==1) { _prefix="rm_coast_"; _zone=yp_text("Узбережжя","Coast"); }
    else if(string_pos("rm_mines_",_name)==1) { _prefix="rm_mines_"; _zone=yp_text("Шахти","Mines"); }
    else if(string_pos("rm_hades_",_name)==1) { _prefix="rm_hades_"; _zone=yp_text("Аїд","Hades"); }
    else if(string_pos("rm_greece_",_name)==1) { _prefix="rm_greece_"; _zone=yp_text("Греція","Greece"); }
    else if(string_pos("rm_battlefield_",_name)==1) { _prefix="rm_battlefield_"; _zone=yp_text("Поля битви","Battlefield"); }
    else if(string_pos("rm_olympus_",_name)==1) { _prefix="rm_olympus_"; _zone=yp_text("Олімп","Olympus"); }
    else if(_name=="rm_test") return yp_text("Тестова кімната","Test room");
    else return _name;

    var _number=string_copy(_name,string_length(_prefix)+1,string_length(_name));
    return _zone+" "+_number;
}

function yp_menu_save_slot(_slot) {
    // While paused the gameplay actors are inactive. Save the snapshot captured
    // at pause entry instead of trying to reactivate them inside the same event.
    var _snapshot=menu_is_pause ? pause_save_snapshot : undefined;
    var _unsafe=is_struct(_snapshot) && (_snapshot.is_dead || !_snapshot.save_position_safe);
    var _ok=save_game(_slot,true,_snapshot);
    yp_menu_refresh_slots();
    menu_notice=lc(_ok ? "save_done" : (_unsafe ? "save_unsafe_position" : "save_failed"));
    menu_notice_until=current_time+3000;
    return _ok;
}

function yp_menu_init(_pause) {
    yp_settings_init();
    menu_is_pause=_pause; menu_page="root"; menu_tab=0; menu_selected=0;
    menu_hover=-1; menu_capture=-1; menu_drag=-1; menu_notice="";
    menu_notice_until=0; menu_confirm=""; menu_pending_slot=-1; menu_return_selected=0;
    menu_mouse_x=-1; menu_mouse_y=-1;
    menu_slot_status=array_create(11,0); menu_slot_room=array_create(11,-1); menu_has_save=false;
    yp_menu_refresh_slots();
    pause_surface=-1; pause_instances=[]; pause_save_snapshot=undefined; game_paused=false;
    pause_backup=-1; pause_width=0; pause_height=0;
    menu_focus=window_has_focus();
}

function yp_pause(_enable) {
    if (_enable == game_paused) return;
    if (_enable) {
        with (obj_weapon_selector) instance_destroy();
        if (surface_exists(pause_surface)) {
            pause_width=surface_get_width(pause_surface);
            pause_height=surface_get_height(pause_surface);
            pause_backup=buffer_create(pause_width*pause_height*4,buffer_fixed,1);
            buffer_get_surface(pause_backup,pause_surface,0);
        }
        // Capture progress before deactivation; deactivated instances can no longer
        // be discovered through instance_exists/instance_find.
        pause_save_snapshot=undefined;
        if(instance_exists(obj_player))
            pause_save_snapshot=_save_capture_player(instance_find(obj_player,0));

        pause_instances=[];
        var _owner=id;
        with (all) {
            // Modal cutscene UI must remain active while gameplay actors are paused.
            if (id != _owner && object_index != obj_cutscene_screen)
                array_push(other.pause_instances,id);
        }
        for (var _i=0; _i<array_length(pause_instances); _i++)
            instance_deactivate_object(pause_instances[_i]);
        game_paused=true;
        menu_page="root"; menu_selected=0; yp_menu_refresh_slots();
    } else {
        // Only restore instances this menu suspended, not intentionally inactive actors.
        for (var _i=0; _i<array_length(pause_instances); _i++)
            instance_activate_object(pause_instances[_i]);
        pause_instances=[]; pause_save_snapshot=undefined; game_paused=false;
        if (surface_exists(pause_surface)) surface_free(pause_surface);
        pause_surface=-1;
        if(buffer_exists(pause_backup)) buffer_delete(pause_backup);
        pause_backup=-1;
        _update_player_weapon_names();
        keyboard_clear(vk_escape);
        keyboard_clear(vk_enter);
        keyboard_clear(vk_space);
    }
}

function yp_capture_world() {
    // Capture in Draw GUI, while the completed application surface is available.
    if(!surface_exists(application_surface)) return;
    var _w=surface_get_width(application_surface),_h=surface_get_height(application_surface);
    if(surface_exists(pause_surface)) {
        if(surface_get_width(pause_surface)!=_w || surface_get_height(pause_surface)!=_h)
            surface_free(pause_surface);
    }
    if(!surface_exists(pause_surface)) pause_surface=surface_create(_w,_h);
    surface_copy(pause_surface,0,0,application_surface);
}

function yp_menu_rows() {
    if (global.yp_display_pending) return [
        {label:yp_text("Залишити","Keep"),key:"keep",type:"button"},
        {label:yp_text("Повернути попередні","Revert"),key:"revert",type:"button"}];
    if (menu_page=="confirm") return [
        {label:yp_text("Скасувати","Cancel"),key:"cancel",type:"button"},
        {label:yp_text("Підтвердити","Confirm"),key:"confirm",type:"button"}];
    if (menu_page=="about") return [{label:yp_text("Назад","Back"),key:"back",type:"button"}];
    if (menu_page=="save_slots") {
        var _save_rows=[];
        for(var _slot=1;_slot<=10;_slot++)
            array_push(_save_rows,{label:yp_text("Слот ","Slot ")+string(_slot),key:"slot_save",type:"slot",slot:_slot});
        array_push(_save_rows,{label:yp_text("Назад","Back"),key:"back",type:"button"});
        return _save_rows;
    }
    if (menu_page=="load_slots") {
        var _load_rows=[{label:yp_text("Автозбереження","Autosave"),key:"slot_load",type:"slot",slot:0}];
        for(var _slot=1;_slot<=10;_slot++)
            array_push(_load_rows,{label:yp_text("Слот ","Slot ")+string(_slot),key:"slot_load",type:"slot",slot:_slot});
        array_push(_load_rows,{label:yp_text("Назад","Back"),key:"back",type:"button"});
        return _load_rows;
    }
    if (menu_page=="root") {
        if (menu_is_pause) return [
            {label:lc("pause_resume"),key:"resume",type:"button"},
            {label:lc("pause_save"),key:"save",type:"button"},
            {label:lc("pause_load"),key:"load",type:"button"},
            {label:lc("menu_settings"),key:"options",type:"button"},
            {label:lc("menu_about"),key:"about",type:"button"},
            {label:lc("pause_mainmenu"),key:"main",type:"button"},
            {label:lc("pause_quit"),key:"quit",type:"button"}];
        return [
            {label:lc("menu_start"),key:"new",type:"button"},
            {label:lc("menu_load"),key:"load",type:"button"},
            {label:lc("menu_settings"),key:"options",type:"button"},
            {label:lc("menu_about"),key:"about",type:"button"},
            {label:lc("menu_exit"),key:"quit",type:"button"}];
    }
    var _rows=[];
    switch(menu_tab) {
        case 0: _rows=[
            {label:yp_text("Розмір вікна","Window resolution"),key:"resolution",type:"choice"},
            {label:yp_text("Повноекранний режим","Fullscreen"),key:"fullscreen",type:"toggle"},
            {label:"VSync",key:"vsync",type:"toggle"},
            {label:yp_text("Згладжування пікселів","Pixel smoothing"),key:"smoothing",type:"toggle"}]; break;
        case 1: _rows=[
            {label:yp_text("Загальна гучність","Master volume"),key:"master",type:"slider"},
            {label:yp_text("Музика","Music"),key:"music",type:"slider"},
            {label:yp_text("Звукові ефекти","Sound effects"),key:"sfx",type:"slider"},
            {label:yp_text("Перевірити звук","Test sound"),key:"test_sound",type:"button"}]; break;
        case 2:
            var _names=global.lang=="UA"
                ? ["Ліворуч","Праворуч","Стрибок","Спуск крізь платформу","Атака / дія","Взаємодія / повернути зброю","Закрити діалог","Зілля здоров'я","Зілля сили","Зілля швидкості"]
                : ["Move left","Move right","Jump","Drop through platform","Attack / action","Interact / recall weapon","Close dialogue","Health potion","Strength potion","Speed potion"];
            for(var _i=0;_i<10;_i++) array_push(_rows,{label:_names[_i],key:string(_i),type:"binding"});
            break;
        case 3: _rows=[
            {label:yp_text("Мова","Language"),key:"language",type:"choice"},
            {label:yp_text("Автопауза поза вікном","Pause when unfocused"),key:"auto_pause",type:"toggle"},
            {label:yp_text("Підказки","Hints"),key:"hints",type:"toggle"}]; break;
    }
    array_push(_rows,{label:yp_text("Скинути вкладку","Reset tab"),key:"defaults",type:"button"});
    array_push(_rows,{label:yp_text("Назад","Back"),key:"back",type:"button"});
    return _rows;
}

function yp_menu_rect(_index,_count) {
    if (global.yp_display_pending || menu_page=="confirm")
        return [230+_index*260,382,240,48];
    if(menu_page=="about") return [180,550,180,42];
    if(menu_page=="save_slots" || menu_page=="load_slots") return [126,142+_index*34,708,30];
    if(menu_page=="root") return menu_is_pause ? [246,180+_index*44,468,40] : [56,282+_index*49,322,43];
    if(_index>=_count-2) return [126+(_index-(_count-2))*510,550,198,40];
    return [126,188+_index*34,708,32];
}

function yp_menu_value(_row) {
    var _s=global.yp_settings;
    var _key=_row.key;
    if(_row.type=="slot") {
        var _status=menu_slot_status[_row.slot];
        if(_status==0) return yp_text("Порожньо","Empty");
        if(_status==-2) return yp_text("Несумісне","Incompatible");
        if(_status<0) return yp_text("Пошкоджено","Corrupted");
        var _level=yp_menu_room_label(menu_slot_room[_row.slot]);
        if(_level=="") return yp_text("Збережено","Saved");
        return yp_text("Рівень: ","Level: ")+_level;
    }
    if(_row.type=="binding") return chr(_s.keys[real(_key)]);
    if(_key=="resolution") {
        var _m=global.yp_modes[_s.resolution]; return string(_m[0])+" x "+string(_m[1]);
    }
    if(_key=="language") return _s.language=="UA" ? "Українська" : "English";
    if(_row.type=="toggle") return variable_struct_get(_s,_key) ? yp_text("Увімкнено","On") : yp_text("Вимкнено","Off");
    if(_row.type=="slider") return string(round(variable_struct_get(_s,_key)*100))+"%";
    return "";
}

function yp_menu_action(_row,_direction) {
    var _key=_row.key;
    var _s=global.yp_settings;

    if(_row.type=="slot") {
        var _slot=_row.slot;
        if(_key=="slot_load") {
            if(menu_slot_status[_slot]==0) return;
            if(menu_is_pause) yp_pause(false);
            load_game(_slot);
            return;
        }
        if(_key=="slot_save") {
            if(menu_slot_status[_slot]!=0) {
                menu_pending_slot=_slot;
                menu_confirm="overwrite";
                menu_page="confirm";
                menu_selected=0;
                return;
            }
            yp_menu_save_slot(_slot);
            return;
        }
    }

    if(_row.type=="slider") {
        variable_struct_set(_s,_key,clamp(variable_struct_get(_s,_key)+0.05*_direction,0,1));
        yp_apply_audio(); yp_settings_save(); return;
    }
    if(_row.type=="binding") {
        menu_capture=real(_key);
        menu_notice=yp_text("Натисніть літеру A-Z. Esc: скасувати.","Press a letter A-Z. Esc: cancel.");
        menu_notice_until=current_time+60000;
        return;
    }
    switch(_key) {
        case "resolution": yp_display_begin((_s.resolution+_direction+array_length(global.yp_modes)) mod array_length(global.yp_modes),_s.fullscreen,_s.vsync); menu_selected=1; break;
        case "fullscreen": yp_display_begin(_s.resolution,!_s.fullscreen,_s.vsync); menu_selected=1; break;
        case "vsync": yp_display_begin(_s.resolution,_s.fullscreen,!_s.vsync); menu_selected=1; break;
        case "smoothing": _s.smoothing=!_s.smoothing; gpu_set_texfilter(_s.smoothing); yp_settings_save(); break;
        case "auto_pause": _s.auto_pause=!_s.auto_pause; yp_settings_save(); break;
        case "hints": _s.hints=!_s.hints; yp_settings_save(); break;
        case "language": set_language(_s.language=="UA" ? "EN" : "UA"); break;
        case "test_sound": audio_play_sound(snd_swing,1,false); break;
        case "keep": yp_display_finish(true); menu_selected=0; break;
        case "revert": yp_display_finish(false); menu_selected=0; break;
        case "back":
            menu_page="root"; menu_selected=menu_return_selected; menu_notice=""; break;
        case "options": menu_return_selected=menu_is_pause ? 3 : 2; menu_page="options"; menu_selected=0; menu_tab=0; break;
        case "about": menu_return_selected=menu_is_pause ? 4 : 3; menu_page="about"; menu_selected=0; break;
        case "resume": yp_pause(false); break;
        case "save":
            menu_return_selected=1; menu_page="save_slots"; menu_selected=0; yp_menu_refresh_slots(); break;
        case "load":
            if(!menu_has_save) break;
            menu_return_selected=menu_is_pause ? 2 : 1; menu_page="load_slots"; menu_selected=0; yp_menu_refresh_slots(); break;
        case "new":
            if(!menu_has_save) { start_new_game(); break; }
            menu_confirm="new"; menu_page="confirm"; menu_selected=0; break;
        case "main":
        case "quit":
            menu_confirm=_key; menu_page="confirm"; menu_selected=0; break;
        case "cancel":
            if(menu_confirm=="overwrite") {
                menu_confirm=""; menu_page="save_slots"; menu_selected=max(0,menu_pending_slot-1);
            } else {
                menu_confirm=""; menu_page="root"; menu_selected=0;
            }
            break;
        case "confirm":
            if(menu_confirm=="overwrite") {
                var _slot_to_save=menu_pending_slot;
                menu_confirm=""; menu_page="save_slots"; menu_selected=max(0,_slot_to_save-1);
                yp_menu_save_slot(_slot_to_save);
            } else {
                if(menu_is_pause) yp_pause(false);
                if(menu_confirm=="quit") game_end();
                else if(menu_confirm=="main") { with(obj_player) instance_destroy(); room_goto(rm_menu); }
                else start_new_game();
            }
            break;
        case "defaults":
            var _d=yp_defaults();
            switch(menu_tab) {
                case 0:
                    _s.smoothing=_d.smoothing;
                    yp_display_begin(_d.resolution,_d.fullscreen,_d.vsync);
                    menu_selected=1; break;
                case 1: _s.master=_d.master; _s.music=_d.music; _s.sfx=_d.sfx; yp_apply_audio(); break;
                case 2: _s.keys=_d.keys; break;
                case 3: _s.auto_pause=_d.auto_pause; _s.hints=_d.hints; set_language(_d.language); break;
            }
            yp_settings_save(); break;
    }
}

function yp_menu_capture_key(_key) {
    if(menu_capture<0 || _key<65 || _key>90) return false;
    for(var _i=0;_i<10;_i++) {
        if(_i!=menu_capture && global.yp_settings.keys[_i]==_key) {
            menu_notice=yp_text("Ця клавіша вже зайнята. Оберіть іншу.","That key is already assigned. Choose another.");
            return false;
        }
    }
    global.yp_settings.keys[menu_capture]=_key;
    yp_settings_save(); menu_capture=-1; menu_notice="";
    return true;
}

function yp_menu_step() {
    var _mx=device_mouse_x_to_gui(0), _my=device_mouse_y_to_gui(0);
    var _moved=(_mx!=menu_mouse_x || _my!=menu_mouse_y);
    menu_mouse_x=_mx; menu_mouse_y=_my;
    if(menu_capture>=0) {
        if(keyboard_check_pressed(vk_escape)) {menu_capture=-1; menu_notice=""; return;}
        for(var _key=65;_key<=90;_key++) if(keyboard_check_pressed(_key)) {
            yp_menu_capture_key(_key);
            break;
        }
        return;
    }
    if(keyboard_check_pressed(vk_escape)) {
        if(menu_drag>=0) {menu_drag=-1; yp_settings_save();}
        if(global.yp_display_pending) yp_display_finish(false);
        else if(menu_page!="root") {
            if(menu_page=="confirm" && menu_confirm=="overwrite") {
                menu_confirm=""; menu_page="save_slots"; menu_selected=max(0,menu_pending_slot-1);
            } else {
                menu_page="root"; menu_selected=menu_return_selected;
            }
        }
        else if(menu_is_pause) yp_pause(false);
        else { menu_confirm="quit"; menu_page="confirm"; menu_selected=0; }
        return;
    }
    if(menu_page=="options" && !global.yp_display_pending) {
        if(keyboard_check_pressed(vk_tab)) {menu_tab=(menu_tab+1) mod 4; menu_selected=0; menu_drag=-1; menu_notice="";}
        if(mouse_check_button_pressed(mb_left) && _my>=132 && _my<170 && _mx>=126 && _mx<834) {
            menu_tab=clamp(floor((_mx-126)/177),0,3); menu_selected=0; menu_drag=-1; menu_notice=""; return;
        }
    }
    var _rows=yp_menu_rows(), _count=array_length(_rows);
    menu_selected=clamp(menu_selected,0,_count-1);
    if(keyboard_check_pressed(vk_down)) menu_selected=(menu_selected+1) mod _count;
    if(keyboard_check_pressed(vk_up)) menu_selected=(menu_selected+_count-1) mod _count;
    menu_hover=-1;
    for(var _i=0;_i<_count;_i++) {
        var _r=yp_menu_rect(_i,_count);
        if(point_in_rectangle(_mx,_my,_r[0],_r[1],_r[0]+_r[2],_r[1]+_r[3])) {
            menu_hover=_i;
            if(_moved) menu_selected=_i;
        }
    }
    if(menu_drag>=0) {
        if(mouse_check_button(mb_left)) {
            var _key=_rows[menu_drag].key;
            variable_struct_set(global.yp_settings,_key,clamp((_mx-580)/170,0,1));
            yp_apply_audio();
        } else {menu_drag=-1; yp_settings_save();}
        return;
    }
    var _click=mouse_check_button_pressed(mb_left) && menu_hover>=0;
    if(_click) menu_selected=menu_hover;
    var _row=_rows[menu_selected];
    if(_row.key=="load" && !menu_has_save) return;
    if(_row.type=="slot" && _row.key=="slot_load" && menu_slot_status[_row.slot]==0) return;
    var _dir=keyboard_check_pressed(vk_right)-keyboard_check_pressed(vk_left);
    if(_click || keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space) || (_dir!=0 && _row.type!="button" && _row.type!="binding")) {
        if(_click && _row.type=="slider") {
            menu_drag=menu_selected;
            variable_struct_set(global.yp_settings,_row.key,clamp((_mx-580)/170,0,1));
            yp_apply_audio(); yp_settings_save(); return;
        }
        if(_click && _row.type=="choice") _dir=(_mx<650) ? -1 : 1;
        yp_menu_action(_row,_dir==0 ? 1 : _dir);
    }
}

function yp_menu_draw() {
    var _gold=make_color_rgb(248,205,113), _teal=make_color_rgb(83,206,188);
    var _ink=make_color_rgb(7,23,31), _soft=make_color_rgb(180,205,212);
    draw_set_alpha(1); draw_set_halign(fa_left); draw_set_valign(fa_middle);
    var _modal=global.yp_display_pending || menu_page=="confirm";
    if(!menu_is_pause) {
        draw_sprite_stretched(Menu_bg,0,0,0,960,640);
        draw_set_alpha(0.14); draw_set_color(c_black); draw_rectangle(0,0,960,640,false); draw_set_alpha(1);
    } else {
        if(!surface_exists(pause_surface) && buffer_exists(pause_backup)) {
            pause_surface=surface_create(pause_width,pause_height);
            buffer_set_surface(pause_backup,pause_surface,0);
        }
        draw_set_color(_ink); draw_rectangle(0,0,960,640,false);
        if(surface_exists(pause_surface)) draw_surface_stretched(pause_surface,0,0,960,640);
        draw_set_alpha(0.7); draw_set_color(c_black); draw_rectangle(0,0,960,640,false); draw_set_alpha(1);
    }
    if(menu_page=="root" && !_modal && !menu_is_pause) {
        draw_set_font(fnt_title); draw_set_color(_gold);
        draw_text_transformed(56,133,"YOUNG",1.25,1.25,0);
        draw_set_color(c_white); draw_text_transformed(53,180,"POSEIDON",1.65,1.65,0);
        draw_set_color(_gold); draw_rectangle(56,224,112,227,false);
        draw_set_font(fnt_main); draw_set_color(_soft);
        draw_text(56,246,yp_text("Від моря до Олімпу","From the sea to Olympus"));
        draw_text(56,602,yp_text("Олег Табович","Oleh Tabovych"));
    } else {
        var _x=menu_page=="root" ? 210 : 100;
        var _w=menu_page=="root" ? 540 : 760;
        draw_set_color(_ink); draw_set_alpha(0.96);
        draw_rectangle(_x,64,_x+_w,600,false); draw_set_alpha(1);
        draw_set_color(_teal); draw_rectangle(_x,64,_x+_w,67,false);
        draw_set_font(fnt_title); draw_set_color(c_white);
        var _title=menu_page=="root" ? lc("pause_title") : (menu_page=="about" ? lc("menu_about") : lc("menu_settings"));
        if(menu_page=="save_slots") _title=yp_text("Зберегти гру","Save Game");
        if(menu_page=="load_slots") _title=yp_text("Завантажити гру","Load Game");
        if(_modal) _title=yp_text("Підтвердження","Confirmation");
        draw_text(_x+26,100,_title);
    }
    draw_set_font(fnt_main);
    if(_modal) {
        draw_set_color(c_white); draw_set_valign(fa_top);
        var _message=yp_text("Вийти з гри?","Quit the game?");
        if(global.yp_display_pending) _message=yp_text("Залишити ці параметри екрана?","Keep these display settings?")
            +"\n"+yp_text("Автоматичне повернення через ","Automatic revert in ")+string(max(0,ceil((global.yp_display_deadline-current_time)/1000)))+yp_text(" с."," s.");
        else if(menu_confirm=="new") _message=yp_text("Розпочати нову гру? Попередні слоти збереження\nзалишаться без змін.","Start a new game? Existing save slots\nwill remain unchanged.");
        else if(menu_confirm=="overwrite") _message=yp_text("Перезаписати слот ","Overwrite slot ")+string(menu_pending_slot)+"?";
        else if(menu_is_pause) _message=yp_text("Незбережений прогрес буде втрачено.\nПродовжити?","Unsaved progress will be lost.\nContinue?");
        draw_text_ext(180,232,_message,30,600);
        draw_set_valign(fa_middle);
    } else if(menu_page=="options") {
        var _tabs=global.lang=="UA" ? ["Екран","Звук","Керування","Гра"] : ["Display","Audio","Controls","Game"];
        for(var _i=0;_i<4;_i++) {
            draw_set_color(_i==menu_tab ? _gold : _soft);
            draw_text(140+177*_i,150,_tabs[_i]);
            if(_i==menu_tab) draw_rectangle(126+177*_i,169,285+177*_i,171,false);
        }
        if(menu_tab==0) {
            draw_set_color(_soft);
            draw_text(142,366,yp_text("Повний екран: роздільність робочого столу.","Fullscreen: desktop resolution."));
        }
    } else if(menu_page=="about") {
        draw_set_font(fnt_title); draw_set_color(_gold); draw_text(180,179,"Young Poseidon");
        draw_set_color(c_white); draw_text(180,236,yp_text("Олег Табович","Oleh Tabovych"));
        draw_set_font(fnt_main); draw_set_color(_teal);
        draw_text(180,272,yp_text("Автор і розробник","Creator & Developer"));
        draw_set_color(c_white); draw_set_valign(fa_top);
        draw_text_ext(180,322,yp_text(
            "Пригодницький 2D-платформер за мотивами грецької міфології.\n\nРушій: GameMaker. Програмування: GML.\n\nУ розробці коду та графіки використано інструменти ШІ.\nДизайн, інтеграція та перевірка ігрових систем: Олег Табович.",
            "A 2D adventure platformer inspired by Greek mythology.\n\nEngine: GameMaker. Programming: GML.\n\nAI tools assisted with code and artwork.\nGame design, integration and system verification: Oleh Tabovych."),24,600);
        draw_set_valign(fa_middle);
    }
    var _rows=yp_menu_rows(),_count=array_length(_rows);
    for(var _i=0;_i<_count;_i++) {
        var _row=_rows[_i],_r=yp_menu_rect(_i,_count),_sel=(_i==menu_selected);
        var _disabled=(_row.key=="load" && !menu_has_save)
            || (_row.type=="slot" && _row.key=="slot_load" && menu_slot_status[_row.slot]==0);
        if(_sel && !_disabled) {
            draw_set_alpha(0.2); draw_set_color(_teal);
            draw_rectangle(_r[0],_r[1],_r[0]+_r[2],_r[1]+_r[3],false); draw_set_alpha(1);
            draw_set_color(_gold); draw_rectangle(_r[0],_r[1]+5,_r[0]+3,_r[1]+_r[3]-5,false);
        }
        draw_set_color(_disabled ? make_color_rgb(115,132,140) : (_sel ? _gold : c_white));
        draw_text(_r[0]+16,_r[1]+_r[3]/2,_row.label);
        var _v=yp_menu_value(_row);
        if(_row.type=="slider") {
            var _amount=variable_struct_get(global.yp_settings,_row.key);
            draw_set_color(make_color_rgb(53,74,82)); draw_rectangle(580,_r[1]+14,750,_r[1]+18,false);
            draw_set_color(_teal); draw_rectangle(580,_r[1]+14,580+170*_amount,_r[1]+18,false);
            draw_set_color(_gold); draw_circle(580+170*_amount,_r[1]+16,5,false);
        }
        if(_row.type=="toggle") {
            var _on=variable_struct_get(global.yp_settings,_row.key);
            draw_set_color(_on ? _teal : _soft); draw_rectangle(620,_r[1]+8,636,_r[1]+24,true);
            if(_on) { draw_line(623,_r[1]+15,627,_r[1]+20); draw_line(627,_r[1]+20,634,_r[1]+11); }
        }
        if(_row.type=="choice") {
            draw_set_color(_soft); draw_text(580,_r[1]+16,"<"); draw_text(817,_r[1]+16,">");
        }
        if(_row.type=="binding" && menu_capture==real(_row.key)) _v="...";
        draw_set_color(_sel ? _gold : _soft); draw_set_halign(fa_right);
        draw_text(808,_r[1]+_r[3]/2,_v); draw_set_halign(fa_left);
    }
    if(menu_notice!="" && current_time<menu_notice_until && !_modal) {
        draw_set_color(_gold); draw_set_halign(fa_center);
        draw_text(480,menu_page=="options" ? 532 : 573,menu_notice); draw_set_halign(fa_left);
    }
    draw_set_alpha(1); draw_set_color(c_white); draw_set_font(-1); draw_set_valign(fa_top);
}
