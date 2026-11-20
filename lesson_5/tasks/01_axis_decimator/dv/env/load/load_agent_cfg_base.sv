/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

// Класс конфигурации агента.

class load_agent_cfg_base;

    // Интерфейс и ширина шины.
    virtual load_intf vif;

    int unsigned dec_width;

    // Функция вывода информации о конфигурации.
    virtual function string convert2string();
        string str;
        str = {str, $sformatf("\n| dec_width    : %0d", dec_width)};
        return str;
    endfunction

endclass
