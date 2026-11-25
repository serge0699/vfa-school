/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

// Покрытие AXI-Stream прореживателя.

covergroup load_cg(load_cov_collector_cfg cfg)
    with function sample(load_seq_item_base t);

    // Целая часть.
    dec_special_cp: coverpoint load_bitsel_u(t.dec, cfg.dec_width - 1, 0) {
        bins zero  = {0};
        bins max   = {2**cfg.dec_width-1};
        bins other = default;
    }

    // Остаток.
    dec_intervals_cp: coverpoint load_bitsel_u(t.dec, cfg.dec_width - 1, 0) {
        bins intervals [cfg.dec_intervals] = {[0:2**cfg.dec_width-1]};
    }

endgroup
