/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

`include "axis_defines.svh"

// Пакет верификационных компонентов и объектов AXI-Stream.
// Соответствует спецификации ARM IHI 0051B.
// Реализована поддержка сигналов TVALID, TREADY, TDATA,
// TID, TLAST. Интересно: минимальный AXI-Stream - это
// просто TVALID.

package axis_pkg;

    // Импорт универсальных компонентов и объектов.
    import common_pkg::*;

    // Подключение компонентов и объектов AXI-Stream.
    `include "axis_utils.sv"
    `include "axis_agent_cfg_base.sv"
    `include "axis_seq_item_lib.sv"
    `include "axis_sequencer_base.sv"
    `include "axis_sequence_lib.sv"
    `include "axis_driver_lib.sv"
    `include "axis_monitor_base.sv"
    `include "axis_agent_base.sv"

endpackage
