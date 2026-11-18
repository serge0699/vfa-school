/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

// Пакет для AXI-Stream loopback тестирования.
// Описание тестирования см. в axis_test_loopback.sv
package axis_loopback_pkg;

    // Импорт универсальных компонентов.
    import common_pkg::*;

    // Импорт компонентов и объектов AXI-Stream.
    import axis_pkg::*;
    
    // Импорт компонентов и объектов для
    // генерации сигнала сброса. 
    import reset_pkg::*;

    // Подключение компонентов loopback
    // тестирования.
    `include "axis_test_loopback.sv"

endpackage
