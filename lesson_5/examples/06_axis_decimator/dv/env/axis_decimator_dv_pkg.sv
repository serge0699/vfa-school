/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

// Пакет верификационного окружения
// AXI-Stream прореживателя.
package axis_decimator_dv_pkg;

    // Импорт универсальных элементов.
    import common_pkg::*;

    // Импорт AXI-Stream элементов.
    import axis_pkg::*;

    // Импорт элементов сигнала сброса.
    import reset_pkg::*;

    // Импорт компонентов load.
    import load_pkg::*;
    `ifdef QUESTA
        import load_pkg::load_bitsel_u;
    `endif

    // Подключение элементов AXI-Stream прореживателя.
    `include "axis_decimator_scoreboard_base.sv"
    `include "axis_decimator_env_base.sv"
    `include "axis_decimator_test_lib.sv"

endpackage
