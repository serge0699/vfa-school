/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

// Класс транзакции. Иначе sequence item.
// Транзакция рандомизиуруется в sequence.
class reset_seq_item_base;

    // Настройка длительности активного
    // уровня сигнала сброса в положи-
    // тельных фронтах тактового сигнала.
    rand int unsigned duration = 1;

    // Настройка длительности "перерыва"
    // между генерациями активного уровня
    // сигнала сброса в положительных
    // фронтах тактового сигнала.
    rand int unsigned delay;

    constraint duration_c { soft duration inside {[1:5]}; }
    constraint delay_c    { soft delay == 0; }

    // Информация о полях транзакции.
    virtual function string convert2string();
        string str;
        str = {str, $sformatf("\nduration: %0d", duration)};
        str = {str, $sformatf("\ndelay   : %0d", delay   )};
        return str;
    endfunction

endclass
