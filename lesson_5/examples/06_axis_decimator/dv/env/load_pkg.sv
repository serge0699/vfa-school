/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

`ifndef DECIMATOR_MAX_DEC_WIDTH
    `define DECIMATOR_MAX_DEC_WIDTH 16
`endif

// Пакет компонентов load.

package load_pkg;

    import common_pkg::*;
    import axis_pkg::*;
    `ifdef QUESTA
        import axis_pkg::axis_bitsel_u;
    `endif

    typedef logic [`DECIMATOR_MAX_DEC_WIDTH-1:0] load_dec_t;

    `include "axis_decimator_load_components.sv"

endpackage
