if(!is_open)
{
    world_state_mark_instance(id, "opened");
    is_open=true;
    open_timer=0;
    yp_sfx("door", x);
}
