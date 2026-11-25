/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

//  ---------------------- Важно! -----------------------
// | Пакет повторяет пакет из директории:                |
// |   lesson_5/examples/06_axis_decimator/dv/env        |
// | и дополнен моделями покрытия и их сборщиками.       |
// | Окружение задания не меняется — работа только с мо- |
// | делью покрытия и тестовыми сценариями.              |
//  ---------------------- Важно! -----------------------

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
    `include "axis_decimator_cov_collector_cfg.sv"
    `include "axis_decimator_coverage.sv"
    `include "axis_decimator_cov_collector.sv"
    `include "axis_decimator_scoreboard_base.sv"
    `include "axis_decimator_env_base.sv"
    `include "axis_decimator_test_lib.sv"

endpackage
