yp_settings_init();
if (variable_global_exists("zone_music_voice") && audio_is_playing(global.zone_music_voice))
    audio_stop_sound(global.zone_music_voice);
global.zone_music_asset = -1;
audio_stop_sound(snd_olympus_overture);
music_voice=audio_play_sound(snd_olympus_overture,10,true);
yp_apply_audio();
