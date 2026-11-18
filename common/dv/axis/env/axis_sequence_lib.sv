/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

// Базовая последовательность AXI-Stream.

class axis_sequence_base extends
    common_sequence#(axis_seq_item_base);

    // Типизированный указатель на sequencer.
    axis_sequencer_base p_sqr;

    // Количество транзакций в sequence.
    rand int trans_am;

    // Диапазон задержки перед очередной передачей.
    int unsigned delay_min = 0;
    int unsigned delay_max = 10;

    virtual task body();
        $fatal(1, "This task must be overriden by sequence!");
    endtask

    virtual task start(common_sequencer#(REQ) sqr);
        if( !$cast(p_sqr, sqr) ) begin
            $fatal(1, "Can't cast 'sqr' to 'axis_sequencer_base'!");
        end
        super.start(sqr);
    endtask

    // Проброс конфигурации в транзакцию осуществляется
    // через переопределение базового API.
    virtual task start_item(axis_seq_item_base t);
        super.start_item(t);
        t.cfg = p_sqr.cfg;
    endtask

    // Создание базовой транзакции.
    virtual function axis_seq_item_base get_item();
        axis_seq_item_base t = new();
        return t;
    endfunction

    // Ограничение на количество транзакций (если
    // sequence будет рандомизирована).
    constraint trans_am_c {soft trans_am inside {[100:200]};};

endclass

// Последовательность master.

class axis_sequence_master extends axis_sequence_base;

    virtual task body();
        repeat(trans_am) begin
            req = get_item();
            start_item(req);
            if( !req.randomize() with {
                delay inside {[delay_min:delay_max]};
            } ) begin
                $fatal(1, "Can't rand. 'req'!");
            end
            finish_item(req);
        end
    endtask

endclass

// Последовательность slave.
// Значение ~trans_am = -1~ означает бесконечную генерацию.

class axis_sequence_slave extends axis_sequence_base;

    // Режим ожидания.
    rand axis_tready_mode_e tready_mode;

    virtual function axis_seq_item_slave get_item();
        axis_seq_item_slave t = new();
        return t;
    endfunction

    virtual task body();
        int trans_cnt;
        while( (trans_am == -1) || (trans_cnt < trans_am) ) begin
            req = get_item();
            start_item(req);
            begin
                axis_seq_item_slave slave_req;
                if( !$cast(slave_req, req) ) begin
                    $fatal(1, "Can't cast 'req' to 'axis_seq_item_slave'!");
                end
                if( !slave_req.randomize() with {
                    delay inside {[delay_min:delay_max]};
                    tready_mode == local::tready_mode;
                } ) begin
                    $fatal(1, "Can't rand. 'req'!");
                end
            end
            finish_item(req);
            trans_cnt++;
        end
    endtask

endclass
