/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

`include "load_defines.svh"

// Пакет компонентов load.

package load_pkg;

    import common_pkg::*;
    import axis_pkg::*;

    // Подключение компонентов и объектов load.
    `include "load_utils.sv"
    `include "load_agent_cfg_base.sv"
    `include "load_seq_item_lib.sv"
    `include "load_cov_collector_cfg.sv"
    `include "load_coverage.sv"
    `include "load_cov_collector.sv"
    `include "load_sequencer_base.sv"
    `include "load_sequence_lib.sv"
    `include "load_driver.sv"
    `include "load_monitor_base.sv"
    `include "load_agent_base.sv"

endpackage
