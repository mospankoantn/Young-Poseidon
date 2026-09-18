if(instance_number(obj_debugger)>1) {instance_destroy();exit;}
report="__REPORT__";
done="__DONE__";
shots="__SHOTS__";
tick=0; screenshot="";
depth=-1000000;
second_run=file_exists(done);
check=function(_ok,_message) {
    var _f=file_text_open_append(report);
    file_text_write_string(_f,(_ok ? "PASS: " : "FAIL: ")+_message);
    file_text_writeln(_f); file_text_close(_f);
    if(!_ok) game_end();
};
if(!second_run) {
    global.yp_settings=yp_defaults();
    global.yp_settings.auto_pause=false;
    global.lang="UA";
    yp_apply_audio();
}
