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
    load_sequencer_base p_sqr;

    virtual task start(common_sequencer#(REQ) sqr);
        if( !$cast(p_sqr, sqr) ) begin
            $fatal(1, "Can't cast 'sqr' to 'load_sequencer_base'!");
        end
        super.start(sqr);
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

    virtual task body();
        req = get_item();
        start_item(req);
        if( !req.randomize() ) begin
            $fatal(1, "Can't rand. 'req'!");
        end
        finish_item(req);
    endtask

endclass
