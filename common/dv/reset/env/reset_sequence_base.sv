/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

// Sequence для генерации транзакций типа ~reset_seq_item_base~.

class reset_sequence_base extends
    common_sequence#(reset_seq_item_base);

    // В задаче ~body()~ генерируются полезные данные.
    // Обратите внимание, что транзакция формируется
    // между ~start_item(data)~ и ~finish_item(data)~.

    virtual task body();
        req = get_item();
        start_item(req);
        if( !req.randomize() ) begin
            $fatal(1, "Can't rand. 'req'!");
        end
        finish_item(req);
    endtask

    // Пользовательская функция, возвращающая тран-
    // закцию типа ~reset_seq_item_base~ или наследо-
    // ванного от нее (через upcasting).

    //  ------------------ Важно! -------------------
    // | Обратите внимание, что каждый раз создается |
    // | новый объект транзакции.                    |
    //  ------------------ Важно! -------------------

    virtual function reset_seq_item_base get_item();
        reset_seq_item_base t = new();
        return t;
    endfunction

endclass
