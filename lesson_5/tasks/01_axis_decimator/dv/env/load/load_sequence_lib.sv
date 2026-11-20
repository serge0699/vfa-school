/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

// Последовательность load.

class load_sequence_base extends
    common_sequence#(load_seq_item_base);

    // Типизированный указатель на sequencer.

    //  -------------------- TODO --------------------
    // | Объявите типизированный указатель ~p_sqr~ на |
    // | ~load_sequencer_base~.                       |
    //  -------------------- TODO --------------------

    // TODO: Объявление.

    //  ----------------------- TODO ------------------------
    // | Приведите sequencer к типу ~p_sqr~ через ~$cast()~. |
    // | При ошибке вызовите ~$fatal()~. Затем вызовите      |
    // | родительский метод ~start()~.                       |
    //  ----------------------- TODO ------------------------

    virtual task start(common_sequencer#(REQ) sqr);

        // TODO: Реализация метода.

    endtask

    // Проброс конфигурации в транзакцию осуществляется
    // через переопределение базового API.
    virtual task start_item(load_seq_item_base t);
        super.start_item(t);
        t.cfg = p_sqr.cfg;
    endtask

    // Создание базовой транзакции.
    virtual function load_seq_item_base get_item();
        load_seq_item_base t = new();
        return t;
    endfunction

    //  --------------------- TODO ---------------------
    // | 1. Создайте транзакцию через ~get_item()~.     |
    // | 2. Вызовите ~start_item()~ и рандомизируйте    |
    // |    транзакцию. При ошибке вызовите ~$fatal()~. |
    // | 3. Отправьте транзакцию через ~finish_item()~. |
    //  --------------------- TODO ---------------------

    virtual task body();

        // TODO: Реализация метода.

    endtask

endclass
