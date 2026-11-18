/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

// Пакет верификационного окружения
// AXI-Stream модуля возведения в степень.
package axis_pow_dv_pkg;

    // Импорт универсальных элементов.
    import common_pkg::*;

    // Импорт AXI-Stream элементов.
    import axis_pkg::*;
    `ifdef QUESTA
        import axis_pkg::axis_bitsel_u;
    `endif

    // Импорт элементов сигнала сброса.
    import reset_pkg::*;

    // Подключение элементов AXI-Stream модуля
    // возведения в степень.
    `include "axis_pow_scoreboard_base.sv"
    `include "axis_pow_env_base.sv"
    `include "axis_pow_test_lib.sv"

endpackage
