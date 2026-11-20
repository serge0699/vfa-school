/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

// Класс транзакции. Иначе sequence item.
// Транзакция рандомизируется в sequence.

class load_seq_item_base;

    // Конфигурация агента.
    load_agent_cfg_base cfg;

    //  -------------------- TODO ---------------------
    // | Объявите рандомизируемое поле ~dec~ типа      |
    // | ~load_dec_t~. Ограничьте его значение шириной |
    // | ~cfg.dec_width~.                              |
    //  -------------------- TODO ---------------------

    // TODO: Объявление.

    // Функция вывода информации о транзакции.
    virtual function string convert2string();
        string str;
        str = {str, $sformatf("\ndec        : %0h", axis_bitsel_u(dec, cfg.dec_width - 1, 0))};
        return str;
    endfunction

endclass
