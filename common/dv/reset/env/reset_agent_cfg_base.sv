/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

// Конфигурация агента сигнала сброса.

class reset_agent_cfg_base;

    // Интерфейс.
    virtual reset_intf vif;

    // Активный уровень.
    bit active_level = 1'b1;

    // Информация о конфигурации агента.
    virtual function string convert2string();
        string str;
        str = {str, $sformatf("\n| active_level : %1b", active_level)};
        return str;
    endfunction

endclass
