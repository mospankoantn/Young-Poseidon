/// @description Select visual state after the existing AI Step.
enemy_anim_update(spr_boss_moirai_idle, spr_boss_moirai_move,
    abs(x - anim_prev_x) > 0.1 || abs(y - anim_prev_y) > 0.1);

