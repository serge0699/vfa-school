/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

// Покрытие AXI-Stream прореживателя.

covergroup axis_decimator_ratio_cg(axis_decimator_cov_collector_cfg cfg)
    with function sample(load_dec_t dec, int trans_am);

    // Целая часть.
    trans_am_dec_div_cp: coverpoint
        trans_am / (load_bitsel_u(dec, cfg.load_dec_width - 1, 0) + 1) {
        bins zero     = {0};
        bins one      = {1};
        bins two_plus = {[2:$]};
    }

    // Остаток.
    trans_am_dec_rem_cp: coverpoint
        trans_am % (load_bitsel_u(dec, cfg.load_dec_width - 1, 0) + 1) {
        bins zero     = {    0};
        bins non_zero = {[1:$]};
    }

endgroup
