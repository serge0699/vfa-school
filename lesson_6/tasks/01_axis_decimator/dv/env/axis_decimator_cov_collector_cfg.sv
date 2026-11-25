/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

// ???

class axis_decimator_cov_collector_cfg;

    // Ширина настройки прореживания.
    int unsigned load_dec_width;

    // Функция вывода информации о конфигурации.
    virtual function string convert2string();
        string str;
        str = {str, $sformatf("\n| load_dec_width: %0d", load_dec_width)};
        return str;
    endfunction

endclass
