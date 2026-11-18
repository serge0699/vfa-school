/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

// Пакет верификационных компонентов генерации
// сигнала сброса.

package reset_pkg;

    // Импорт универсальных компонентов и объектов.
    import common_pkg::*;

    // Подключение компонентов и объектов 
    // для генерации сигнала сброса.
    `include "reset_agent_cfg_base.sv"
    `include "reset_seq_item_base.sv"
    `include "reset_sequencer_base.sv"
    `include "reset_sequence_base.sv"
    `include "reset_driver_base.sv"
    `include "reset_monitor_base.sv"
    `include "reset_agent_base.sv"

endpackage
