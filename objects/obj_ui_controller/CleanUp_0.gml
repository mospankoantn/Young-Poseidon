/// Release only our own freeze/snapshot when leaving a room.
if (game_paused) yp_pause(false);
if (surface_exists(pause_surface)) surface_free(pause_surface);
if (buffer_exists(pause_backup)) buffer_delete(pause_backup);
if (global.yp_display_pending) yp_display_finish(false);
